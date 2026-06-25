"""demo.py
Runnable demo placed inside the `micrograd/` folder.

Run from the repository root like:
    python micrograd/demo.py

This script trains a tiny MLP on y = 2*x + 3 and prints loss progress.
"""

import os
import sys

# Ensure the local package directory (this file's folder) is on sys.path so
# the sibling packages `engine`, `nn`, and `optim` can be imported as top-
# level modules (this mirrors how the codebase uses absolute imports).
sys.path.insert(0, os.path.dirname(__file__))

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
            pred = model([x])
            loss = mse_loss([pred], [y])

            model.zero_grad()
            loss.backward()
            opt.step()

            total_loss += loss.val

        if epoch % 20 == 0:
            print(f"Epoch {epoch:3d}: loss={total_loss/len(xs):.6f}")

    test_x = 0.5
    pred = model([test_x])
    print(f"Prediction for x={test_x}: {pred.val:.4f} (target {2*test_x+3:.4f})")


if __name__ == '__main__':
    train()
