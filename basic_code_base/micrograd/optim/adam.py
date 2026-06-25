"""
optim/adam.py
─────────────
Adam and AdamW optimizers.

Adam  (Kingma & Ba, 2015)      — adaptive moment estimation
AdamW (Loshchilov & Hutter, 2019) — decoupled weight decay

Key difference
──────────────
Adam folds weight decay into the gradient before the moment update:
    g ← g + λ·p
This undesirably couples λ with the adaptive scaling of Adam.

AdamW applies weight decay *after* the Adam update, directly on the
parameter — decoupled from the gradient moments:
    p ← p - α·(m̂ / (√v̂ + ε))  -  α·λ·p
This matches the paper and torch.optim.AdamW exactly.
"""

from optim.base import Optimizer
import math


class Adam(Optimizer):
    """
    Adam optimizer.

    Update rule
    ───────────
        g  = grad + wd·p               (L2 folded into gradient)
        m  ← β₁·m + (1-β₁)·g
        v  ← β₂·v + (1-β₂)·g²
        m̂  = m  / (1 - β₁ᵗ)
        v̂  = v  / (1 - β₂ᵗ)
        p  ← p - lr · m̂ / (√v̂ + ε)

    Parameters
    ----------
    params       : iterable[Value]
    lr           : float  — step size α
    betas        : (β₁, β₂) — exponential decay rates for moments
    eps          : float  — denominator numerical stability term ε
    weight_decay : float  — L2 coefficient (coupled, see AdamW for decoupled)
    """

    def __init__(self, params, lr: float = 1e-3, betas=(0.9, 0.999),
                 eps: float = 1e-8, weight_decay: float = 0.0):
        super().__init__(params)
        self.lr           = lr
        self.b1, self.b2  = betas
        self.eps          = eps
        self.weight_decay = weight_decay
        self._m = {id(p): 0.0 for p in self.params}   # 1st moment
        self._v = {id(p): 0.0 for p in self.params}   # 2nd moment

    def step(self) -> None:
        self._step += 1
        # bias-correction denominators
        bc1 = 1.0 - self.b1 ** self._step
        bc2 = 1.0 - self.b2 ** self._step

        for p in self.params:
            g   = p.grad + self.weight_decay * p.val   # L2 in gradient
            pid = id(p)
            self._m[pid] = self.b1 * self._m[pid] + (1.0 - self.b1) * g
            self._v[pid] = self.b2 * self._v[pid] + (1.0 - self.b2) * g * g
            m_hat = self._m[pid] / bc1
            v_hat = self._v[pid] / bc2
            p.val -= self.lr * m_hat / (math.sqrt(v_hat) + self.eps)

    def __repr__(self):
        return (f"Adam(lr={self.lr}, betas=({self.b1},{self.b2}), "
                f"eps={self.eps}, weight_decay={self.weight_decay})")


class AdamW(Optimizer):
    """
    AdamW — decoupled weight decay regularisation.

    Update rule
    ───────────
        g  = grad                               (no wd in gradient!)
        m  ← β₁·m + (1-β₁)·g
        v  ← β₂·v + (1-β₂)·g²
        m̂  = m  / (1 - β₁ᵗ)
        v̂  = v  / (1 - β₂ᵗ)
        p  ← p - lr · (m̂ / (√v̂ + ε) + λ·p)   # wd applied directly to p

    Parameters
    ----------
    params       : iterable[Value]
    lr           : float
    betas        : (β₁, β₂)
    eps          : float
    weight_decay : float  — decoupled weight decay λ (default 1e-2 per paper)
    """

    def __init__(self, params, lr: float = 1e-3, betas=(0.9, 0.999),
                 eps: float = 1e-8, weight_decay: float = 1e-2):
        super().__init__(params)
        self.lr           = lr
        self.b1, self.b2  = betas
        self.eps          = eps
        self.weight_decay = weight_decay
        self._m = {id(p): 0.0 for p in self.params}
        self._v = {id(p): 0.0 for p in self.params}

    def step(self) -> None:
        self._step += 1
        bc1 = 1.0 - self.b1 ** self._step
        bc2 = 1.0 - self.b2 ** self._step

        for p in self.params:
            g   = p.grad                        # weight decay NOT in gradient
            pid = id(p)
            self._m[pid] = self.b1 * self._m[pid] + (1.0 - self.b1) * g
            self._v[pid] = self.b2 * self._v[pid] + (1.0 - self.b2) * g * g
            m_hat = self._m[pid] / bc1
            v_hat = self._v[pid] / bc2
            # decoupled: wd applied directly to parameter, not scaled by moments
            p.val -= self.lr * (
                m_hat / (math.sqrt(v_hat) + self.eps) + self.weight_decay * p.val
            )

    def __repr__(self):
        return (f"AdamW(lr={self.lr}, betas=({self.b1},{self.b2}), "
                f"weight_decay={self.weight_decay})")