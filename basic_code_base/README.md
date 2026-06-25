# PCA From Scratch: Eigenfaces Notebook Guide

This README explains what `pca_eigenfaces_from_scratch_kaggle.ipynb` is doing conceptually and how the code implements PCA step by step.

The notebook is made for learning PCA like a linear algebra lecture:

1. Start with face images.
2. Convert each image into a vector.
3. Build a data matrix.
4. Center the data.
5. Find eigenvectors of the covariance matrix.
6. Treat those eigenvectors as a new basis.
7. Keep only top eigenvectors.
8. Reconstruct faces using fewer dimensions.

Those top eigenvectors, when reshaped as images, are called **eigenfaces**.

---

## 1. What Problem PCA Solves

Each face image has many pixels.

Example:

```text
64 x 64 image = 4096 pixel values
```

So one face is not just an image. Mathematically, it is a vector:

```text
one face = one point in R^4096
```

If we have `m` face images, the dataset becomes:

```text
X shape = (m, n)
```

where:

```text
m = number of images
n = number of pixels per image
```

For `64 x 64` images:

```text
n = 4096
```

PCA asks:

```text
Can we represent each face using only k numbers instead of 4096 numbers?
```

where:

```text
k << n
```

For example:

```text
Original face: 4096 pixel values
PCA face: only 50 or 100 coefficients
```

That is compression.

---

## 2. PCA Main Idea

Normal image pixels are not a very smart basis.

Pixel basis means:

```text
feature 1 = top-left pixel
feature 2 = next pixel
feature 3 = next pixel
...
```

But faces have structure:

- eyes vary together
- lighting changes many pixels together
- mouth shape affects a region
- pose affects many pixels together

PCA finds a better basis for faces.

Instead of using raw pixel directions, PCA finds special directions where the dataset changes the most.

These special directions are:

```text
eigenvectors of the covariance matrix
```

For face images, these eigenvectors are called:

```text
eigenfaces
```

---

## 3. Three Interpretations of PCA

PCA has three equivalent meanings.

### Interpretation 1: Decorrelation

PCA transforms data into a new basis where the new features are uncorrelated.

Before PCA:

```text
pixel features can be correlated
```

After PCA:

```text
principal components have almost zero covariance with each other
```

Mathematically:

```text
covariance in PCA space is diagonal
```

The notebook checks this using:

```python
cov_z = (Z_check.T @ Z_check) / len(Z_check)
```

If PCA worked, off-diagonal values should be close to zero.

---

### Interpretation 2: Maximum Variance

PCA chooses directions where data varies the most.

The first principal component captures maximum variance.

The second principal component captures maximum remaining variance, while being orthogonal to the first.

And so on.

The amount of variance captured by each component is given by its eigenvalue.

In code:

```python
eigenvalues
explained_variance_ratio
```

Large eigenvalue means:

```text
important direction
```

Small eigenvalue means:

```text
low-variance direction, often noise or less useful detail
```

---

### Interpretation 3: Minimum Reconstruction Error

If we keep only top `k` principal components, we lose some information.

PCA chooses the best `k` directions so that reconstruction error is as small as possible.

Projection:

```text
Z = X_centered @ Pk
```

Reconstruction:

```text
X_reconstructed = Z @ Pk.T + mean_face
```

In code:

```python
Z = transform_pca(X, pca, k)
X_reconstructed = reconstruct_pca(Z, pca, k)
```

As `k` increases:

```text
reconstruction quality improves
MSE decreases
```

The notebook plots this.

---

## 4. Code Flow of the Notebook

This section maps the notebook code to the PCA concept.

---

## Step 1: Import Libraries

Notebook code:

```python
import os
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
```

Purpose:

- `numpy` handles vectors, matrices, eigenvalues, and eigenvectors.
- `matplotlib` displays faces and plots.
- `PIL.Image` loads face images from Kaggle folders.
- `Path` searches files inside `/kaggle/input`.

Important point:

```text
PCA itself is implemented using NumPy, not sklearn.PCA.
```

---

## Step 2: Load Face Dataset

Main loader:

```python
images, labels, source = load_face_dataset()
```

The loader tries three things:

1. Search image files inside `/kaggle/input`.
2. Search `.npy` or `.npz` face arrays.
3. Use `sklearn.fetch_olivetti_faces` as fallback.

Conceptually:

```text
We need many face images before PCA can learn common face directions.
```

Each loaded image is converted to grayscale:

```python
image = Image.open(path).convert("L").resize(image_size)
```

Why grayscale?

```text
PCA becomes easier because one pixel = one number.
```

If image is RGB:

```text
one pixel has 3 values
```

If image is grayscale:

```text
one pixel has 1 value
```

The notebook resizes images so all faces have same shape.

---

## Step 3: Normalize Images

Code:

```python
images = normalize_images(np.stack(images))
```

Inside:

```python
if images.max() > 1.0:
    images = images / 255.0
```

Purpose:

```text
convert pixel values from 0-255 range to 0-1 range
```

This makes numerical computation cleaner.

---

## Step 4: Display Sample Faces

Code:

```python
plot_image_grid(images[sample_indices], labels[sample_indices])
```

Purpose:

```text
Before applying PCA, check what data looks like.
```

This is important because PCA will learn variation from whatever images are loaded.

If images are not proper faces, eigenfaces will not make sense.

---

## Step 5: Convert Images to Data Matrix

Code:

```python
X = images.reshape(num_images, -1)
```

Suppose:

```text
images shape = (400, 64, 64)
```

After reshape:

```text
X shape = (400, 4096)
```

Meaning:

```text
400 rows = 400 face images
4096 columns = 4096 pixel features
```

This is the main data matrix:

```text
X in R^(m x n)
```

---

## Step 6: Compute the Mean Face

Code:

```python
mean_face = X.mean(axis=0)
X_centered = X - mean_face
```

Concept:

PCA should study variation around the average face.

The mean face is:

```text
average of all faces pixel by pixel
```

If one pixel is usually bright across all faces, that belongs to the mean.

PCA focuses on:

```text
how each face differs from the mean face
```

So we center:

```text
X_centered = X - mean_face
```

This makes each feature have mean approximately zero.

---

## Step 7: Fit PCA From Scratch

Main code:

```python
pca = fit_pca_from_scratch(X, max_components=max_components)
```

This function does the real PCA work.

It returns:

```python
{
    "mean": mean,
    "components": components,
    "eigenvalues": eigenvalues,
    "explained_variance_ratio": explained_variance_ratio,
}
```

Meaning:

- `mean`: mean face vector
- `components`: principal components / eigenfaces
- `eigenvalues`: variance captured by each component
- `explained_variance_ratio`: fraction of total variance captured

---

## Step 8: Center Data Inside PCA Function

Code:

```python
mean = X.mean(axis=0)
Xc = X - mean
```

Even though we centered earlier for explanation, the PCA function does it again internally.

This is good because:

```text
fit_pca_from_scratch can work independently on any X.
```

---

## Step 9: Covariance Matrix Idea

Theory:

```text
Sigma = (Xc.T @ Xc) / m
```

Shape:

```text
Xc shape       = (m, n)
Xc.T shape     = (n, m)
Sigma shape    = (n, n)
```

For `64 x 64` faces:

```text
Sigma shape = (4096, 4096)
```

This covariance matrix tells:

```text
how pixel features vary together
```

PCA needs eigenvectors of this covariance matrix.

---

## Step 10: Why the Notebook Uses a Smaller Matrix

Direct covariance can be huge.

Example:

```text
4096 x 4096 covariance matrix
```

For larger images:

```text
100 x 100 image = 10000 pixels
covariance = 10000 x 10000
```

That is expensive.

So the notebook uses a standard eigenfaces trick.

Instead of diagonalizing:

```text
Xc.T @ Xc
```

it diagonalizes:

```text
Xc @ Xc.T
```

Code:

```python
gram = (Xc @ Xc.T) / num_samples
small_eigenvalues, small_eigenvectors = np.linalg.eigh(gram)
```

Shape:

```text
gram shape = (m, m)
```

If:

```text
m = 400 images
n = 4096 pixels
```

then:

```text
gram = 400 x 400
covariance = 4096 x 4096
```

Much easier.

---

## Step 11: Convert Small Eigenvectors to Real Eigenfaces

Small eigenvectors live in image-sample space.

But eigenfaces must live in pixel space.

Code:

```python
pixel_eigenvectors = Xc.T @ small_eigenvectors
pixel_eigenvectors = pixel_eigenvectors / np.sqrt(num_samples * eigenvalues)
```

Conceptually:

```text
small eigenvector tells how to combine training images
Xc.T maps that combination back into pixel space
```

After this:

```text
pixel_eigenvectors shape = (n_pixels, components)
```

Then:

```python
components = pixel_eigenvectors.T
```

So:

```text
components shape = (components, n_pixels)
```

Each row is one eigenface.

---

## Step 12: Sort Eigenvalues and Eigenvectors

Code:

```python
order = np.argsort(eigenvalues)[::-1]
eigenvalues = eigenvalues[order]
small_eigenvectors = small_eigenvectors[:, order]
```

Purpose:

```text
largest eigenvalue first
```

Why?

Because largest eigenvalue means:

```text
largest variance captured
```

So the first component is most important.

---

## Step 13: Keep Top Components

Code:

```python
components = components[:max_components]
eigenvalues = eigenvalues[:max_components]
```

Purpose:

```text
We do not need all components.
```

PCA compression happens because we keep only top `k`.

---

## Step 14: Explained Variance Ratio

Code:

```python
explained_variance_ratio = eigenvalues / total_variance
```

Meaning:

```text
component_i_variance / total_variance
```

Example:

```text
PC1 explains 25%
PC2 explains 12%
PC3 explains 8%
```

Cumulative variance:

```python
cumulative = np.cumsum(explained)
```

This tells:

```text
how much information is retained using first k components
```

---

## Step 15: Check Orthonormality

PCA components should be orthonormal.

Code:

```python
P = pca["components"][:k_check]
orthonormal_matrix = P @ P.T
```

If components are orthonormal:

```text
P @ P.T = identity matrix
```

Meaning:

- each component has length 1
- different components are perpendicular

This connects to your lecture:

```text
orthonormal basis is the most convenient basis
```

---

## Step 16: Check Covariance in PCA Space

Code:

```python
Z_check = transform_pca(X, pca, k_check)
cov_z = (Z_check.T @ Z_check) / len(Z_check)
```

If PCA works:

```text
cov_z should be almost diagonal
```

That means:

```text
new dimensions are uncorrelated
```

This is the decorrelation interpretation.

---

## Step 17: Display Eigenfaces

Code:

```python
eigenfaces = pca["components"][:num_eigenfaces].reshape(
    num_eigenfaces,
    image_height,
    image_width
)
```

Before reshape:

```text
one component shape = (4096,)
```

After reshape:

```text
one eigenface shape = (64, 64)
```

These images are not real people.

They are directions of variation.

They show patterns like:

- lighting direction
- face outline
- eye region variation
- mouth/nose variation
- pose changes

---

## Step 18: Project Faces into PCA Space

Function:

```python
def transform_pca(X, pca_model, k):
    components = pca_model["components"][:k]
    return (X - pca_model["mean"]) @ components.T
```

Concept:

```text
take original face
subtract mean face
find coordinates in eigenface basis
```

Output:

```text
Z shape = (m, k)
```

Example:

```text
X shape = (400, 4096)
Z shape = (400, 50)
```

This means each face is now represented by only 50 numbers.

Those 50 numbers are coefficients:

```text
alpha_1, alpha_2, ..., alpha_50
```

---

## Step 19: Reconstruct Faces

Function:

```python
def reconstruct_pca(Z, pca_model, k):
    components = pca_model["components"][:k]
    return Z @ components + pca_model["mean"]
```

Concept:

```text
face approx = mean face + weighted sum of top eigenfaces
```

Formula:

```text
x_hat = mean + alpha1*p1 + alpha2*p2 + ... + alphak*pk
```

Where:

- `p1, p2, ..., pk` are eigenfaces
- `alpha1, alpha2, ..., alphak` are PCA coordinates

If `k` is small:

```text
face is blurry but basic structure is visible
```

If `k` is large:

```text
face becomes closer to original
```

---

## Step 20: Reconstruction Error

Code:

```python
mse = np.mean((X - X_reconstructed) ** 2)
```

This measures:

```text
average squared difference between original and reconstructed pixels
```

As `k` increases:

```text
MSE decreases
```

This proves the reconstruction-error interpretation.

---

## 5. Full PCA Code Flow in One Block

Conceptually, the notebook does this:

```python
# 1. Load face images
images, labels, source = load_face_dataset()

# 2. Convert image dataset into matrix
X = images.reshape(num_images, -1)

# 3. Fit PCA
pca = fit_pca_from_scratch(X, max_components=200)

# 4. Visualize eigenfaces
eigenfaces = pca["components"].reshape(num_components, height, width)

# 5. Project original faces to lower dimension
Z = transform_pca(X, pca, k=50)

# 6. Reconstruct from lower dimension
X_reconstructed = reconstruct_pca(Z, pca, k=50)
```

The most important line conceptually:

```python
Z = (X - mean_face) @ eigenfaces.T
```

This means:

```text
represent each face using eigenface coordinates
```

---

## 6. Why Eigenvectors Appear in PCA

The covariance matrix is symmetric:

```text
Sigma = X.T @ X / m
```

For a symmetric matrix:

```text
eigenvectors are orthogonal
```

That is perfect for PCA because we want:

```text
new basis vectors that are independent and perpendicular
```

Also:

```text
max p.T @ Sigma @ p subject to ||p|| = 1
```

is solved by:

```text
top eigenvector of Sigma
```

So PCA is not magic.

It is choosing the orthonormal direction where variance is maximum.

Then it repeats this for the next direction, while staying orthogonal to previous directions.

---

## 7. Eigenfaces Intuition

An eigenface is not a normal face.

It is a direction.

Think of it like this:

```text
mean face
+ 2.1 * eigenface_1
- 0.7 * eigenface_2
+ 1.3 * eigenface_3
...
= reconstructed face
```

Every face in the dataset can be approximated as:

```text
mean face + linear combination of eigenfaces
```

That is why PCA is connected to basis vectors.

Eigenfaces form a new face-specific basis.

---

## 8. Important Variables in the Notebook

| Variable | Meaning |
|---|---|
| `images` | Face images as 3D array: `(m, height, width)` |
| `labels` | Person/folder labels if available |
| `X` | Flattened data matrix: `(m, pixels)` |
| `mean_face` | Average face vector |
| `X_centered` | Data after subtracting mean face |
| `gram` | Smaller matrix: `(m, m)` used for eigenfaces trick |
| `eigenvalues` | Variance captured by each principal component |
| `components` | Principal components / eigenfaces |
| `explained_variance_ratio` | Fraction of variance captured |
| `Z` | Low-dimensional PCA coordinates |
| `X_reconstructed` | Approximation of original faces |

---

## 9. Common Confusions

### Is PCA supervised?

No.

PCA does not use class labels.

It only uses image pixel values.

Labels are used only for plotting or checking clusters.

---

### Are eigenfaces real faces?

No.

They are basis directions.

They may look ghost-like because they contain positive and negative pixel patterns.

---

### Why subtract the mean face?

Because PCA studies variation.

Without centering, PCA may waste its first component representing the average brightness/average face instead of meaningful differences.

---

### Why do low `k` reconstructions look blurry?

Because only large-scale structure is kept.

Small details often live in lower-variance components.

---

### Why not keep all components?

Keeping all components gives almost full reconstruction, but no compression.

PCA is useful because we keep:

```text
top k important components
```

and drop:

```text
low-variance components
```

---

## 10. How to Study the Notebook

Recommended order:

1. Run dataset loading.
2. Look at sample faces.
3. Look at mean face.
4. Read `fit_pca_from_scratch`.
5. Look at eigenfaces.
6. Study variance plot.
7. Compare reconstructions for different `k`.
8. Read `transform_pca` and `reconstruct_pca`.

If you understand these two functions, you understand PCA implementation:

```python
def transform_pca(X, pca_model, k):
    components = pca_model["components"][:k]
    return (X - pca_model["mean"]) @ components.T


def reconstruct_pca(Z, pca_model, k):
    components = pca_model["components"][:k]
    return Z @ components + pca_model["mean"]
```

Short meaning:

```text
transform = go from pixel space to eigenface space
reconstruct = come back from eigenface space to pixel space
```

---

## 11. One-Line Summary

PCA finds the eigenvectors of the covariance matrix, uses them as an orthonormal basis, keeps the top high-variance directions, and represents each face as a small list of coefficients over eigenfaces.

