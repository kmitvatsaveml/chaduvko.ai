"""visualize.py
Train the same tiny model and produce a loss-vs-epoch plot (if matplotlib
is installed). Saves `loss_plot.png` to the current working directory.

Run from repo root:
    python micrograd/visualize.py
"""

import os
import sys
sys.path.insert(0, os.path.dirname(__file__))

from nn.layers import MLP
from nn.losses import mse_loss
from optim.sgd import SGD


def make_data(n=100):
    xs = [i / n * 2 - 1 for i in range(n)]
    ys = [2.0 * x + 3.0 for x in xs]
    return xs, ys


def train_collect(epochs=200):
    xs, ys = make_data(200)
    model = MLP(1, [16, 1], activations='relu')
    opt = SGD(model.parameters(), lr=0.01)

    losses = []
    for epoch in range(epochs):
        total_loss = 0.0
        for x, y in zip(xs, ys):
            pred = model([x])
            loss = mse_loss([pred], [y])
            model.zero_grad()
            loss.backward()
            opt.step()
            total_loss += loss.val
        losses.append(total_loss / len(xs))
    return losses


def plot_losses(losses, out='loss_plot.png'):
    try:
        import matplotlib.pyplot as plt
    except Exception:
        print('matplotlib not installed. To enable plotting run: pip install matplotlib')
        return
    plt.figure(figsize=(6, 4))
    plt.plot(losses, label='train loss')
    plt.yscale('log')
    plt.xlabel('Epoch')
    plt.ylabel('Loss (log scale)')
    plt.title('Training loss')
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.savefig(out)
    print(f'Saved loss plot to {out}')


if __name__ == '__main__':
    losses = train_collect(200)
    plot_losses(losses)
