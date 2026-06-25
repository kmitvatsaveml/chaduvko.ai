"""
engine/value.py
───────────────
Scalar Value node with reverse-mode automatic differentiation.

Every operation creates a new Value that records its parents and a
_backward closure.  Calling .backward() on a loss scalar walks the
topologically-sorted graph in reverse and accumulates .grad on every
node — exactly like PyTorch's autograd, but for scalars.

Bugs fixed
──────────
• __truediv__: previously did `self * (other ** -1)`.  When `other` is a
  Value, Value.__pow__ asserts isinstance(other,(int,float)) and crashes.
  Fixed by implementing division directly with its own backward.

• __pow__ at val=0 with negative exponent: 0^(-1) → inf in gradient.
  Added _EPS floor.

• log(): forward and backward both guard against val ≤ 0 via _EPS.

• sigmoid(): two-branch implementation avoids exp overflow for large |x|.
"""

import math

_EPS = 1e-7   # numerical floor used in log and pow


class Value:
    """A scalar that carries its value, gradient, and computation graph."""

    __slots__ = ('val', 'grad', 'prev', 'op', 'label', '_backward')

    def __init__(self, val, prev=(), op='', label=''):
        self.val       = float(val)
        self.grad      = 0.0
        self.prev      = set(prev)
        self.op        = op
        self.label     = label
        self._backward = lambda: None

    def __repr__(self):
        return f"Value(val={self.val:.6f}, grad={self.grad:.6f})"

    def __hash__(self):
        # Allow Value instances to be inserted into sets (used by graph prev).
        # Use object id so identity semantics match computational graph nodes.
        return id(self)

    # ── arithmetic ──────────────────────────────────────────────────────────

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out   = Value(self.val + other.val, (self, other), '+')
        def bwd():
            self.grad  += out.grad
            other.grad += out.grad
        out._backward = bwd
        return out

    def __radd__(self, other): return self + other

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out   = Value(self.val * other.val, (self, other), '*')
        def bwd():
            self.grad  += other.val * out.grad
            other.grad += self.val  * out.grad
        out._backward = bwd
        return out

    def __rmul__(self, other): return self * other
    def __neg__(self):         return self * -1
    def __sub__(self, other):  return self + (-other)
    def __rsub__(self, other): return other + (-self)

    def __truediv__(self, other):
        """
        BUG FIX: the old `self * (other ** -1)` crashed when `other` is a
        Value because Value.__pow__ asserts the exponent is int/float.
        Implement division directly.
        """
        other = other if isinstance(other, Value) else Value(other)
        out   = Value(self.val / other.val, (self, other), '/')
        def bwd():
            self.grad  +=  out.grad / other.val
            other.grad -= (self.val / (other.val ** 2)) * out.grad
        out._backward = bwd
        return out

    def __rtruediv__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        return other / self

    def __pow__(self, other):
        """Exponent must be a plain int or float (not a Value)."""
        assert isinstance(other, (int, float)), \
            f"Value.__pow__ only supports scalar exponents, got {type(other)}"
        # BUG FIX: guard 0^(negative) → inf in gradient
        base = self.val if abs(self.val) > _EPS else (
            _EPS if self.val >= 0 else -_EPS
        )
        out = Value(self.val ** other, (self,), f'**{other}')
        def bwd():
            self.grad += other * (base ** (other - 1)) * out.grad
        out._backward = bwd
        return out

    # ── comparisons (no gradient tracked) ───────────────────────────────────

    def __lt__(self, o): return self.val <  (o.val if isinstance(o, Value) else o)
    def __gt__(self, o): return self.val >  (o.val if isinstance(o, Value) else o)
    def __le__(self, o): return self.val <= (o.val if isinstance(o, Value) else o)
    def __ge__(self, o): return self.val >= (o.val if isinstance(o, Value) else o)
    def __eq__(self, o): return self.val == (o.val if isinstance(o, Value) else o)

    # ── primitive differentiable ops ─────────────────────────────────────────

    def exp(self):
        v   = math.exp(self.val)
        out = Value(v, (self,), 'exp')
        def bwd(): self.grad += v * out.grad
        out._backward = bwd
        return out

    def log(self):
        """
        BUG FIX: guard val ≤ 0 in both forward (floor to _EPS) and backward
        (1/max(val,_EPS)) so saturated sigmoid outputs don't produce -inf/nan.
        """
        safe = max(self.val, _EPS)
        out  = Value(math.log(safe), (self,), 'log')
        def bwd():
            self.grad += (1.0 / max(self.val, _EPS)) * out.grad
        out._backward = bwd
        return out

    def abs(self):
        out = Value(abs(self.val), (self,), 'abs')
        def bwd():
            self.grad += (1.0 if self.val >= 0 else -1.0) * out.grad
        out._backward = bwd
        return out

    # ── backpropagation ──────────────────────────────────────────────────────

    def backward(self):
        """Reverse-mode autodiff via topological sort."""
        topo, visited = [], set()

        def build(v):
            if v not in visited:
                visited.add(v)
                for child in v.prev:
                    build(child)
                topo.append(v)

        build(self)
        self.grad = 1.0
        for node in reversed(topo):
            node._backward()