import math
import random
import numpy as np


# ============================================================
# SECTION 1: VECTOR / MATRIX UTILITIES (from scratch)
# ============================================================

def dot_product(vector_a, vector_b):
    result = 0.0
    for a_i, b_i in zip(vector_a, vector_b):
        result += a_i * b_i
    return result


def vector_add(vector_a, vector_b):
    return [a_i + b_i for a_i, b_i in zip(vector_a, vector_b)]


def vector_subtract(vector_a, vector_b):
    return [a_i - b_i for a_i, b_i in zip(vector_a, vector_b)]


def scalar_multiply(scalar, vector):
    return [scalar * v_i for v_i in vector]


def vector_norm(vector):
    squared_sum = sum(v_i ** 2 for v_i in vector)
    return math.sqrt(squared_sum)


# ============================================================
# SECTION 2: ACTIVATION FUNCTIONS (for backprop)
# ============================================================

def sigmoid(z):
    z = max(-500, min(500, z))
    return 1.0 / (1.0 + math.exp(-z))


def sigmoid_derivative(output):
    return output * (1.0 - output)


def relu(z):
    return max(0.0, z)


def relu_derivative(z):
    return 1.0 if z > 0 else 0.0


# ============================================================
# SECTION 3: LOSS FUNCTIONS (from scratch)
# ============================================================

def mean_squared_error(true_values, predicted_values):
    n_samples = len(true_values)
    total_error = 0.0
    for true_val, pred_val in zip(true_values, predicted_values):
        total_error += (true_val - pred_val) ** 2
    return total_error / n_samples


def mse_derivative(true_val, pred_val):
    return -2.0 * (true_val - pred_val)


# ============================================================
# SECTION 4: REGULARIZATION (L1 and L2 from scratch)
# ============================================================

def l1_penalty(all_weights, lambda_l1):
    penalty = 0.0
    for layer_weights in all_weights:
        for row in layer_weights:
            for weight in row:
                penalty += abs(weight)
    return lambda_l1 * penalty


def l1_gradient(weight, lambda_l1):
    if weight > 0:
        return lambda_l1
    elif weight < 0:
        return -lambda_l1
    else:
        return 0.0


def l2_penalty(all_weights, lambda_l2):
    penalty = 0.0
    for layer_weights in all_weights:
        for row in layer_weights:
            for weight in row:
                penalty += weight ** 2
    return lambda_l2 * penalty


def l2_gradient(weight, lambda_l2):
    return 2.0 * lambda_l2 * weight


# ============================================================
# SECTION 5: LINEAR REGRESSION + GRADIENT DESCENT (from scratch)
# ============================================================

def predict_linear(weights, input_vector):
    return dot_product(weights, input_vector)


def compute_mse_gradient(weights, all_inputs, all_true_outputs):
    n_samples = len(all_inputs)
    n_weights = len(weights)
    gradient = [0.0] * n_weights

    for input_vector, true_output in zip(all_inputs, all_true_outputs):
        predicted_output = predict_linear(weights, input_vector)
        error = predicted_output - true_output

        for weight_index in range(n_weights):
            gradient[weight_index] += (2.0 / n_samples) * error * input_vector[weight_index]

    return gradient


def gradient_descent(all_inputs, all_true_outputs,
                     learning_rate=0.01,
                     max_iterations=1000,
                     tolerance=1e-6,
                     lambda_l1=0.0,
                     lambda_l2=0.0):

    n_features = len(all_inputs[0])
    weights = [random.uniform(-0.5, 0.5) for _ in range(n_features)]
    loss_history = []

    print("=" * 60)
    print("GRADIENT DESCENT (Linear Regression)")
    print(f"  learning_rate = {learning_rate}")
    print(f"  L1 lambda     = {lambda_l1}")
    print(f"  L2 lambda     = {lambda_l2}")
    print("=" * 60)

    for iteration in range(max_iterations):

        predictions = [predict_linear(weights, x) for x in all_inputs]
        current_loss = mean_squared_error(all_true_outputs, predictions)

        if lambda_l1 > 0:
            current_loss += lambda_l1 * sum(abs(w) for w in weights)
        if lambda_l2 > 0:
            current_loss += lambda_l2 * sum(w ** 2 for w in weights)

        loss_history.append(current_loss)

        mse_grad = compute_mse_gradient(weights, all_inputs, all_true_outputs)

        for weight_index in range(n_features):
            if lambda_l1 > 0:
                mse_grad[weight_index] += l1_gradient(weights[weight_index], lambda_l1)
            if lambda_l2 > 0:
                mse_grad[weight_index] += l2_gradient(weights[weight_index], lambda_l2)

        grad_magnitude = vector_norm(mse_grad)
        if grad_magnitude < tolerance:
            print(f"  Converged at iteration {iteration}")
            break

        gradient_step = scalar_multiply(learning_rate, mse_grad)
        weights = vector_subtract(weights, gradient_step)

        if iteration % 200 == 0 or iteration < 5:
            print(f"  Iter {iteration:4d} | Loss: {current_loss:.6f} | Grad: {grad_magnitude:.6f}")

    print(f"  Final loss   : {loss_history[-1]:.8f}")
    print(f"  Final weights: {[round(w, 6) for w in weights]}")
    print("=" * 60)

    return weights, loss_history


# ============================================================
# SECTION 6: NEURAL NETWORK + BACKPROPAGATION (from scratch)
# ============================================================

def create_network(layer_sizes):
    network_weights = []
    network_biases = []

    for layer_index in range(len(layer_sizes) - 1):
        n_inputs_to_layer = layer_sizes[layer_index]
        n_neurons_in_layer = layer_sizes[layer_index + 1]

        weight_matrix = []
        for neuron in range(n_neurons_in_layer):
            neuron_weights = [random.gauss(0, 0.5) for _ in range(n_inputs_to_layer)]
            weight_matrix.append(neuron_weights)

        bias_vector = [0.0] * n_neurons_in_layer

        network_weights.append(weight_matrix)
        network_biases.append(bias_vector)

    return network_weights, network_biases


def forward_pass(network_weights, network_biases, input_vector, activation="sigmoid"):
    layer_outputs = [list(input_vector)]
    layer_raw_inputs = []

    current_input = list(input_vector)

    for layer_index in range(len(network_weights)):
        weight_matrix = network_weights[layer_index]
        bias_vector = network_biases[layer_index]
        n_neurons = len(weight_matrix)
        is_output_layer = (layer_index == len(network_weights) - 1)

        raw_values = []
        activated = []

        for neuron_index in range(n_neurons):
            z = dot_product(weight_matrix[neuron_index], current_input) + bias_vector[neuron_index]
            raw_values.append(z)

            if is_output_layer:
                activated.append(z)
            elif activation == "sigmoid":
                activated.append(sigmoid(z))
            elif activation == "relu":
                activated.append(relu(z))

        layer_raw_inputs.append(raw_values)
        layer_outputs.append(activated)
        current_input = activated

    return layer_outputs, layer_raw_inputs


def backpropagation(network_weights, network_biases,
                    input_vector, true_output,
                    activation="sigmoid",
                    lambda_l1=0.0, lambda_l2=0.0):

    n_layers = len(network_weights)

    layer_outputs, layer_raw_inputs = forward_pass(
        network_weights, network_biases, input_vector, activation
    )

    predicted_output = layer_outputs[-1][0]

    weight_gradients = []
    bias_gradients = []

    for layer_index in range(n_layers):
        n_neurons = len(network_weights[layer_index])
        n_inputs = len(network_weights[layer_index][0])
        weight_gradients.append([[0.0] * n_inputs for _ in range(n_neurons)])
        bias_gradients.append([0.0] * n_neurons)

    output_error = mse_derivative(true_output, predicted_output)

    deltas = [None] * n_layers
    deltas[-1] = [output_error]

    for layer_index in range(n_layers - 2, -1, -1):
        n_neurons = len(network_weights[layer_index])
        next_layer_weights = network_weights[layer_index + 1]
        next_deltas = deltas[layer_index + 1]

        current_deltas = []
        for neuron_index in range(n_neurons):
            error_from_next = 0.0
            for next_neuron in range(len(next_deltas)):
                error_from_next += next_deltas[next_neuron] * next_layer_weights[next_neuron][neuron_index]

            z = layer_raw_inputs[layer_index][neuron_index]
            if activation == "sigmoid":
                a = layer_outputs[layer_index + 1][neuron_index]
                deriv = sigmoid_derivative(a)
            elif activation == "relu":
                deriv = relu_derivative(z)

            current_deltas.append(error_from_next * deriv)

        deltas[layer_index] = current_deltas

    for layer_index in range(n_layers):
        prev_output = layer_outputs[layer_index]
        for neuron_index in range(len(deltas[layer_index])):
            delta = deltas[layer_index][neuron_index]
            bias_gradients[layer_index][neuron_index] = delta

            for weight_index in range(len(prev_output)):
                grad = delta * prev_output[weight_index]

                w = network_weights[layer_index][neuron_index][weight_index]
                if lambda_l1 > 0:
                    grad += l1_gradient(w, lambda_l1)
                if lambda_l2 > 0:
                    grad += l2_gradient(w, lambda_l2)

                weight_gradients[layer_index][neuron_index][weight_index] = grad

    return weight_gradients, bias_gradients, predicted_output


def train_network(network_weights, network_biases,
                  all_inputs, all_true_outputs,
                  learning_rate=0.01,
                  max_epochs=500,
                  lambda_l1=0.0,
                  lambda_l2=0.0,
                  activation="sigmoid"):

    print("\n" + "=" * 60)
    print("NEURAL NETWORK TRAINING (Backpropagation)")
    print(f"  learning_rate = {learning_rate}")
    print(f"  activation    = {activation}")
    print(f"  L1 lambda     = {lambda_l1}")
    print(f"  L2 lambda     = {lambda_l2}")
    print("=" * 60)

    epoch_losses = []

    for epoch in range(max_epochs):
        epoch_predictions = []

        for sample_index in range(len(all_inputs)):
            input_vector = all_inputs[sample_index]
            true_output = all_true_outputs[sample_index]

            weight_grads, bias_grads, predicted = backpropagation(
                network_weights, network_biases,
                input_vector, true_output,
                activation, lambda_l1, lambda_l2
            )
            epoch_predictions.append(predicted)

            for layer_index in range(len(network_weights)):
                for neuron_index in range(len(network_weights[layer_index])):
                    network_biases[layer_index][neuron_index] -= (
                        learning_rate * bias_grads[layer_index][neuron_index]
                    )
                    for weight_index in range(len(network_weights[layer_index][neuron_index])):
                        network_weights[layer_index][neuron_index][weight_index] -= (
                            learning_rate * weight_grads[layer_index][neuron_index][weight_index]
                        )

        epoch_loss = mean_squared_error(all_true_outputs, epoch_predictions)
        if lambda_l1 > 0:
            epoch_loss += l1_penalty(network_weights, lambda_l1)
        if lambda_l2 > 0:
            epoch_loss += l2_penalty(network_weights, lambda_l2)

        epoch_losses.append(epoch_loss)

        if epoch % 100 == 0 or epoch < 5:
            print(f"  Epoch {epoch:4d} | Loss: {epoch_loss:.6f}")

    print(f"  Final loss: {epoch_losses[-1]:.8f}")
    print("=" * 60)

    return network_weights, network_biases, epoch_losses


# ============================================================
# SECTION 7: CONVEXITY CHECK (Hessian)
# ============================================================

def convexity_check(all_inputs):
    print("\n" + "=" * 50)
    print("HESSIAN-BASED CONVEXITY CHECK")
    print("=" * 50)

    n_samples = len(all_inputs)
    n_features = len(all_inputs[0])

    X = np.array(all_inputs)
    H = (2.0 / n_samples) * X.T @ X

    print(f"Hessian matrix shape: {H.shape}")
    print("Hessian matrix:")
    for i in range(n_features):
        row_str = "  ".join([f"{H[i,j]:8.4f}" for j in range(n_features)])
        print(f"  [{row_str}]")

    eigenvalues = np.linalg.eigvals(H)

    print(f"\nEigenvalues: {eigenvalues}")
    print(f"Min eigenvalue: {np.min(eigenvalues):.6f}")
    print(f"Max eigenvalue: {np.max(eigenvalues):.6f}")

    is_convex = np.all(eigenvalues >= -1e-10)

    if is_convex:
        print("Hessian is positive semi-definite")
        print("Function is CONVEX")
    else:
        print("Hessian has negative eigenvalues")
        print("Function is NOT CONVEX")

    print("=" * 50)
    return is_convex


# ============================================================
# SECTION 8: MAIN DEMO
# ============================================================

def main():
    print("=" * 60)
    print("MACHINE LEARNING FROM SCRATCH")
    print("=" * 60)

    true_weights = [3.0, 2.0, 1.0]
    random.seed(42)

    n_samples = 50
    all_inputs = []
    all_true_outputs = []

    for _ in range(n_samples):
        sample_input = [random.uniform(-5, 5) for _ in range(3)]
        sample_output = dot_product(true_weights, sample_input)
        all_inputs.append(sample_input)
        all_true_outputs.append(sample_output)

    print(f"Generated {n_samples} samples")
    print(f"True weights: {true_weights}")

    convexity_check(all_inputs)

    # PART A: linear gradient descent (no regularization)
    learned_weights, loss_history = gradient_descent(
        all_inputs, all_true_outputs,
        learning_rate=0.005,
        max_iterations=2000
    )
    print(f"True weights   : {true_weights}")
    print(f"Learned weights: {[round(w, 4) for w in learned_weights]}")

    # PART B: gradient descent with L2 regularization
    learned_weights_l2, _ = gradient_descent(
        all_inputs, all_true_outputs,
        learning_rate=0.005,
        max_iterations=2000,
        lambda_l2=0.01
    )
    print(f"L2 weights: {[round(w, 4) for w in learned_weights_l2]}")

    # PART C: gradient descent with L1 regularization
    learned_weights_l1, _ = gradient_descent(
        all_inputs, all_true_outputs,
        learning_rate=0.005,
        max_iterations=2000,
        lambda_l1=0.01
    )
    print(f"L1 weights: {[round(w, 4) for w in learned_weights_l1]}")

    # PART D: neural network with backpropagation
    print("\n" + "=" * 60)
    print("NEURAL NETWORK (3 layers: input->4->4->output)")
    print("=" * 60)

    layer_sizes = [3, 4, 4, 1]
    random.seed(42)
    net_weights, net_biases = create_network(layer_sizes)

    net_weights, net_biases, nn_losses = train_network(
        net_weights, net_biases,
        all_inputs, all_true_outputs,
        learning_rate=0.001,
        max_epochs=500,
        lambda_l2=0.001,
        activation="sigmoid"
    )

    # test prediction comparison
    test_input = [1.0, 2.0, 3.0]
    true_answer = dot_product(true_weights, test_input)

    linear_pred = dot_product(learned_weights, test_input)
    nn_outputs, _ = forward_pass(net_weights, net_biases, test_input, "sigmoid")
    nn_pred = nn_outputs[-1][0]

    print("\n" + "=" * 60)
    print("PREDICTION COMPARISON")
    print("=" * 60)
    print(f"  Test input      : {test_input}")
    print(f"  True answer     : {true_answer}")
    print(f"  Linear GD pred  : {linear_pred:.6f}")
    print(f"  Neural net pred : {nn_pred:.6f}")
    print("=" * 60)


if __name__ == "__main__":
    main()