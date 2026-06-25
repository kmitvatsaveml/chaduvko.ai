"""Simple test: ensure training loss decreases.

Run directly:
    python micrograd/tests/test_training.py

Or with pytest from repo root:
    pytest -q
"""
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from nn.layers import MLP
from nn.losses import mse_loss
from optim.sgd import SGD


def make_data(n=50):
    xs = [i / n * 2 - 1 for i in range(n)]
    ys = [2.0 * x + 3.0 for x in xs]
    return xs, ys


def run_short_train(epochs=30):
    xs, ys = make_data(100)
    model = MLP(1, [8, 1], activations='relu')
    opt = SGD(model.parameters(), lr=0.01)

    losses = []
    for epoch in range(epochs):
        total = 0.0
        for x, y in zip(xs, ys):
            pred = model([x])
            loss = mse_loss([pred], [y])
            model.zero_grad()
            loss.backward()
            opt.step()
            total += loss.val
        losses.append(total / len(xs))
    return losses


def test_loss_decreases():
    losses = run_short_train(epochs=30)
    assert losses[-1] < losses[0], f"loss did not decrease: {losses[0]} -> {losses[-1]}"


if __name__ == '__main__':
    ls = run_short_train(epochs=30)
    print(f"Start loss: {ls[0]:.6f}, End loss: {ls[-1]:.6f}")
    assert ls[-1] < ls[0]
    print('Test passed')
