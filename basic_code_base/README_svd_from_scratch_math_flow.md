# SVD From Scratch — Mathematical Flow, Cell by Cell

This is the mathematics behind [svd_from_scratch.ipynb](svd_from_scratch.ipynb). It deliberately explains the mathematical object and conclusion of each cell, rather than the programming.

## The one flow behind the entire notebook

Let

$$
A\in\mathbb{R}^{m\times n}.
$$

The notebook proves and uses this chain:

$$
A^\top A
\longrightarrow
\text{eigenvectors }V
\text{ and eigenvalues }\lambda_i
\longrightarrow
\sigma_i=\sqrt{\lambda_i}
\longrightarrow
u_i=\frac{Av_i}{\sigma_i}
\longrightarrow
A=U\Sigma V^\top.
$$

Then it keeps only the largest singular values to obtain the best low-rank approximation. Image compression and PCA are applications of exactly that fact.

## Symbols to keep fixed in your mind

$$
A=U\Sigma V^\top
=\sum_{i=1}^{r}\sigma_i u_i v_i^\top,
\qquad
r=\operatorname{rank}(A).
$$

| Object | Mathematical meaning |
|---|---|
| $v_i$ | an orthonormal input direction |
| $u_i$ | the corresponding orthonormal output direction |
| $\sigma_i$ | how much $A$ stretches direction $v_i$ |
| $r$ | number of nonzero singular values |
| $A_k$ | the approximation formed by keeping only the first $k$ singular directions |

The basic singular-vector relation is:

$$
Av_i=\sigma_i u_i.
$$

It says: feed the special input direction $v_i$ into $A$; the result points along $u_i$ and has length $\sigma_i$.

---

# Part 1 — Constructing the SVD

## Cell 0 — The destination

The first cell states the SVD:

$$
A=U\Sigma V^\top.
$$

Read the product from right to left:

$$
x
\xrightarrow{V^\top}
\text{change of input axes}
\xrightarrow{\Sigma}
\text{independent stretching}
\xrightarrow{U}
\text{change of output axes}.
$$

The notebook will now derive all three pieces, $U$, $\Sigma$, and $V$.

## Cell 1 — Numerical setting

No new linear-algebra result occurs here. It establishes the numerical environment. Later, a reconstruction error close to $10^{-15}$ is interpreted as zero for practical purposes because decimal computers use finite-precision arithmetic.

## Cell 2 — Why $A^\top A$ is the starting point

The matrix

$$
A^\top A\in\mathbb{R}^{n\times n}
$$

is always symmetric:

$$
(A^\top A)^\top=A^\top A.
$$

It is also positive semidefinite. For any vector $x$:

$$
x^\top A^\top A x
=(Ax)^\top(Ax)
=\|Ax\|_2^2
\ge 0.
$$

Therefore the spectral theorem applies:

$$
A^\top A=V\Lambda V^\top,
\qquad
V^\top V=I,
\qquad
\Lambda=\operatorname{diag}(\lambda_1,\ldots,\lambda_n),
\qquad
\lambda_i\ge0.
$$

The eigenvectors $v_i$ become the right singular vectors. Define:

$$
\sigma_i=\sqrt{\lambda_i}.
$$

For every positive singular value, define:

$$
u_i=\frac{Av_i}{\sigma_i}.
$$

Then:

$$
Av_i=\sigma_i u_i.
$$

Also:

$$
A^\top u_i
=A^\top\frac{Av_i}{\sigma_i}
=\frac{A^\top Av_i}{\sigma_i}
=\frac{\lambda_i}{\sigma_i}v_i
=\sigma_i v_i.
$$

The left singular vectors are automatically orthonormal:

$$
u_i^\top u_j
=\frac{v_i^\top A^\top Av_j}{\sigma_i\sigma_j}
=\frac{\lambda_j}{\sigma_i\sigma_j}v_i^\top v_j
=\delta_{ij}.
$$

This is the full mathematical derivation of a thin SVD:

$$
A=U_r\Sigma_rV_r^\top.
$$

Only nonzero singular values are kept, so $U_r$ has $r$ columns, $\Sigma_r$ is $r\times r$, and $V_r$ has $r$ columns.

## Cell 3 — The first reconstruction

For the small example matrix, the mathematical pipeline is:

$$
A^\top A
\xrightarrow{\text{eigendecomposition}}
(\lambda_i,v_i)
\xrightarrow{\sigma_i=\sqrt{\lambda_i}}
(\sigma_i,v_i)
\xrightarrow{u_i=Av_i/\sigma_i}
u_i.
$$

It checks the reconstructed identity:

$$
A\stackrel{?}{=}U\Sigma V^\top.
$$

The residual is:

$$
\|A-U\Sigma V^\top\|_F.
$$

In exact mathematics this is zero.

## Cell 4 — Why singular-vector signs may differ

If a pair $(u_i,v_i)$ is valid, then $(-u_i,-v_i)$ is also valid:

$$
\sigma_i(-u_i)(-v_i)^\top
=\sigma_i u_i v_i^\top.
$$

So the sign of an individual singular vector does not matter. The invariant fact is the reconstructed matrix $U\Sigma V^\top$.

For a repeated singular value, any orthonormal basis inside that singular subspace is also valid.

## Cell 5 — The defining properties being confirmed

For the thin SVD:

$$
A=U_r\Sigma_rV_r^\top,
$$

the mathematical checks are:

$$
U_r^\top U_r=I_r,
\qquad
V_r^\top V_r=I_r,
$$

$$
\sigma_1\ge\sigma_2\ge\cdots\ge\sigma_r>0,
$$

$$
AV_r=U_r\Sigma_r,
$$

and:

$$
\operatorname{rank}(A)
=\#\{i:\sigma_i>0\}.
$$

---

# Part 2 — The geometry

## Cell 6 — Rotate, stretch, rotate

For a vector $x$:

$$
Ax=U\Sigma V^\top x.
$$

The matrices $U$ and $V$ are orthogonal, so they preserve length:

$$
\|Ux\|_2=\|x\|_2,
\qquad
\|V^\top x\|_2=\|x\|_2.
$$

They rotate or reflect coordinate systems. The only scaling occurs in $\Sigma$:

$$
\Sigma e_i=\sigma_i e_i.
$$

So singular values are the independent stretch factors of $A$.

## Cell 7 — Unit circle becomes ellipse

Consider all 2D input vectors on the unit circle:

$$
\|x\|_2=1.
$$

Write $x=Vz$. Since $V$ is orthogonal, $\|z\|_2=1$. Then:

$$
Ax=U\Sigma z.
$$

$\Sigma$ turns the circle into an ellipse whose semi-axis lengths are:

$$
\sigma_1,\sigma_2.
$$

$U$ rotates that ellipse into its final orientation.

Therefore:

- $v_i$ are the special input directions;
- $\sigma_i$ are the ellipse semi-axis lengths;
- $u_i$ are the ellipse-axis directions in output space.

---

# Part 3 — Rank-1 layers and energy

## Cell 8 — Breaking a matrix into ordered layers

Multiplying out the SVD gives:

$$
A=\sum_{i=1}^{r}\sigma_i u_i v_i^\top.
$$

Each outer product $u_i v_i^\top$ has rank 1. So $A$ is a sum of rank-1 layers, sorted by strength.

The Frobenius norm is:

$$
\|A\|_F^2=\sum_{p,q}A_{pq}^2.
$$

For an SVD:

$$
\|A\|_F^2=\sum_{i=1}^{r}\sigma_i^2.
$$

Thus $\sigma_i^2$ is the energy in the $i$th singular layer. The energy retained by the first $k$ layers is:

$$
\frac{\sum_{i=1}^{k}\sigma_i^2}
{\sum_{i=1}^{r}\sigma_i^2}.
$$

## Cell 9 — Reading a singular-value spectrum

This cell uses a matrix with a few dominant singular values:

$$
\sigma_1\gg\sigma_2\gg\sigma_3\gg\cdots.
$$

The spectrum asks: which rank-1 directions carry most of the matrix?

The cumulative-energy curve asks: how many directions are required to keep, for example, 99% of the total energy?

If it rises quickly, the matrix is approximately low rank: it may technically have many nonzero singular values, but only a few are important.

---

# Part 4 — Best rank-$k$ approximation

## Cell 10 — The central approximation theorem

Keep only the first $k$ singular layers:

$$
A_k
=\sum_{i=1}^{k}\sigma_i u_i v_i^\top
=U_k\Sigma_kV_k^\top.
$$

It has rank at most $k$:

$$
\operatorname{rank}(A_k)\le k.
$$

The discarded part is:

$$
A-A_k=\sum_{i=k+1}^{r}\sigma_i u_i v_i^\top.
$$

Its squared error is:

$$
\|A-A_k\|_F^2
=\sum_{i=k+1}^{r}\sigma_i^2.
$$

The Eckart–Young–Mirsky theorem says much more:

$$
A_k
=\underset{\operatorname{rank}(C)\le k}{\arg\min}
\ \|A-C\|_F.
$$

Among every possible rank-$k$ matrix, $A_k$ is the closest one to $A$.

## Cell 11 — Error equals discarded energy

For each selected rank $k$, the cell compares:

$$
\|B-B_k\|_F^2
$$

with:

$$
\sum_{i>k}\sigma_i^2.
$$

They must match. The loss is precisely the energy in the singular layers that were not retained.

## Cell 12 — Other rank-$k$ choices cannot win

A rank-$k$ approximation can preserve only $k$ independent directions. SVD preserves the directions with largest energies:

$$
\sigma_1^2+\cdots+\sigma_k^2.
$$

Every other choice must discard at least:

$$
\sigma_{k+1}^2+\cdots+\sigma_r^2.
$$

The cell illustrates this using alternative random $k$-dimensional subspaces. They have larger error. The theorem guarantees the result for all rank-$k$ competitors, not only random ones.

---

# Part 5 — Image compression

## Cell 13 — The mathematical compression idea

A grayscale image is a matrix:

$$
A\in\mathbb{R}^{m\times n}.
$$

Its best rank-$k$ image is:

$$
A_k=\sum_{i=1}^{k}\sigma_i u_i v_i^\top.
$$

The full image stores $mn$ values. The rank-$k$ representation stores:

$$
\underbrace{mk}_{U_k}
+\underbrace{k}_{\Sigma_k}
+\underbrace{nk}_{V_k}
=k(m+n+1)
$$

values.

Compression is useful when $k\ll\min(m,n)$ and the discarded singular values are small.

## Cell 14 — A family of rank-$k$ images

Every displayed approximation is:

$$
A_k=U_k\Sigma_kV_k^\top.
$$

As $k$ increases, the approximation keeps more rank-1 layers, so:

$$
\|A-A_k\|_F
$$

decreases.

The relative error is:

$$
\frac{\|A-A_k\|_F}{\|A\|_F}
=\sqrt{
\frac{\sum_{i>k}\sigma_i^2}
{\sum_i\sigma_i^2}
}.
$$

## Cell 15 — The error curve is determined exactly

For every $k$:

$$
\|A-A_k\|_F
=\sqrt{\sum_{i>k}\sigma_i^2}.
$$

Once the singular values are known, the best possible Frobenius error at every rank is already known. The measured reconstruction curve and the theoretical discarded-energy curve must coincide.

---

# Part 6 — SVD is PCA for centred data

## Cell 16 — Deriving the PCA connection

Let centred data be:

$$
X_c\in\mathbb{R}^{m\times n},
$$

where rows are samples and columns are features. Its covariance matrix is:

$$
C=\frac{1}{m}X_c^\top X_c.
$$

Take the SVD:

$$
X_c=U\Sigma V^\top.
$$

Then:

$$
\begin{aligned}
C
&=\frac{1}{m}(U\Sigma V^\top)^\top(U\Sigma V^\top)\\
&=\frac{1}{m}V\Sigma^\top U^\top U\Sigma V^\top\\
&=V\left(\frac{\Sigma^\top\Sigma}{m}\right)V^\top.
\end{aligned}
$$

This is the eigendecomposition of covariance. Therefore:

$$
\boxed{\text{PCA principal directions}=V}
$$

and:

$$
\boxed{\text{PCA variances }\lambda_i=\frac{\sigma_i^2}{m}}.
$$

## Cell 17 — The two PCA routes agree

The cell checks:

$$
\lambda_i=\frac{\sigma_i^2}{m}
$$

and:

$$
p_i=\pm v_i.
$$

The plus-or-minus is expected: both directions describe the same PCA axis.

## Cell 18 — Eigen-digits and projection

For one digit $x$, subtract the mean:

$$
x_c=x-\mu.
$$

Its coordinate along the $i$th principal direction is:

$$
z_i=x_c^\top v_i.
$$

Keeping only the first $k$ PCA/SVD directions gives:

$$
\widehat{x}_k
=\mu+\sum_{i=1}^{k}(x_c^\top v_i)v_i
=\mu+x_cV_kV_k^\top.
$$

This is the closest representation of the digit within the $k$-dimensional principal subspace.

---

# Part 7 — The numerical caution

## Cell 19 — Why the derivation is not the best production algorithm

The derivation uses $A^\top A$, but its condition number is squared:

$$
\kappa(A)=\frac{\sigma_{\max}}{\sigma_{\min}}
\quad\Longrightarrow\quad
\kappa(A^\top A)=\kappa(A)^2.
$$

If:

$$
\sigma_{\min}=10^{-8},
$$

then:

$$
\lambda_{\min}=\sigma_{\min}^2=10^{-16}.
$$

That squared quantity can be small enough to be lost to floating-point roundoff. So forming $A^\top A$ is excellent for the proof, but not always stable for computation.

## Cell 20 — The ill-conditioned example

The matrix is built with known singular values ranging from $1$ down to $10^{-8}$. It compares:

$$
\text{direct SVD of }A
$$

with:

$$
\text{eigendecomposition of }A^\top A
\quad\text{then}\quad
\sigma_i=\sqrt{\lambda_i}.
$$

The second route can lose the smallest singular value because it squares it first. Practical SVD algorithms act directly on $A$.

---

## Cell 21 — Summary

The final notebook cell does not introduce a new theorem. It gathers the conclusions already established:

$$
A=U\Sigma V^\top,
\qquad
\|A\|_F^2=\sum_i\sigma_i^2,
\qquad
\|A-A_k\|_F^2=\sum_{i>k}\sigma_i^2,
$$

$$
\text{PCA directions}=V,
\qquad
\text{PCA variances}=\sigma_i^2/m.
$$

# Final memory map

$$
\boxed{
A^\top A
\xrightarrow{\text{eigenvectors}}
V
}
$$

$$
\boxed{
\lambda_i(A^\top A)
\xrightarrow{\sqrt{\phantom{x}}}
\sigma_i
}
$$

$$
\boxed{
u_i=\frac{Av_i}{\sigma_i}
\xrightarrow{}
U
}
$$

$$
\boxed{
A=U\Sigma V^\top
\xrightarrow{\text{keep top }k}
A_k
}
$$

$$
\boxed{
A_k\text{ is the best rank-}k\text{ approximation, and }
\|A-A_k\|_F^2=\sum_{i>k}\sigma_i^2
}
$$

One sentence to keep:

> SVD finds the orthogonal input directions a matrix cares about, how strongly it stretches each one, and the matching orthogonal output directions.
