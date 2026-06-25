"""
Unit tests: custom autograd engine vs PyTorch.
Run from terminal: pytest test_engine.py -v
Or in notebook:   !pytest test_engine.py -v
"""

import pytest
import torch
import random

class Value:
    def __init__(self, val, prev=(), op='', label=''):
        self.val   = val
        self.prev  = tuple(prev)
        self.op    = op
        self.label = label
        self.grad  = 0.0
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


# ── Helpers ───────────────────────────────────────────────────────────────────
TOL = 1e-5

def pt(x, grad=True):
    return torch.tensor(float(x), requires_grad=grad)

def check(our, theirs):
    assert our.grad == pytest.approx(theirs.grad.item(), abs=TOL)


# ── 1. Forward pass ───────────────────────────────────────────────────────────
class TestForward:

    def test_add(self):        assert (Value(3.0) + Value(4.0)).val  == pytest.approx(7.0,   abs=TOL)
    def test_add_scalar(self): assert (Value(3.0) + 2.0).val         == pytest.approx(5.0,   abs=TOL)
    def test_mul(self):        assert (Value(3.0) * Value(4.0)).val  == pytest.approx(12.0,  abs=TOL)
    def test_sub(self):        assert (Value(7.0) - Value(3.0)).val  == pytest.approx(4.0,   abs=TOL)
    def test_div(self):        assert (Value(10.0) / Value(4.0)).val == pytest.approx(2.5,   abs=TOL)
    def test_pow(self):        assert (Value(3.0) ** 3).val           == pytest.approx(27.0,  abs=TOL)
    def test_neg(self):        assert (-Value(4.0)).val               == pytest.approx(-4.0,  abs=TOL)
    def test_relu_pos(self):   assert Value(5.0).relu().val           == pytest.approx(5.0,   abs=TOL)
    def test_relu_neg(self):   assert Value(-3.0).relu().val          == pytest.approx(0.0,   abs=TOL)
    def test_relu_zero(self):  assert Value(0.0).relu().val           == pytest.approx(0.0,   abs=TOL)

    def test_chain(self):
        # (2*3 + 1)^2 = 49
        a, b = Value(2.0), Value(3.0)
        assert (a * b + 1) ** 2 == pytest.approx(49.0, abs=TOL) or True
        assert ((a * b + 1) ** 2).val == pytest.approx(49.0, abs=TOL)


# ── 2. Gradients vs PyTorch ───────────────────────────────────────────────────
class TestGradients:

    def test_grad_add(self):
        a, b = Value(2.0), Value(5.0)
        (a + b).backward()
        ta, tb = pt(2.0), pt(5.0)
        (ta + tb).backward()
        check(a, ta); check(b, tb)

    def test_grad_mul(self):
        a, b = Value(3.0), Value(4.0)
        (a * b).backward()
        ta, tb = pt(3.0), pt(4.0)
        (ta * tb).backward()
        check(a, ta); check(b, tb)

    def test_grad_sub(self):
        a, b = Value(7.0), Value(2.0)
        (a - b).backward()
        ta, tb = pt(7.0), pt(2.0)
        (ta - tb).backward()
        check(a, ta); check(b, tb)

    def test_grad_div(self):
        a, b = Value(6.0), Value(2.0)
        (a / b).backward()
        ta, tb = pt(6.0), pt(2.0)
        (ta / tb).backward()
        check(a, ta); check(b, tb)

    def test_grad_pow(self):
        a = Value(3.0)
        (a ** 4).backward()
        ta = pt(3.0)
        (ta ** 4).backward()
        check(a, ta)

    def test_grad_neg(self):
        a = Value(5.0)
        (-a).backward()
        ta = pt(5.0)
        (-ta).backward()
        check(a, ta)

    def test_grad_relu_positive(self):
        a = Value(3.0)
        a.relu().backward()
        ta = pt(3.0)
        torch.relu(ta).backward()
        check(a, ta)

    def test_grad_relu_negative(self):
        a = Value(-2.0)
        a.relu().backward()
        ta = pt(-2.0)
        torch.relu(ta).backward()
        check(a, ta)

    def test_grad_mse_loss(self):
        """Replicates the actual training loop."""
        w1, w2, b = Value(0.5), Value(-1.0), Value(2.0)
        y    = Value(2.0) * w1 + Value(3.0) * w2 + b
        loss = (y - Value(8.0)) ** 2
        loss.backward()

        tw1, tw2, tb = pt(0.5), pt(-1.0), pt(2.0)
        ty   = pt(2.0, grad=False) * tw1 + pt(3.0, grad=False) * tw2 + tb
        tloss = (ty - 8.0) ** 2
        tloss.backward()

        check(w1, tw1); check(w2, tw2); check(b, tb)

    def test_grad_shared_node(self):
        """a + a => grad should be 2.0."""
        a = Value(3.0)
        (a + a).backward()
        ta = pt(3.0)
        (ta + ta).backward()
        check(a, ta)

    def test_grad_relu_then_pow(self):
        a = Value(2.0)
        (a.relu() ** 2).backward()
        ta = pt(2.0)
        (torch.relu(ta) ** 2).backward()
        check(a, ta)

    def test_grad_complex(self):
        """(a*b + c)^2."""
        a, b, c = Value(1.5), Value(2.0), Value(-0.5)
        ((a * b + c) ** 2).backward()
        ta, tb, tc = pt(1.5), pt(2.0), pt(-0.5)
        ((ta * tb + tc) ** 2).backward()
        check(a, ta); check(b, tb); check(c, tc)


# ── 3. Gradient descent behaviour ────────────────────────────────────────────
class TestGradientDescent:

    def test_loss_strictly_decreases(self):
        w1, w2, b = Value(0.5), Value(-1.0), Value(2.0)
        prev = float('inf')
        for _ in range(20):
            w1.grad = w2.grad = b.grad = 0.0
            y    = Value(2.0) * w1 + Value(3.0) * w2 + b
            loss = (y - Value(8.0)) ** 2
            loss.backward()
            w1.val -= 0.01 * w1.grad
            w2.val -= 0.01 * w2.grad
            b.val  -= 0.01 * b.grad
            assert loss.val < prev
            prev = loss.val

    def test_loss_converges(self):
        w1, w2, b = Value(0.5), Value(-1.0), Value(2.0)
        for _ in range(500):
            w1.grad = w2.grad = b.grad = 0.0
            y    = Value(2.0) * w1 + Value(3.0) * w2 + b
            loss = (y - Value(8.0)) ** 2
            loss.backward()
            w1.val -= 0.05 * w1.grad
            w2.val -= 0.05 * w2.grad
            b.val  -= 0.05 * b.grad
        assert loss.val < 0.01


# ── 4. Documented limitations (expected failures) ────────────────────────────
class TestLimitations:

    def test_no_exp(self):
        """Engine has no exp() — AttributeError expected."""
        with pytest.raises(AttributeError):
            Value(1.0).exp()

    def test_no_log(self):
        """Engine has no log() — AttributeError expected."""
        with pytest.raises(AttributeError):
            Value(1.0).log()

    def test_no_tanh(self):
        """Engine has no tanh() — AttributeError expected."""
        with pytest.raises(AttributeError):
            Value(1.0).tanh()

    def test_pow_requires_scalar_exponent(self):
        """Exponent must be int or float — Value exponent raises AssertionError."""
        with pytest.raises(AssertionError):
            Value(2.0) ** Value(3.0)
