
import torch
import pytest

class Value:
    def __init__(self, val, prev=(), op='', label=''):
        self.val       = val
        self.prev      = tuple(prev)
        self.op        = op
        self.label     = label
        self.grad      = 0.0
        self._backward = lambda: None

    def __add__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out   = Value(self.val + other.val, (self, other), op='+')
        def _back():
            self.grad  += out.grad
            other.grad += out.grad
        out._backward = _back
        return out

    def __mul__(self, other):
        other = other if isinstance(other, Value) else Value(other)
        out   = Value(self.val * other.val, (self, other), op='*')
        def _back():
            self.grad  += other.val * out.grad
            other.grad += self.val  * out.grad
        out._backward = _back
        return out

    def __pow__(self, other):
        assert isinstance(other, (int, float))
        out = Value(self.val ** other, (self,), op=f'**{other}')
        def _back():
            self.grad += other * (self.val ** (other - 1)) * out.grad
        out._backward = _back
        return out

    def relu(self):
        out = Value(max(0, self.val), (self,), op='ReLU')
        def _back():
            self.grad += (out.val > 0) * out.grad
        out._backward = _back
        return out

    def __neg__(self):             return self * -1
    def __radd__(self, other):     return self + other
    def __sub__(self, other):      return self + (-other)
    def __rsub__(self, other):     return other + (-self)
    def __truediv__(self, other):  return self * (other ** -1)
    def __rtruediv__(self, other): return other * (self ** -1)
    def __rmul__(self, other):     return self * other
    def __iadd__(self, other):     return self + other
    def __imul__(self, other):     return self * other

    def backward(self):
        topo, visited = [], set()
        def build(v):
            if v not in visited:
                visited.add(v)
                for child in v.prev:
                    build(child)
                topo.append(v)
        build(self)
        for node in topo:
            node.grad = 0.0
        self.grad = 1.0
        for v in reversed(topo):
            v._backward()

    def __repr__(self):
        return f'Value(val={self.val:.4f}, grad={self.grad:.4f})'


# ── Tests ─────────────────────────────────────────────────────────────────────

def test_sanity_check():
    x = Value(-4.0)
    z = 2 * x + 2 + x
    q = z.relu() + z * x
    h = (z * z).relu()
    y = h + q + q * x
    y.backward()
    xmg, ymg = x, y

    xt = torch.tensor([-4.0], dtype=torch.float64, requires_grad=True)
    z  = 2 * xt + 2 + xt
    q  = z.relu() + z * xt
    h  = (z * z).relu()
    y  = h + q + q * xt
    y.backward()

    assert ymg.val  == y.data.item(),      f"forward:  {ymg.val} != {y.data.item()}"
    assert xmg.grad == xt.grad.item(),     f"backward: {xmg.grad} != {xt.grad.item()}"


def test_more_ops():
    a = Value(-4.0)
    b = Value(2.0)
    c = a + b
    d = a * b + b**3
    c += c + 1
    c += 1 + c + (-a)
    d += d * 2 + (b + a).relu()
    d += 3 * d + (b - a).relu()
    e = c - d
    f = e**2
    g = f / 2.0
    g += 10.0 / f
    g.backward()
    amg, bmg, gmg = a, b, g

    a = torch.tensor([-4.0], dtype=torch.float64, requires_grad=True)
    b = torch.tensor([ 2.0], dtype=torch.float64, requires_grad=True)
    c = a + b
    d = a * b + b**3
    c = c + c + 1
    c = c + 1 + c + (-a)
    d = d + d * 2 + (b + a).relu()
    d = d + 3 * d + (b - a).relu()
    e = c - d
    f = e**2
    g = f / 2.0
    g = g + 10.0 / f
    g.backward()

    tol = 1e-6
    assert abs(gmg.val  - g.data.item())    < tol, f"forward g:  {gmg.val} != {g.data.item()}"
    assert abs(amg.grad - a.grad.item())    < tol, f"backward a: {amg.grad} != {a.grad.item()}"
    assert abs(bmg.grad - b.grad.item())    < tol, f"backward b: {bmg.grad} != {b.grad.item()}"
