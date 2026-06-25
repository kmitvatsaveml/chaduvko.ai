import math
import random



def loss_function(weights, inputs, true_outputs):
    if not inputs or not true_outputs:
        raise ValueError("Input cannot be empty.")

    total_error = 0.0
    n = len(inputs)

    for x_vector, y_true in zip(inputs, true_outputs):
        y_predicted = dot_product(weights, x_vector)
        error = (y_predicted - y_true) ** 2
        total_error += error

    return total_error / n


def dot_product(vector_a, vector_b):
    if len(vector_a) != len(vector_b):
        raise ValueError("Vector sizes don't match.")

    return sum(a * b for a, b in zip(vector_a, vector_b))


def vector_subtract(vector_a, vector_b):
    return [a - b for a, b in zip(vector_a, vector_b)]


def scalar_multiply(scalar, vector):
    return [scalar * v for v in vector]


def vector_norm(vector):
    return math.sqrt(sum(v ** 2 for v in vector))


def compute_gradient(weights, inputs, true_outputs):
    n = len(inputs)
    num_weights = len(weights)
    gradient = [0.0] * num_weights

    for x_vector, y_true in zip(inputs, true_outputs):
        y_predicted = dot_product(weights, x_vector)
        error = y_predicted - y_true

        for j in range(num_weights):
            gradient[j] += (2 / n) * error * x_vector[j]

    return gradient


def check_convexity_simple(loss_fn, inputs, true_outputs, weight_range=(-5, 5), steps=50):
    """
    Test convexity using line segment method
    """
    low, high = weight_range
    step_size = (high - low) / steps
    
    num_weights = len(inputs[0])
    convexity_violations = 0
    total_tests = 0
    
    print(f"Testing convexity over {steps} points in range {weight_range}")
    
    # Test multiple random pairs of points
    for test in range(20):  # 20 random tests
        # Generate two random weight vectors
        w1 = [random.uniform(low, high) for _ in range(num_weights)]
        w2 = [random.uniform(low, high) for _ in range(num_weights)]
        
        # Test convexity condition for multiple λ values
        for lambda_val in [0.25, 0.5, 0.75]:
            # Weighted combination
            w_mid = [lambda_val * w1[i] + (1 - lambda_val) * w2[i] for i in range(num_weights)]
            
            # Loss values
            loss_w1 = loss_fn(w1, inputs, true_outputs)
            loss_w2 = loss_fn(w2, inputs, true_outputs)
            loss_mid = loss_fn(w_mid, inputs, true_outputs)
            
            # Convexity condition: f(λx₁ + (1-λ)x₂) ≤ λf(x₁) + (1-λ)f(x₂)
            convex_combination = lambda_val * loss_w1 + (1 - lambda_val) * loss_w2
            
            if loss_mid > convex_combination + 1e-10:  # Small tolerance for numerical errors
                convexity_violations += 1
            
            total_tests += 1
    
    violation_rate = convexity_violations / total_tests if total_tests > 0 else 0
    
    print(f"Convexity test results:")
    print(f"  Total tests: {total_tests}")
    print(f"  Violations: {convexity_violations}")
    print(f"  Violation rate: {violation_rate:.4f}")
    
    if violation_rate < 0.05:  # Less than 5% violations
        print(" Function appears convex")
    else:
        print(" Function may not be convex")
    
    return violation_rate < 0.05


def gradient_descent(
    inputs,
    true_outputs,
    learning_rate=0.01,
    max_iterations=1000,
    tolerance=1e-6,
    initial_weights=None,
    verbose=True
):
    if not inputs or not true_outputs:
        raise ValueError("Cannot run gradient descent on empty input.")

    if len(inputs) != len(true_outputs):
        raise ValueError("Mismatch between inputs and outputs.")

    num_features = len(inputs[0])

    if initial_weights is None:
        weights = [random.uniform(-0.5, 0.5) for _ in range(num_features)]
    else:
        weights = list(initial_weights)

    loss_history = []

    if verbose:
        print("=" * 60)
        print("GRADIENT DESCENT")
        print("=" * 60)

    for iteration in range(max_iterations):

        current_loss = loss_function(weights, inputs, true_outputs)
        loss_history.append(current_loss)

        gradient = compute_gradient(weights, inputs, true_outputs)

        grad_magnitude = vector_norm(gradient)

        if grad_magnitude < tolerance:
            if verbose:
                print(f"Converged at iteration {iteration}")
            break

        gradient_step = scalar_multiply(learning_rate, gradient)

        weights = vector_subtract(weights, gradient_step)

        if verbose and (iteration % 100 == 0 or iteration < 5):
            print(
                f"Iter {iteration:4d} | "
                f"Loss: {current_loss:.6f} | "
                f"Grad norm: {grad_magnitude:.6f}"
            )

    if verbose:
        print("=" * 60)
        print(f"Final loss    : {loss_history[-1]:.8f}")
        print(f"Final weights : {[round(w, 6) for w in weights]}")
        print("=" * 60)

    return weights, loss_history


def verify_minimum(weights, inputs, true_outputs, perturbation=1e-4):

    print("\n" + "=" * 60)
    print("VERIFYING MINIMUM")
    print("=" * 60)

    base_loss = loss_function(weights, inputs, true_outputs)

    all_minimal = True

    for j in range(len(weights)):

        weights_up = list(weights)
        weights_up[j] += perturbation
        loss_up = loss_function(weights_up, inputs, true_outputs)

        weights_down = list(weights)
        weights_down[j] -= perturbation
        loss_down = loss_function(weights_down, inputs, true_outputs)

        is_local_min = (
            loss_up >= base_loss and
            loss_down >= base_loss
        )

        status = "MINIMUM" if is_local_min else "NOT MINIMUM"

        print(
            f"Weight[{j}] = {weights[j]:.6f} | "
            f"Loss(+δ)={loss_up:.8f} | "
            f"Loss(-δ)={loss_down:.8f} | "
            f"{status}"
        )

        if not is_local_min:
            all_minimal = False

    if all_minimal:
        print("Verified minimum")
    else:
        print("Not a minimum")

    print("=" * 60)

    return all_minimal


def main():

    print("\n" + "█" * 60)
    print("GRADIENT DESCENT DEMO")
    print("█" * 60 + "\n")

    TRUE_WEIGHTS = [3.0, 2.0, 1.0]

    random.seed(42)

    num_samples = 50

    inputs = []
    true_outputs = []

    for _ in range(num_samples):

        x = [random.gauss(0,1) for _ in range(3)]

        y = dot_product(TRUE_WEIGHTS, x)

        inputs.append(x)
        true_outputs.append(y)

    print(f"Generated {num_samples} samples")
    print(f"True weights: {TRUE_WEIGHTS}")

    check_convexity_simple(loss_function, inputs, true_outputs)

    learned_weights, loss_history = gradient_descent(
        inputs=inputs,
        true_outputs=true_outputs,
        learning_rate=0.005,
        max_iterations=2000,
        tolerance=1e-8,
        verbose=True
    )

    print(f"\nLoss at start : {loss_history[0]:.6f}")
    print(f"Loss at end   : {loss_history[-1]:.6f}")

    print(f"\nTrue weights   : {TRUE_WEIGHTS}")
    print(f"Learned weights: {[round(w, 4) for w in learned_weights]}")

    verify_minimum(
        learned_weights,
        inputs,
        true_outputs
    )

    print("\n" + "=" * 60)
    print("PREDICTION TEST")
    print("=" * 60)

    test_input = [1.0, 2.0, 3.0]

    true_answer = dot_product(TRUE_WEIGHTS, test_input)

    predicted = dot_product(
        learned_weights,
        test_input
    )

    print(f"Input vector : {test_input}")
    print(f"True answer  : {true_answer}")
    print(f"Predicted    : {predicted:.6f}")
    print(f"Error        : {abs(true_answer - predicted):.8f}")

    print("=" * 60)


if __name__ == "__main__":
    main()