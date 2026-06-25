import math
import random


def dotprod(a, b):
    result = 0.0
    for ai, bi in zip(a, b):
        result += ai * bi
    return result


def sigmoid(z):
    if z < -500:
        z = -500
    if z > 500:
        z = 500
    return 1.0 / (1.0 + math.exp(-z))


def sigmoidgrad(output):
    """
    derivative of sigmoid using output value
    """
    return output * (1.0 - output)


def mse(predictions, true_outputs):
    """
    mse for n samples
    """
    n_samples = len(true_outputs)
    error = 0.0
    for pred, true in zip(predictions, true_outputs):
        error += (pred - true) ** 2
    return error / n_samples



def createnn(layer_sizes):
    """
    creates neural network weights and biases
    layer_sizes example: [2, 3, 1]
    """
    weights = []
    biases = []

    for li in range(len(layer_sizes) - 1):
        prev_layer = layer_sizes[li]
        next_layer = layer_sizes[li + 1]

        layer_weights = []
        for neuron in range(next_layer):
            neuron_weights = [random.uniform(-1, 1) for _ in range(prev_layer)]
            layer_weights.append(neuron_weights)

        layer_biases = [0.0 for _ in range(next_layer)]

        weights.append(layer_weights)
        biases.append(layer_biases)

    return weights, biases


def forwardpass(weights, biases, input_vector):
    """
    returns activations and z values
    activations[0] is input
    """
    activations = [input_vector]
    zs = []

    current_input = input_vector

    for li in range(len(weights)):
        layer_z = []
        layer_output = []

        for neuron in range(len(weights[li])):
            z = dotprod(weights[li][neuron], current_input) + biases[li][neuron]
            out = sigmoid(z)
            layer_z.append(z)
            layer_output.append(out)

        zs.append(layer_z)
        activations.append(layer_output)
        current_input = layer_output

    return activations, zs


def predict(weights, biases, input_vector):
    activations, zs = forwardpass(weights, biases, input_vector)
    return activations[-1][0]


def backprop(weights, biases, input_vector, true_output):
    """
    main backpropagation
    calculates dloss/dw and dloss/db
    """
    activations, zs = forwardpass(weights, biases, input_vector)
    predicted = activations[-1][0]

    weight_grads = []
    bias_grads = []

    for li in range(len(weights)):
        layer_weight_grads = []
        for neuron in range(len(weights[li])):
            layer_weight_grads.append([0.0 for _ in range(len(weights[li][neuron]))])
        weight_grads.append(layer_weight_grads)
        bias_grads.append([0.0 for _ in range(len(biases[li]))])

    deltas = [None for _ in range(len(weights))]

    # output layer delta
    # loss = (predicted - true)^2
    # dloss/dpred = 2(predicted - true)
    dloss_dpred = 2.0 * (predicted - true_output)
    deltas[-1] = [dloss_dpred * sigmoidgrad(predicted)]

    # hidden layers delta
    for li in range(len(weights) - 2, -1, -1):
        layer_delta = []

        for neuron in range(len(weights[li])):
            error_from_next_layer = 0.0

            for next_neuron in range(len(weights[li + 1])):
                error_from_next_layer += (
                    deltas[li + 1][next_neuron] *
                    weights[li + 1][next_neuron][neuron]
                )

            neuron_output = activations[li + 1][neuron]
            layer_delta.append(error_from_next_layer * sigmoidgrad(neuron_output))

        deltas[li] = layer_delta

    # gradients from deltas
    for li in range(len(weights)):
        prev_outputs = activations[li]

        for neuron in range(len(weights[li])):
            bias_grads[li][neuron] = deltas[li][neuron]

            for wi in range(len(weights[li][neuron])):
                weight_grads[li][neuron][wi] = deltas[li][neuron] * prev_outputs[wi]

    return weight_grads, bias_grads, predicted


def updatenn(weights, biases, weight_grads, bias_grads, lr):
    """
    w = w - lr * dloss/dw
    b = b - lr * dloss/db
    """
    for li in range(len(weights)):
        for neuron in range(len(weights[li])):
            biases[li][neuron] -= lr * bias_grads[li][neuron]

            for wi in range(len(weights[li][neuron])):
                weights[li][neuron][wi] -= lr * weight_grads[li][neuron][wi]


def trainnn(inputs, true_outputs, layer_sizes, lr=0.5, epochs=5000):
    """
    training neural network using stochastic gradient descent + backprop
    """
    weights, biases = createnn(layer_sizes)
    losshis = []

    print("neural network backprop:")
    print("layers:", layer_sizes)
    print("lr:", lr)
    print("epochs:", epochs)
    print("initial prediction:")
    for x, y in zip(inputs, true_outputs):
        print(x, "true:", y, "pred:", predict(weights, biases, x))

    for epoch in range(epochs):
        predictions = []

        for input_vector, true_output in zip(inputs, true_outputs):
            weight_grads, bias_grads, predicted = backprop(
                weights,
                biases,
                input_vector,
                true_output
            )
            updatenn(weights, biases, weight_grads, bias_grads, lr)
            predictions.append(predicted)

        loss = mse(predictions, true_outputs)
        losshis.append(loss)

        if epoch % 500 == 0 or epoch < 5:
            print(f"Epoch {epoch} | Loss: {loss}")

    print("final loss:", losshis[-1])
    print("final prediction:")
    for x, y in zip(inputs, true_outputs):
        print(x, "true:", y, "pred:", predict(weights, biases, x))

    return weights, biases, losshis


def main():
    print("hello backprop!!")
    random.seed(42)

    # xor data: linear model cannot solve this, neural network can learn it
    inputs = [
        [0.0, 0.0],
        [0.0, 1.0],
        [1.0, 0.0],
        [1.0, 1.0],
    ]
    true_outputs = [0.0, 1.0, 1.0, 0.0]

    layer_sizes = [2, 3, 1]

    weights, biases, losshis = trainnn(
        inputs,
        true_outputs,
        layer_sizes,
        lr=0.5,
        epochs=5000
    )

    print("learned weights:")
    print(weights)
    print("learned biases:")
    print(biases)


if __name__ == "__main__":
    main()
