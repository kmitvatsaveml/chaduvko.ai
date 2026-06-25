"""
optim/base.py
─────────────
Abstract base class for all optimizers.
Mirrors torch.optim.Optimizer's interface.
"""

from engine.value import Value


class Optimizer:
    """
    Base optimizer.  Subclasses implement step().

    Parameters
    ----------
    params : iterable of Value
        The model's learnable parameters, typically from model.parameters().
    """

    def __init__(self, params):
        self.params = list(params)
        self._step  = 0           # incremented at the start of each .step()

    def zero_grad(self) -> None:
        """Set .grad = 0.0 on every managed parameter."""
        for p in self.params:
            p.grad = 0.0

    def step(self) -> None:
        raise NotImplementedError(
            f"{type(self).__name__} must implement step()"
        )

    def __repr__(self):
        return (f"{type(self).__name__}("
                f"lr={getattr(self,'lr','?')}, "
                f"params={len(self.params)})")