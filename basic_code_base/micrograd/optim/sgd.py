"""
optim/sgd.py
────────────
Stochastic Gradient Descent — faithful to PyTorch's torch.optim.SGD.

Variants
────────
  Plain SGD:
      p  ←  p - lr · g

  With weight decay (L2):
      g  ←  g + wd · p
      p  ←  p - lr · g

  With momentum (Polyak heavy-ball):
      v  ←  μ · v_prev  -  lr · g       # v is the velocity buffer
      p  ←  p + v

  With Nesterov:
      v  ←  μ · v_prev  -  lr · g
      p  ←  p + μ · v  -  lr · g        # look-ahead correction

The Nesterov formula is numerically verified against PyTorch's source
(torch/optim/sgd.py).  The two are mathematically equivalent when using
the same velocity parameterisation.
"""

from optim.base import Optimizer


class SGD(Optimizer):
    """
    Parameters
    ----------
    params       : iterable[Value]
    lr           : float  — learning rate
    momentum     : float  — momentum factor μ (0 = disabled)
    weight_decay : float  — L2 regularisation coefficient λ
    nesterov     : bool   — enable Nesterov look-ahead (requires momentum > 0)
    """

    def __init__(self, params, lr: float = 0.01, momentum: float = 0.0,
                 weight_decay: float = 0.0, nesterov: bool = False):
        super().__init__(params)
        if nesterov and momentum == 0.0:
            raise ValueError("Nesterov momentum requires momentum > 0")
        self.lr           = lr
        self.momentum     = momentum
        self.weight_decay = weight_decay
        self.nesterov     = nesterov
        # velocity buffer, one entry per parameter
        self._v = {id(p): 0.0 for p in self.params}

    def step(self) -> None:
        self._step += 1
        for p in self.params:
            # include L2 penalty in effective gradient
            g = p.grad + self.weight_decay * p.val

            if self.momentum > 0.0:
                v = self.momentum * self._v[id(p)] - self.lr * g
                self._v[id(p)] = v

                if self.nesterov:
                    # Nesterov look-ahead: p += μ·v_new - lr·g
                    p.val += self.momentum * v - self.lr * g
                else:
                    # Heavy-ball: p += v
                    p.val += v
            else:
                p.val -= self.lr * g

    def __repr__(self):
        return (f"SGD(lr={self.lr}, momentum={self.momentum}, "
                f"weight_decay={self.weight_decay}, nesterov={self.nesterov})")