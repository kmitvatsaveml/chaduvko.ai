"""
nn/layers.py
────────────
Neuron, Layer, and MLP — the neural network building blocks.

Bugs fixed
──────────
BUG-A  Layer.__call__ returned `out[0]` (a scalar Value) when nout==1.
       The next layer's Neuron zips self.weights against it, but a scalar
       is not iterable in the way we need: only the very first input ever
       contributed to the pre-activation sum.  Fixed: Layer always returns
       a list; MLP unwraps the single-element list only at its own output.

BUG-B  Neuron weight initialisation used `sqrt(2/nin)` for 'relu' only,
       falling back to `sqrt(1/nin)` for every other activation including
       leaky_relu, elu, selu, gelu, swish, mish, hardswish — all of which
       need kaiming gain.  Fixed via activations.init_std().
"""

import random
from engine.value import Value
from engine.activations import ACTIVATIONS, init_std
from nn.module import Module


class Neuron(Module):
    """
    A single artificial neuron.

    forward:  out = activation( w · x + b )
    """

    def __init__(self, nin: int, activation: str = 'relu'):
        assert activation in ACTIVATIONS, \
            f"Unknown activation '{activation}'. " \
            f"Choose from: {sorted(ACTIVATIONS)}"
        # BUG-B FIX: correct gain per activation family
        std = init_std(activation, nin)
        self.weights    = [Value(random.gauss(0.0, std)) for _ in range(nin)]
        self.bias       = Value(0.0)
        self.activation = activation

    def __call__(self, x: list) -> Value:
        # sum(generator, start=bias) keeps bias in the graph from step 0
        pre = sum((wi * xi for wi, xi in zip(self.weights, x)), self.bias)
        return ACTIVATIONS[self.activation](pre)

    def parameters(self) -> list:
        return self.weights + [self.bias]

    def __repr__(self):
        return f"Neuron(nin={len(self.weights)}, act={self.activation!r})"


class Layer(Module):
    """
    A fully-connected layer of neurons, all sharing the same activation.
    """

    def __init__(self, nin: int, nout: int, activation: str = 'relu'):
        self.neurons    = [Neuron(nin, activation=activation) for _ in range(nout)]
        self.activation = activation

    def __call__(self, x: list) -> list:
        """
        BUG-A FIX: always returns a list, never a bare scalar.
        MLP is responsible for unwrapping single-element lists at the output.
        """
        return [n(x) for n in self.neurons]

    def parameters(self) -> list:
        return [p for n in self.neurons for p in n.parameters()]

    def __repr__(self):
        neurons_str = ', '.join(str(n) for n in self.neurons)
        return f"Layer([{neurons_str}])"


class MLP(Module):
    """
    Multi-Layer Perceptron.

    Parameters
    ----------
    nin          : int  — number of input features
    layer_sizes  : list[int]  — neurons per layer
    activations  : list[str] | str | None
        • list[str] — one activation per layer (length must match layer_sizes)
        • str       — applied to all hidden layers; output layer gets 'linear'
        • None      — defaults to relu hidden + linear output

    Example
    -------
    >>> model = MLP(2, [8, 8, 1], activations=['tanh', 'tanh', 'linear'])
    >>> out = model([Value(0.5), Value(-0.3)])   # returns a single Value
    """

    def __init__(self, nin: int, layer_sizes: list, activations=None):
        n = len(layer_sizes)

        if activations is None:
            activations = ['relu'] * (n - 1) + ['linear']
        elif isinstance(activations, str):
            activations = [activations] * (n - 1) + ['linear']

        if len(activations) != n:
            raise ValueError(
                f"len(activations)={len(activations)} must equal "
                f"len(layer_sizes)={n}"
            )

        sizes       = [nin] + layer_sizes
        self.layers = [
            Layer(sizes[i], sizes[i + 1], activation=activations[i])
            for i in range(n)
        ]

    def __call__(self, x):
        """
        Forward pass.  Input `x` can be a list of Value or list of float.
        Returns a single Value when the output layer has 1 neuron,
        otherwise a list of Value.
        """
        # accept raw floats as inputs
        x = [v if isinstance(v, Value) else Value(v) for v in x]
        for layer in self.layers:
            x = layer(x)
        return x[0] if len(x) == 1 else x

    def parameters(self) -> list:
        return [p for layer in self.layers for p in layer.parameters()]

    def __repr__(self):
        return f"MLP([{', '.join(str(l) for l in self.layers)}])"