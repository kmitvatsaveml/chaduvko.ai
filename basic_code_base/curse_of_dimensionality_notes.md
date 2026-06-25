# The Curse of Dimensionality — Concepts, Maths, and What We Verified

These notes follow the lecture point by point. For each idea I state **what the lecture said**, give the **mathematics** behind it, add the **interpretation**, and note **what we computed** in the notebook to confirm it. No plots — just the reasoning and the numbers.

---

## 0. The setting

The lecture is about what happens to geometry, distance, and data when the number of dimensions $d$ grows large. The central message is that our intuition is trained in $d = 1, 2, 3$, and almost every intuition we own quietly breaks once $d$ is large. This matters because most machine-learning algorithms rest on notions of *distance* and *coverage* that silently assume low dimensions.

Throughout, a data point is a vector $x \in \mathbb{R}^{d}$, and $d$ is the dimension (the number of features / pixels / coordinates).

---

## 1. The intuition that fails — "nine points"

**What the lecture said.** Take nine points. On a 1-D line they cover the space well. Arranged in a 2-D square they already leave noticeable gaps. In a 3-D cube the same nine points leave the space almost empty. As $d$ grows the emptiness becomes severe and algorithms run out of data coverage.

**The maths.** To sample each axis at a fixed resolution of $r$ levels, a regular grid over $d$ axes contains

$$N = r^{\,d}$$

points. Equivalently, with a *fixed budget* of $N$ points, the per-axis resolution is only

$$r = N^{1/d},$$

which decays toward $1$ as $d$ increases. For $N = 9$: in 1-D we get $9$ levels per axis; in 2-D, $9^{1/2}=3$; in 3-D, $9^{1/3}\approx 2.08$; by 10-D, $9^{1/10}\approx 1.25$ — barely more than a single level per axis.

**Interpretation.** "Coverage" of a space is an exponential resource. A fixed number of samples spreads thinner and thinner per dimension, so in high dimensions any finite dataset is effectively a sparse scattering in a vast empty volume.

**What we did.** Computed $N^{1/d}$ for $N=9$ and showed the per-axis resolution collapses toward $1$.

---

## 2. The spiky cube — distance to a corner grows like $\sqrt{d}$

**What the lecture said.** For a square the distance from the centre to a corner is $\sqrt{1^2+1^2}=\sqrt2\approx 1.41$. For a cube it is $\sqrt{1^2+1^2+1^2}=\sqrt3\approx 1.73$. In 10-D it is $\sqrt{10}\approx 3.16$, in 100-D it is $\sqrt{100}=10$, and in 1000-D it is $\sqrt{1000}\approx 31.6$. (The lecture's spoken "3162" is a slip for $31.62$.)

**The maths.** Take the hypercube $[-1,1]^d$ centred at the origin, so each coordinate ranges over $[-1,1]$. The midpoint of a face is a unit vector like $(1,0,\dots,0)$, at distance

$$\big\|(1,0,\dots,0)\big\|_2 = 1$$

from the centre — and this is the **same for every $d$**. A corner is $(\pm 1, \pm 1, \dots, \pm 1)$, at distance

$$\big\|(1,1,\dots,1)\big\|_2 = \sqrt{\underbrace{1^2 + 1^2 + \cdots + 1^2}_{d}} = \sqrt{d}.$$

**Interpretation.** The faces never move, but the corners run away at rate $\sqrt{d}$. A high-dimensional cube is not "round" — it is a small core surrounded by $2^d$ ever-more-distant spikes (corners). The ratio corner/face $=\sqrt d$ means in 100-D the corners are ten times farther out than the faces.

**What we did.** Evaluated $\sqrt{d}$ for $d = 2, 3, 10, 100, 1000$ and recovered exactly $1.41,\,1.73,\,3.16,\,10,\,31.62$, with the face distance pinned at $1$.

---

## 3. Volume runs to a thin shell near the surface

**What the lecture said.** In high dimensions almost all the volume of a hypersphere sits in a thin shell near its surface; the interior is essentially empty.

**The maths.** Compare a ball of radius $1$ with a ball of radius $1-\varepsilon$. Volume scales as radius$^{\,d}$, so the fraction of the big ball that lies in the outer shell of thickness $\varepsilon$ is

$$1 - \frac{\text{vol}(1-\varepsilon)}{\text{vol}(1)} = 1 - (1-\varepsilon)^{d}.$$

Because the surviving inner fraction $(1-\varepsilon)^d \to 0$ for any $\varepsilon > 0$, the shell fraction $\to 1$.

**Interpretation.** Even a paper-thin rind swallows almost all the volume. "A typical point of a high-dimensional ball is near the boundary" — there is almost no interior left to be in. The same exponent $d$ that helped corners run away in §2 now drains the inside of the ball.

**What we did.** For the outer $10\%$ shell ($\varepsilon = 0.1$), evaluated $1-(0.9)^d$: it is $0.19$ at $d=2$, $0.41$ at $d=5$, $0.65$ at $d=10$, $0.99$ at $d=50$, and $\approx 1$ by $d=100$.

---

## 4. The vanishing sphere — ball-in-cube volume $\to 0$

**What the lecture said.** Inscribe a hypersphere inside the unit cube, touching each face. The fraction of the cube it fills is about $78.5\%$ in 2-D, $52.4\%$ in 3-D, $16.45\%$ in 5-D, and only $\approx 0.25\%$ in 10-D. So in high dimensions nearly all the cube's volume is in the **corners**, not near the centre.

**The maths.** The cube has side $1$ (volume $1$); the inscribed ball has radius $\tfrac12$. The volume of a $d$-dimensional ball of radius $r$ is

$$V_d(r) = \frac{\pi^{d/2}}{\Gamma\!\big(\tfrac{d}{2}+1\big)}\; r^{\,d},$$

where $\Gamma$ is the gamma function (the continuous factorial, $\Gamma(n+1)=n!$). Hence

$$\frac{\text{vol(ball)}}{\text{vol(cube)}} = \frac{\pi^{d/2}}{\Gamma\!\big(\tfrac{d}{2}+1\big)}\left(\tfrac12\right)^{d}.$$

The denominator $\Gamma(d/2+1)$ grows faster than the numerator's exponential $\pi^{d/2}(1/2)^d$, so the ratio collapses to $0$.

**Interpretation.** The ball touches the centre of each face but never reaches the corners, and in high dimensions the corners are where all the volume hides (consistent with §2). The "round" part of the cube becomes a negligible speck. This is why filling space with a single compact blob is hopeless in high dimensions.

**What we did.** Evaluated the ratio with the gamma function and reproduced $78.54\%,\,52.36\%,\,16.45\%,\,0.25\%$ for $d = 2, 3, 5, 10$.

---

## 5. Exponential data hunger

**What the lecture said.** To keep a fixed sampling density you need exponentially more data as $d$ grows: five evenly spaced points in 1-D become $5^2 = 25$ in 2-D and $5^3 = 125$ in 3-D. That exponential growth in data requirement *is* the curse of dimensionality.

**The maths.** Same exponential as §1, read as a budget. Fixing the per-axis density at $r$ levels,

$$N(d) = r^{\,d}, \qquad r = 5 \;\Rightarrow\; N(d) = 5^{d}.$$

**Interpretation.** This is the statistical face of the curse. Models need data spread across the input space to generalise; if the required count is $5^d$, then by $d=10$ you already need almost ten million samples just to keep a coarse five-level grid. Real datasets cannot keep pace, so the space is always under-sampled and estimators are starved.

**What we did.** Tabulated $5^d$: $5,\,25,\,125,\,3{,}125,\,9{,}765{,}625$ for $d = 1, 2, 3, 5, 10$.

---

## 6. Everything becomes orthogonal

**What the lecture said.** Place points uniformly at random in high dimensions and almost any two random vectors are nearly perpendicular. Formally, the expected cosine similarity between two random unit vectors is $0$, with variance proportional to $1/d$, so the distribution of angles concentrates around $90^\circ$ as $d$ grows.

**The maths.** Let $u, v$ be independent random unit vectors in $\mathbb{R}^d$. Their cosine similarity is the dot product $u\cdot v = \sum_{i=1}^d u_i v_i$. By symmetry each direction is equally likely, so

$$\mathbb{E}[u\cdot v] = 0, \qquad \operatorname{Var}(u\cdot v) = \frac{1}{d}.$$

Thus the typical magnitude of the cosine is about $1/\sqrt{d}$, and $u\cdot v \to 0$ in probability. Since $\cos\theta \approx 0$ means $\theta \approx 90^\circ$, the angle concentrates at a right angle.

**Interpretation.** "Direction" stops being informative: pick any two points and they are almost surely close to orthogonal, so angle- and dot-product-based similarity loses contrast. Any method that ranks neighbours by direction has less and less to work with as $d$ grows.

**What we did.** Sampled random unit vectors and measured the cosine similarity: the mean sat at $0$ and the variance tracked $1/d$ essentially exactly across $d = 2$ to $1000$ (e.g. $\operatorname{Var}\approx 0.0100$ at $d=100$, $\approx 0.00101$ at $d=1000$).

---

## 7. Distance concentration — nearest $\approx$ farthest (our addition)

**What this adds.** The lecture stresses that "distance measures become less meaningful." We made that precise with the standard *distance concentration* result.

**The maths.** For $N$ points drawn uniformly in $[0,1]^d$ and a query point $q$, let $d_{\min}$ and $d_{\max}$ be the nearest and farthest distances. The **relative contrast**

$$\frac{d_{\max} - d_{\min}}{d_{\min}} \xrightarrow[d\to\infty]{} 0.$$

Intuitively, each squared distance is a sum of $d$ independent coordinate-wise contributions, so by concentration of measure every pairwise distance clusters tightly around the same typical value; the gap between nearest and farthest shrinks relative to that value.

**Interpretation.** If the closest and the farthest neighbour are essentially the same distance away, then "nearest neighbour" carries almost no information. This is the death of $k$-NN, clustering by Euclidean distance, and radius-based methods on uniform high-dimensional data.

**What we did.** Computed the relative contrast for $1000$ uniform points: it fell from huge values in low dimensions to about $0.76$ at $d=50$, $0.45$ at $d=100$, and $0.12$ at $d=1000$ — near and far collapsing together.

---

## 8. Real data and the escape — MNIST (our addition)

The geometry of §§1–7 assumes data spread **uniformly** through the cube. Real data is not uniform; it lies on a thin, curved, low-dimensional **manifold**. We tested how much of the curse actually bites using MNIST, where each image is a point in $\mathbb{R}^{784}$ ($28\times 28$ pixels).

**Orthogonality, revisited.** Random $784$-dimensional vectors had mean cosine similarity $\approx 0$ with standard deviation $\approx 0.040 \approx 1/\sqrt{784}$ — exactly the §6 prediction. Real MNIST images, by contrast, had mean cosine similarity $\approx +0.40$. Digits share ink in the same central pixels, so they are strongly correlated and live in a narrow cone of directions, not spread over all of them.

**Distance contrast, revisited.** For uniform random $784$-d points the relative contrast was small ($\approx 0.16$, as §7 predicts). For real MNIST it stayed large ($\approx 2.7$): structure keeps near and far genuinely different, so distances remain usable.

**Intrinsic dimensionality (the escape).** Running PCA — eigen-decomposition of the covariance $\Sigma = \tfrac1m X_c^\top X_c$, with cumulative variance $\sum_{i\le k}\lambda_i / \sum_i \lambda_i$ — showed that

- $90\%$ of the variance lives in about **86** of the $784$ directions,
- $95\%$ in about **150**, and
- $99\%$ in about **321**.

So the data only *looks* $784$-dimensional; its **intrinsic dimension** is far smaller.

**Interpretation.** The curse is a statement about *uniform* high-dimensional space. Correlations between coordinates (here, neighbouring pixels) confine real data to a low-dimensional surface, and on that surface distances and angles remain meaningful. Finding that surface is exactly what dimensionality reduction does.

---

## 9. How to fight the curse — and the "blessing"

**What the lecture said.** Several remedies: (1) **dimensionality reduction** (PCA, UMAP) that projects to a lower-dimensional space while preserving important relationships; (2) **feature selection** that keeps only the relevant dimensions; (3) algorithms built for high dimensions, e.g. **locality-sensitive hashing** for approximate nearest-neighbour search; (4) **regularisation** to fight the overfitting that high dimensions encourage; (5) simply **more data** to refill the empty space (with practical limits).

The lecture closes with the **blessing of dimensionality**: high dimensions can also help. Data that is not linearly separable in low dimensions may become separable once lifted into a higher-dimensional space. This is why kernels and wide neural-network layers deliberately map inputs into very high-dimensional spaces before classifying.

**Interpretation and link to what we did.** Our MNIST experiment is the constructive version of remedy (1): PCA found that $\sim 86$ directions already capture $90\%$ of the variance, so projecting onto them removes most of the apparent dimensionality at almost no cost. The blessing and the curse are two sides of the same exponent $d$: the same explosion of volume that starves uniform data also gives a lifted representation enough room to pull tangled classes apart.

---

## 10. One-line summary of each result

| effect | formula | what it means |
|---|---|---|
| spiky cube | corner $=\sqrt d$, face $=1$ | corners run away; the cube stops being round |
| thin shell | $1-(1-\varepsilon)^d \to 1$ | almost all volume sits near the surface |
| vanishing sphere | $\dfrac{\pi^{d/2}}{\Gamma(d/2+1)}\big(\tfrac12\big)^d \to 0$ | the inscribed ball fills $\approx 0\%$ of the cube |
| data hunger | $r^{\,d}$ (e.g. $5^d$) | constant density needs exponentially many points |
| orthogonality | $\mathbb{E}[\cos]=0,\ \operatorname{Var}=1/d$ | random directions are almost always perpendicular |
| distance concentration | $\dfrac{d_{\max}-d_{\min}}{d_{\min}} \to 0$ | nearest $\approx$ farthest; "closest" loses meaning |
| real data (MNIST) | intrinsic dim $\ll 784$ | structured data hides on a low-dimensional manifold |

> The curse is about *uniform* high-dimensional space. Real data is not uniform — it lives on a low-dimensional manifold, and finding that manifold is what machine learning is for.
