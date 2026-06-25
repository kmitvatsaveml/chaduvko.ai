# SVD From Scratch — Input → Operation → Output Flow

This guide follows [svd_from_scratch.ipynb](svd_from_scratch.ipynb) in execution order.

Use it when explaining the notebook to your professor:

> “This cell takes these inputs, performs this mathematical operation, produces this output, and demonstrates this SVD idea.”

The notebook uses several matrices. They are different examples of the same SVD ideas:

| Matrix | Actual input | Why it is used |
|---|---|---|
| $A$ | $\begin{bmatrix}3&0\\4&5\end{bmatrix}$ | small example where SVD geometry can be visualised |
| $M$ | a random $6\times4$ matrix | check the defining SVD identities |
| $B$ | a $20\times15$ matrix with four strong rank-1 patterns plus small noise | show singular-value decay and low-rank approximation |
| $\text{gray}$ | a real grayscale photo matrix | image compression |
| $X$ | $1797\times64$ handwritten-digit dataset | show that SVD and PCA agree |
| final $A$ | a constructed $50\times20$ ill-conditioned matrix | show why forming $A^\top A$ can be numerically unsafe |

---

## Cells 0–2 — Goal and setup

### Cell 0: SVD goal

- **Input:** any real matrix $A\in\mathbb{R}^{m\times n}$.
- **Mathematical statement:**

  $$
  A=U\Sigma V^\top.
  $$

- **Output:** the roadmap: find orthogonal input directions $V$, stretch factors $\Sigma$, and orthogonal output directions $U$.
- **What to say:** “We want to express any matrix as rotate/reflect, then scale, then rotate/reflect.”

### Cell 1: numerical setup

- **Input:** none.
- **Operation:** fixes a random seed and imports numerical/plotting tools.
- **Output:** reproducible random matrices and plots.
- **What to say:** “The random seed makes the same examples appear every time.”

### Cell 2: mathematical recipe

- **Input:** a general $m\times n$ matrix $A$.
- **Operation:**

  $$
  A^\top A=V\Lambda V^\top,
  \qquad
  \sigma_i=\sqrt{\lambda_i},
  \qquad
  u_i=\frac{Av_i}{\sigma_i}.
  $$

- **Output:** the recipe for constructing the SVD from an eigendecomposition.
- **What to say:** “The eigenvectors of $A^\top A$ become the right singular vectors. Square roots of its eigenvalues become singular values. Multiplying $v_i$ by $A$ gives the corresponding left singular vector.”

---

# Example 1 — Small matrix, full SVD construction

## Cell 3: build an SVD from scratch

### Input

The notebook chooses:

$$
A=
\begin{bmatrix}
3&0\\
4&5
\end{bmatrix}.
$$

This is a $2\times2$ matrix.

### Operation

1. Form:

   $$
   A^\top A
   =
   \begin{bmatrix}
   25&20\\
   20&25
   \end{bmatrix}.
   $$

2. Find its eigenvalues and orthonormal eigenvectors:

   $$
   A^\top A v_i=\lambda_i v_i.
   $$

3. Take square roots:

   $$
   \sigma_i=\sqrt{\lambda_i}.
   $$

4. Build:

   $$
   u_i=\frac{Av_i}{\sigma_i}.
   $$

5. Reconstruct:

   $$
   \widehat A=U\Sigma V^\top.
   $$

### Output

- singular values from the manual construction;
- reconstruction error:

  $$
  \|A-\widehat A\|_F;
  $$

- singular values from NumPy’s reference SVD.

### Meaning

The reconstruction error should be around machine zero, and the singular values should agree with the reference routine.

### Professor-ready sentence

> “For the explicit matrix $\begin{bmatrix}3&0\\4&5\end{bmatrix}$, we construct $V$ from eigenvectors of $A^\top A$, obtain $\sigma_i$ from square roots of its eigenvalues, calculate $U$ from $Av_i/\sigma_i$, and verify that $U\Sigma V^\top$ reconstructs the original matrix.”

## Cell 4: sign ambiguity

- **Input:** the SVD just constructed.
- **Operation:** recognise that:

  $$
  (u_i,v_i)\quad\text{and}\quad(-u_i,-v_i)
  $$

  produce the same rank-1 term:

  $$
  \sigma_i u_i v_i^\top.
  $$

- **Output:** reason to compare reconstructed matrices or singular values rather than raw singular-vector signs.
- **Meaning:** a sign difference is not an error.

## Cell 5: verify SVD on a larger random matrix

### Input

$$
M\in\mathbb{R}^{6\times4},
$$

whose 24 entries are sampled from a standard normal distribution.

### Operation

Construct:

$$
M=U\Sigma V^\top.
$$

Then test:

$$
U^\top U=I,
\qquad
V^\top V=I,
$$

$$
Mv_i=\sigma_i u_i,
$$

and:

$$
\operatorname{rank}(M)
=\#\{\sigma_i>0\}.
$$

### Output

Boolean results confirming orthonormality, sorted singular values, the defining relation, and rank equality.

### Meaning

This is not a new example to interpret visually. It is a general correctness check: the construction works beyond the small $2\times2$ matrix.

---

# Example 2 — Geometry of the small matrix

## Cell 6: geometric interpretation

- **Input:** the factorisation:

  $$
  A=U\Sigma V^\top.
  $$

- **Operation:** interpret it right to left:

  $$
  x
  \xrightarrow{V^\top}
  \text{new input axes}
  \xrightarrow{\Sigma}
  \text{stretching by }\sigma_i
  \xrightarrow{U}
  Ax.
  $$

- **Output:** the claim that a unit circle under a matrix becomes an ellipse.
- **Meaning:** singular values are ellipse-axis lengths; singular vectors give special directions.

## Cell 7: circle-to-ellipse plot

### Input

The same small matrix:

$$
A=
\begin{bmatrix}
3&0\\
4&5
\end{bmatrix}.
$$

Also, 400 points on the unit circle:

$$
x(\theta)=
\begin{bmatrix}
\cos\theta\\
\sin\theta
\end{bmatrix},
\qquad
0\le\theta\le2\pi.
$$

### Operation

Transform every circle point:

$$
y(\theta)=Ax(\theta).
$$

### Output

- left plot: unit circle with the right singular vectors $v_1,v_2$;
- right plot: transformed ellipse with the vectors $\sigma_1u_1,\sigma_2u_2$.

### Meaning

The unit circle becomes an ellipse. The directions $v_i$ are the input directions that get sent exactly to $\sigma_i u_i$.

### Professor-ready sentence

> “This plot gives the geometry of SVD: $V^\top$ aligns the circle with special input directions, $\Sigma$ changes the two radii to $\sigma_1$ and $\sigma_2$, and $U$ rotates the resulting ellipse.”

---

# Example 3 — A matrix with a few important directions

## Cell 8: rank-1 expansion and energy

- **Input:** any SVD:

  $$
  A=U\Sigma V^\top.
  $$

- **Operation:** expand it:

  $$
  A=\sum_{i=1}^{r}\sigma_i u_i v_i^\top.
  $$

- **Output:** the idea of ordered rank-1 layers and the identity:

  $$
  \|A\|_F^2=\sum_i\sigma_i^2.
  $$

- **Meaning:** $\sigma_i^2$ measures how much of the matrix’s total squared energy belongs to direction $i$.

## Cell 9: create and analyse $B$

### Input

Four random outer-product matrices of shape $20\times15$:

$$
u_1v_1^\top,\quad u_2v_2^\top,\quad u_3v_3^\top,\quad u_4v_4^\top.
$$

They are given strengths $10,6,3,1$, then small random noise is added:

$$
B
=10u_1v_1^\top
+6u_2v_2^\top
+3u_3v_3^\top
+1u_4v_4^\top
+0.05E.
$$

Here $E$ is a random $20\times15$ noise matrix.

### Operation

Compute the SVD:

$$
B=U\Sigma V^\top.
$$

Then calculate:

$$
\|B\|_F^2
$$

and:

$$
\sum_i\sigma_i^2,
$$

plus cumulative energy:

$$
\frac{\sum_{i=1}^{k}\sigma_i^2}{\sum_i\sigma_i^2}.
$$

### Output

- a stem plot of singular values;
- a cumulative-energy curve;
- the smallest $k$ whose retained energy is at least 99%.

### Meaning

The input was intentionally built to have roughly four strong directions. The plot should show a few large singular values followed by much smaller noise singular values.

### Professor-ready sentence

> “We manufacture a $20\times15$ matrix containing four strong rank-1 patterns plus weak noise. SVD discovers those important directions through its large singular values.”

---

# Best rank-$k$ approximation

## Cell 10: theorem to be tested

- **Input:** a matrix with SVD:

  $$
  A=\sum_{i=1}^{r}\sigma_i u_i v_i^\top.
  $$

- **Operation:** retain only the first $k$ terms:

  $$
  A_k=\sum_{i=1}^{k}\sigma_i u_i v_i^\top.
  $$

- **Output:** the Eckart–Young–Mirsky claim:

  $$
  A_k
  =\underset{\operatorname{rank}(C)\le k}{\arg\min}\|A-C\|_F,
  $$

  with error:

  $$
  \|A-A_k\|_F^2=\sum_{i>k}\sigma_i^2.
  $$

- **Meaning:** keeping the largest singular values is the best possible rank-$k$ compression in Frobenius error.

## Cell 11: test the error formula on $B$

### Input

The same $20\times15$ matrix $B$ from Cell 9, and several ranks:

$$
k\in\{1,2,3,4,6\}.
$$

### Operation

For each $k$, form:

$$
B_k=U_k\Sigma_kV_k^\top.
$$

Compare:

$$
\underbrace{\|B-B_k\|_F^2}_{\text{measured squared reconstruction error}}
$$

with:

$$
\underbrace{\sum_{i>k}\sigma_i^2}_{\text{discarded singular-value energy}}.
$$

### Output

A table with one row per $k$. The two numeric columns should match.

### Meaning

This demonstrates that the approximation error is exactly the energy of the singular layers removed.

## Cell 12: Monte Carlo comparison — what exactly is happening?

This is the cell you should explain carefully.

### Input

- Target matrix:

  $$
  A=B\in\mathbb{R}^{20\times15}.
  $$

- Requested rank:

  $$
  k=3.
  $$

- Number of random trials:

  $$
  4000.
  $$

- Benchmark: the SVD rank-3 approximation:

  $$
  A_3=U_3\Sigma_3V_3^\top.
  $$

### Operation in one trial

1. Create a random matrix:

   $$
   Y\in\mathbb{R}^{20\times3}.
   $$

   Its three columns span a random 3-dimensional subspace of $\mathbb{R}^{20}$.

2. Ask: among all matrices whose columns must lie in this particular random subspace, which one is closest to $A$?

   The answer is the orthogonal projection:

   $$
   B^*=YY^+A,
   $$

   where $Y^+$ is the Moore–Penrose pseudoinverse.

3. Measure its error:

   $$
   \|A-B^*\|_F^2.
   $$

4. Repeat for 4000 different random subspaces and retain the smallest random error.

### Output

It prints:

$$
\text{SVD error } \|A-A_3\|_F^2
$$

and:

$$
\text{best error among 4000 random rank-3 candidates}.
$$

The SVD error should be no larger.

### What the Monte Carlo experiment proves and does not prove

- It **illustrates** that a random rank-3 subspace is usually worse than the SVD’s chosen rank-3 subspace.
- It does **not prove** optimality, because 4000 random trials are not all possible rank-3 matrices.
- The Eckart–Young–Mirsky theorem is the proof that no rank-3 matrix can beat $A_3$.

### One code detail worth knowing

A random $Z\in\mathbb{R}^{3\times15}$ is generated in the cell, suggesting a generic rank-3 form $YZ$. But it is not used in the final error comparison. The actual candidate compared is:

$$
B^*=YY^+A,
$$

because this is the best possible matrix with columns in $\operatorname{col}(Y)$. This makes the random-subspace comparison stronger and fairer.

### Professor-ready sentence

> “For $k=3$, we compare the SVD’s optimal rank-3 approximation with 4000 random three-dimensional output subspaces. In each random subspace, we project the target matrix onto it using $YY^+A$. Even the best random projection does not beat the truncated SVD, exactly as Eckart–Young predicts.”

---

# Image compression

## Cell 13: compression statement

- **Input:** a grayscale image viewed as:

  $$
  A\in\mathbb{R}^{m\times n}.
  $$

- **Operation:** approximate it by:

  $$
  A_k=U_k\Sigma_kV_k^\top.
  $$

- **Output:** storage comparison:

  $$
  \text{full image}=mn,
  \qquad
  \text{rank-}k\text{ storage}=k(m+n+1).
  $$

- **Meaning:** use few strong singular layers instead of every pixel independently.

## Cell 14: real image input and reconstructions

### Input

- A colour photograph supplied by the scikit-learn sample dataset.
- It is converted to one grayscale matrix:

  $$
  \text{gray}\in\mathbb{R}^{m\times n}.
  $$

- The notebook tries ranks:

  $$
  k=2,5,20,50,100,\min(m,n).
  $$

### Operation

For every selected rank:

$$
\text{gray}_k=U_k\Sigma_kV_k^\top.
$$

It also calculates:

$$
\text{relative error}
=\frac{\|\text{gray}-\text{gray}_k\|_F}{\|\text{gray}\|_F}
$$

and:

$$
\text{storage ratio}
=\frac{k(m+n+1)}{mn}.
$$

### Output

A grid of reconstructed images. Every panel reports its rank, relative error, and storage percentage.

### Meaning

Increasing $k$ retains more singular layers, so visual detail improves, error falls, and storage rises.

## Cell 15: full error-versus-rank check

### Input

The same grayscale image and all allowed ranks:

$$
k=1,2,\ldots,\min(m,n).
$$

### Operation

Compare:

$$
\|\text{gray}-\text{gray}_k\|_F
$$

with:

$$
\sqrt{\sum_{i>k}\sigma_i^2}.
$$

### Output

One measured error curve and one theoretical error curve. They overlap. A final number reports their largest numerical difference.

### Meaning

The singular-value tail predicts image-compression error exactly.

---

# PCA connection

## Cell 16: derive PCA from SVD

### Input

Centred data:

$$
X_c=X-\mu,
$$

with samples as rows and features as columns.

### Operation

Use:

$$
X_c=U\Sigma V^\top.
$$

Then:

$$
\frac{1}{m}X_c^\top X_c
=V\left(\frac{\Sigma^\top\Sigma}{m}\right)V^\top.
$$

### Output

The identities:

$$
\text{PCA directions}=V,
\qquad
\text{PCA variances}=\frac{\sigma_i^2}{m}.
$$

### Meaning

PCA covariance eigendecomposition and SVD of centred data describe the same directions.

## Cell 17: digits dataset, two PCA routes

### Input

The handwritten digits dataset:

$$
X\in\mathbb{R}^{1797\times64}.
$$

Each row is one $8\times8$ digit image flattened into 64 pixel values.

### Operation

1. Compute the mean pixel vector $\mu$ and centre:

   $$
   X_c=X-\mu.
   $$

2. Route 1: eigendecompose covariance:

   $$
   C=\frac1mX_c^\top X_c=P\Lambda P^\top.
   $$

3. Route 2: take SVD:

   $$
   X_c=U\Sigma V^\top.
   $$

4. Compare:

   $$
   \lambda_i\stackrel{?}{=}\sigma_i^2/m,
   \qquad
   p_i\stackrel{?}{=}\pm v_i.
   $$

### Output

Two Boolean results confirming the PCA variances and principal directions match.

## Cell 18: eigen-digits and one digit’s reconstruction

### Input

- mean digit $\mu$;
- first five columns of $V$;
- the first digit:

  $$
  x=X_1;
  $$

- reconstruction ranks:

  $$
  k=1,4,12,24,40,64.
  $$

### Operation

For each rank:

$$
\widehat x_k
=\mu+(x-\mu)V_kV_k^\top.
$$

### Output

- top row: mean digit and first five eigen-digits;
- bottom row: the same digit reconstructed using increasing numbers of PCA/SVD directions.

### Meaning

The figure shows projection onto progressively larger principal subspaces.

---

# Numerical-stability example

## Cell 19: stability claim

- **Input:** a matrix with a very small singular value.
- **Operation:** compare its condition number with that of $A^\top A$:

  $$
  \kappa(A)=\frac{\sigma_{\max}}{\sigma_{\min}},
  \qquad
  \kappa(A^\top A)=\kappa(A)^2.
  $$

- **Output:** reason not to form $A^\top A$ in production SVD routines.
- **Meaning:** the mathematical derivation is clean, but squaring can erase weak singular directions numerically.

## Cell 20: deliberately ill-conditioned matrix

### Input

Dimensions:

$$
m=50,
\qquad
n=20.
$$

Chosen true singular values:

$$
\sigma_1,\ldots,\sigma_{20}
=1,\ldots,10^{-8}.
$$

The matrix is built as:

$$
A=U_qSV_q^\top,
$$

where $U_q$ and $V_q$ are orthogonal and $S$ contains those known singular values.

### Operation

Compare:

$$
\text{direct SVD of }A
$$

with:

$$
\sigma_i=\sqrt{\lambda_i(A^\top A)}.
$$

### Output

- true smallest singular value: $10^{-8}$;
- smallest value recovered by direct SVD;
- smallest value recovered through $A^\top A$;
- $\kappa(A)$ and $\kappa(A^\top A)$.

### Meaning

The direct method preserves the small value better. The normal-equation route squares the condition number, so it can lose numerical accuracy.

## Cell 21: closing summary

- **Input:** all established identities.
- **Operation:** collect them:

  $$
  A=U\Sigma V^\top,
  \qquad
  \|A\|_F^2=\sum_i\sigma_i^2,
  $$

  $$
  \|A-A_k\|_F^2=\sum_{i>k}\sigma_i^2,
  \qquad
  \lambda_i=\sigma_i^2/m.
  $$

- **Output:** one final map from SVD to compression and PCA.

---

# Short oral explanation for your professor

> “I first derived SVD from the eigendecomposition of $A^\top A$. Its eigenvectors become $V$, the square roots of its eigenvalues become the singular values, and $u_i=Av_i/\sigma_i$ gives $U$. I verified this on a small matrix and a random matrix. Then I interpreted SVD geometrically as rotate, stretch, rotate. Next I used the rank-1 expansion to show that keeping the largest singular values gives the best rank-$k$ approximation, verified its exact error formula, and compared it with 4000 random rank-3 subspaces. Finally, I used SVD for image compression, proved its equivalence to PCA on centred digits data, and showed why direct SVD is numerically safer than using $A^\top A$.”
