"""
engine/activations.py
─────────────────────
All activation functions as standalone callables that operate on Value nodes.

Each function:
  • takes a Value  →  returns a Value
  • stores the correct analytic gradient in _backward
  • is registered in ACTIVATIONS dict for use by Neuron/Layer

Activations
───────────
  relu, sigmoid, tanh, leaky_relu, elu, selu,
  gelu, swish, mish, softplus, hardswish, hardsigmoid, linear

Kaiming/Xavier gain table
─────────────────────────
Bug fixed: previously only 'relu' received kaiming gain; all other
ReLU-family activations (leaky_relu, elu, selu, gelu, swish, mish,
hardswish) also need sqrt(2/n), not sqrt(1/n).
"""

import math
from engine.value import Value


# ─────────────────────────────────────────────────────────────────────────────
#  ACTIVATION FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────

def relu(x: Value) -> Value:
    """ReLU: max(0, x)"""
    out = Value(max(0.0, x.val), (x,), 'ReLU')
    def bwd(): x.grad += (1.0 if out.val > 0 else 0.0) * out.grad
    out._backward = bwd
    return out


def sigmoid(x: Value) -> Value:
    """
    σ(x) = 1 / (1 + e^{-x}).
    Two-branch for numerical stability: avoids exp overflow for large |x|.
    """
    if x.val >= 0:
        s = 1.0 / (1.0 + math.exp(-x.val))
    else:
        e = math.exp(x.val)
        s = e / (1.0 + e)
    out = Value(s, (x,), 'σ')
    def bwd(): x.grad += s * (1.0 - s) * out.grad
    out._backward = bwd
    return out


def tanh(x: Value) -> Value:
    """tanh(x)"""
    t   = math.tanh(x.val)
    out = Value(t, (x,), 'tanh')
    def bwd(): x.grad += (1.0 - t * t) * out.grad
    out._backward = bwd
    return out


def leaky_relu(x: Value, alpha: float = 0.01) -> Value:
    """LeakyReLU: x if x > 0 else alpha * x"""
    v   = x.val if x.val > 0 else alpha * x.val
    out = Value(v, (x,), 'LReLU')
    def bwd(): x.grad += (1.0 if x.val > 0 else alpha) * out.grad
    out._backward = bwd
    return out


def elu(x: Value, alpha: float = 1.0) -> Value:
    """ELU: x if x ≥ 0 else alpha * (e^x - 1)"""
    if x.val >= 0:
        v = x.val
    else:
        v = alpha * (math.exp(x.val) - 1.0)
    out = Value(v, (x,), 'ELU')
    def bwd():
        dv = 1.0 if x.val >= 0 else (v + alpha)
        x.grad += dv * out.grad
    out._backward = bwd
    return out


def selu(x: Value) -> Value:
    """SELU with canonical Klambauer et al. constants."""
    _ALPHA = 1.6732631921768188
    _SCALE = 1.0507009873554805
    elu_v  = x.val if x.val >= 0 else _ALPHA * (math.exp(x.val) - 1.0)
    out    = Value(_SCALE * elu_v, (x,), 'SELU')
    def bwd():
        if x.val >= 0:
            x.grad += _SCALE * out.grad
        else:
            x.grad += _SCALE * _ALPHA * math.exp(x.val) * out.grad
    out._backward = bwd
    return out


def gelu(x: Value) -> Value:
    """GELU (tanh approximation): x · Φ(x)"""
    _C     = math.sqrt(2.0 / math.pi)
    _COEF  = 0.044715
    inner  = _C * (x.val + _COEF * x.val ** 3)
    t      = math.tanh(inner)
    v      = 0.5 * x.val * (1.0 + t)
    out    = Value(v, (x,), 'GELU')
    def bwd():
        dtanh  = 1.0 - t * t
        dinner = _C * (1.0 + 3 * _COEF * x.val ** 2)
        x.grad += (0.5 * (1.0 + t) + 0.5 * x.val * dtanh * dinner) * out.grad
    out._backward = bwd
    return out


def swish(x: Value) -> Value:
    """Swish / SiLU: x · σ(x)"""
    s   = 1.0 / (1.0 + math.exp(-x.val))
    v   = x.val * s
    out = Value(v, (x,), 'Swish')
    def bwd(): x.grad += (s + x.val * s * (1.0 - s)) * out.grad
    out._backward = bwd
    return out


def mish(x: Value) -> Value:
    """Mish: x · tanh(softplus(x)).  Uses log1p for numerical stability."""
    sp  = math.log1p(math.exp(x.val))   # softplus, stable via log1p
    t   = math.tanh(sp)
    v   = x.val * t
    out = Value(v, (x,), 'Mish')
    def bwd():
        s      = 1.0 / (1.0 + math.exp(-x.val))   # sigmoid
        dtanh  = 1.0 - t * t
        x.grad += (t + x.val * dtanh * s) * out.grad
    out._backward = bwd
    return out


def softplus(x: Value, beta: float = 1.0) -> Value:
    """Softplus: (1/β) · log(1 + e^{βx})"""
    bx  = beta * x.val
    v   = math.log1p(math.exp(bx)) / beta
    out = Value(v, (x,), 'Softplus')
    def bwd(): x.grad += (1.0 / (1.0 + math.exp(-bx))) * out.grad
    out._backward = bwd
    return out


def hardswish(x: Value) -> Value:
    """Hard-Swish: x · ReLU6(x+3) / 6"""
    xv = x.val
    if xv <= -3.0:
        v, dv = 0.0, 0.0
    elif xv >= 3.0:
        v, dv = xv, 1.0
    else:
        v  = xv * (xv + 3.0) / 6.0
        dv = (2.0 * xv + 3.0) / 6.0
    out = Value(v, (x,), 'HSwish')
    def bwd(): x.grad += dv * out.grad
    out._backward = bwd
    return out


def hardsigmoid(x: Value) -> Value:
    """Hard-Sigmoid: clamp((x + 3) / 6, 0, 1)"""
    xv = x.val
    v  = max(0.0, min(1.0, (xv + 3.0) / 6.0))
    dv = 1.0 / 6.0 if -3.0 < xv < 3.0 else 0.0
    out = Value(v, (x,), 'HSig')
    def bwd(): x.grad += dv * out.grad
    out._backward = bwd
    return out


def linear(x: Value) -> Value:
    """Identity / no-op activation."""
    return x


# ─────────────────────────────────────────────────────────────────────────────
#  REGISTRY
# ─────────────────────────────────────────────────────────────────────────────

ACTIVATIONS: dict = {
    'relu':        relu,
    'sigmoid':     sigmoid,
    'tanh':        tanh,
    'leaky_relu':  leaky_relu,
    'elu':         elu,
    'selu':        selu,
    'gelu':        gelu,
    'swish':       swish,
    'mish':        mish,
    'softplus':    softplus,
    'hardswish':   hardswish,
    'hardsigmoid': hardsigmoid,
    'linear':      linear,
}

# ─────────────────────────────────────────────────────────────────────────────
#  KAIMING / XAVIER GAIN TABLE
#
#  BUG FIX: previously only 'relu' was marked as needing kaiming gain.
#  All ReLU-family activations need sqrt(2/n); saturating ones need sqrt(1/n).
# ─────────────────────────────────────────────────────────────────────────────

#: Activations that use kaiming-normal init: gain = sqrt(2 / fan_in)
KAIMING_ACTS = frozenset({
    'relu', 'leaky_relu', 'elu', 'selu', 'gelu', 'swish', 'mish', 'hardswish',
})

#: Activations that use xavier/glorot init: gain = sqrt(1 / fan_in)
XAVIER_ACTS = frozenset({
    'sigmoid', 'tanh', 'linear', 'softplus', 'hardsigmoid',
})


def init_std(activation: str, fan_in: int) -> float:
    """
    Return the recommended weight std for the given activation and fan-in.

    Uses Kaiming-normal for ReLU-family (He et al., 2015) and
    Xavier/Glorot for saturating functions (Glorot & Bengio, 2010).
    """
    if activation in KAIMING_ACTS:
        return (2.0 / fan_in) ** 0.5
    return (1.0 / fan_in) ** 0.5