"""
nn/module.py
────────────
Abstract base class for all neural network components.
Mirrors torch.nn.Module's minimal interface: parameters() and zero_grad().
"""

from engine.value import Value


class Module:
    """Base class for all trainable components."""

    def parameters(self) -> list:
        """Return a flat list of all learnable Value parameters."""
        return []

    def zero_grad(self) -> None:
        """Set .grad = 0 on every parameter."""
        for p in self.parameters():
            p.grad = 0.0