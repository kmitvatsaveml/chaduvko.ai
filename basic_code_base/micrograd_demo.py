"""micrograd_demo.py
Simple runnable demo for the provided `micrograd` package.

Usage:
    python micrograd_demo.py

This trains a tiny MLP to fit y = 2*x + 3 (regression) on synthetic data.
"""

import os
import sys
# Ensure `micrograd/` is on sys.path so files using absolute imports like
# `from engine.value import Value` resolve correctly when running this demo
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'micrograd'))

# Some modules inside this micrograd copy use absolute imports like
# `from engine.value import Value` and expect `Value` instances to be
# hashable (they are placed into `set(prev)`). The distributed Value
# class defines `__eq__` but no `__hash__`, making instances unhashable
# and raising `TypeError: unhashable type: 'Value'`.
#
# Monkey-patch Value.__hash__ to use the object's id so it can be used
# in sets. This is safe for this small demo environment.
import importlib
try:
    valmod = importlib.import_module('engine.value')
    # Force-assign __hash__ so instances can be inserted into sets.
    valmod.Value.__hash__ = lambda self: id(self)
except Exception:
    # If import fails here, later imports will raise; keep going so that
    # the real import error surfaces when attempting to use the package.
    pass

from nn.layers import MLP
from nn.losses import mse_loss
from optim.sgd import SGD


def make_data(n=100):
    xs = [i / n * 2 - 1 for i in range(n)]  # in [-1, 1]
    ys = [2.0 * x + 3.0 for x in xs]
    return xs, ys


def train():
    xs, ys = make_data(200)

    model = MLP(1, [16, 1], activations='relu')
    opt = SGD(model.parameters(), lr=0.01)

    for epoch in range(200):
        total_loss = 0.0
        for x, y in zip(xs, ys):
            pred = model([x])           # returns a single Value for 1-output net
            loss = mse_loss([pred], [y])

            model.zero_grad()
            loss.backward()
            opt.step()

            total_loss += loss.val

        if epoch % 20 == 0:
            print(f"Epoch {epoch:3d}: loss={total_loss/len(xs):.6f}")

    # quick check
    test_x = 0.5
    pred = model([test_x])
    print(f"Prediction for x={test_x}: {pred.val:.4f} (target {2*test_x+3:.4f})")


if __name__ == '__main__':
    train()
