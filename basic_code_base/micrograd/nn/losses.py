"""
nn/losses.py
────────────
Loss functions that operate on Value nodes and return a scalar Value loss.

Losses
──────
  mse_loss              — Mean Squared Error
  binary_cross_entropy  — BCE for binary classification (sigmoid outputs)
  cross_entropy         — Softmax + NLL for multi-class classification

Bug fixed
─────────
BUG (critical): The original binary_cross_entropy wrapped each sigmoid
output in `Value(max(eps, min(1-eps, p.val)))`.  This created a BRAND-NEW
disconnected leaf node — the computation graph was severed and no gradient
could flow back into the network.  Loss was frozen at ln(2) ≈ 0.693 for
every optimizer.

Fix: pass the sigmoid Value directly.  Value.log() has an internal _EPS
floor so extreme values (saturated sigmoid) are handled numerically without
breaking the graph.

BUG (cross_entropy): the original implementation created `exps` from
disconnected Value(math.exp(...)) nodes (dead code), then recomputed with
a properly connected graph — but also tried to use Value / Value which
crashes because Value.__pow__ rejects Value exponents.  Fixed by using the
properly implemented Value.__truediv__.
"""

from engine.value import Value


def mse_loss(preds: list, targets) -> Value:
    """
    Mean Squared Error: (1/N) · Σ (pred - target)²

    Parameters
    ----------
    preds   : list[Value]
    targets : list[Value | float]
    """
    assert len(preds) == len(targets), \
        f"preds length {len(preds)} != targets length {len(targets)}"
    n     = len(preds)
    t_val = [t if isinstance(t, Value) else Value(t) for t in targets]
    total = sum(((p - t) ** 2 for p, t in zip(preds, t_val)), Value(0.0))
    return total * (1.0 / n)


def binary_cross_entropy(preds_sigmoid: list, targets) -> Value:
    """
    Binary Cross-Entropy for sigmoid outputs.

        BCE = -(1/N) · Σ [ y·log(p) + (1-y)·log(1-p) ]

    Parameters
    ----------
    preds_sigmoid : list[Value]
        Outputs of .sigmoid(), values in (0, 1).  Must still be
        connected to the computation graph — do NOT wrap in Value(p.val).
    targets : list[float]
        Ground-truth labels, 0 or 1.

    BUG FIX: pass sigmoid Values directly; Value.log() guards val ≤ 0.
    """
    assert len(preds_sigmoid) == len(targets)
    losses = []
    for p, t in zip(preds_sigmoid, targets):
        one_minus_p = Value(1.0) - p           # still in the graph
        losses.append(-(t * p.log() + (1.0 - t) * one_minus_p.log()))
    return sum(losses, Value(0.0)) * (1.0 / len(losses))


def cross_entropy(logits: list, target_idx: int) -> Value:
    """
    Softmax + Negative Log-Likelihood for multi-class classification.

        loss = -log( exp(logit[target]) / Σ exp(logit[i]) )

    Numerically stable: subtracts max(logits) before exp.

    Parameters
    ----------
    logits     : list[Value]  — raw (pre-softmax) scores
    target_idx : int          — ground-truth class index

    BUG FIX vs original:
    • Removed dead `exps` computation that used disconnected Value(math.exp(...)).
    • Division now uses Value.__truediv__ (implemented with its own backward)
      instead of `other ** -1` which crashed on Value exponents.
    """
    # stability shift: subtract max (constant, no gradient effect)
    max_v   = max(l.val for l in logits)
    shifted = [l - Value(max_v) for l in logits]
    exps    = [l.exp() for l in shifted]               # connected to graph ✓
    denom   = sum(exps, Value(0.0))
    probs   = [e / denom for e in exps]                # Value.__truediv__ ✓
    return -(probs[target_idx].log())