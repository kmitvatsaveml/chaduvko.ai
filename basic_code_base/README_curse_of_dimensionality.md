# Curse of Dimensionality — A Gentle Guide to This Notebook

This file is the **concept map** for [the notebook](curse_of_dimensionality.ipynb). Read this before (or beside) running it. The goal is not to memorise every formula. The one idea to hold on to is:

> When we add many features, the possible space grows so quickly that a fixed dataset becomes sparse. Similarity, distance, and coverage can then become unreliable.

That effect is the **curse of dimensionality**.

## 1. First: what does “dimension” mean in machine learning?

A dimension is one number used to describe a data point — one **feature**.

- A person's record with `age`, `height`, and `weight` has 3 dimensions.
- A $28 \times 28$ MNIST image has $28 \times 28 = 784$ pixel values, so it is one point in $\mathbb{R}^{784}$.

The image is still visually two-dimensional to us. But an algorithm sees a list of 784 numbers:

$$
x = [x_1, x_2, \ldots, x_{784}].
$$

So the question is: **what happens when an algorithm tries to compare points described by hundreds or thousands of numbers?**

## 2. The connected story in one picture

```text
more features / dimensions
          |
          v
possible space grows enormously
          |
          +--> fixed dataset covers much less of it
          |        --> need exponentially more examples
          |
          +--> random points look increasingly alike geometrically
                   --> angles near 90 degrees
                   --> nearest and farthest distances get closer
                   --> distance-based methods can struggle

But real data is structured, not random everywhere.
          |
          v
it often lies near a much lower-dimensional surface
          |
          v
PCA / feature selection / regularisation can help.
```

The notebook first proves the problem using idealised random geometry, then tests whether the same problem appears for real digit images.

## 3. The main idea: sparse data

Imagine placing samples evenly along each feature.

If we want 5 possible positions along one axis:

$$
5^1 = 5
$$

points are enough in 1D. In two dimensions, we need:

$$
5^2 = 25.
$$

In ten dimensions, we need:

$$
5^{10} = 9{,}765{,}625.
$$

The number is multiplied by 5 every time we add one dimension. This is called **exponential growth**.

### Interpretation

With a fixed number of training examples, adding features does not make the data denser. It makes the available examples farther apart and leaves enormous regions with no examples at all. A model then has less evidence about what should happen in those unseen regions.

This is the most important practical meaning of the curse.

## 4. Notebook walkthrough: what every section is trying to show

| Notebook section | Simple claim | Why it matters |
|---|---|---|
| **1. Nine points** | The same 9 samples cover a line reasonably, a square poorly, and a cube barely at all. | A fixed dataset becomes sparse as dimensions increase. |
| **2. Spiky cube** | In a $d$-cube, centre-to-corner distance is $\sqrt{d}$, while centre-to-face distance stays 1. | Our 2D/3D intuition about shapes stops working. |
| **3. Thin shell** | Most of a high-dimensional ball's volume is near its boundary. | A “typical” point is not in the intuitive middle. |
| **4. Ball inside cube** | The largest ball inside a cube occupies almost none of the cube in high $d$. | Most cube volume is in corner-like regions, far from the centre. |
| **5. $5^d$** | Keeping the same sampling resolution needs exponentially more samples. | This is the data-hunger version of the curse. |
| **6. Orthogonality** | Random high-dimensional directions are almost perpendicular. | Cosine similarity loses variety for uniformly random data. |
| **7. Distance concentration** | The nearest and farthest random points become relatively similar in distance. | “Nearest” can stop being meaningfully special. |
| **8–9. MNIST** | Real images behave differently from random vectors. | Real data has structure and correlations. |
| **10. PCA** | Many pixel directions contribute little variation. | The apparent 784 dimensions are not all equally important. |

The first five sections are mainly geometric intuition. Sections **6, 7, 9, and 10** are the closest link to machine learning practice.

## 5. The three ideas that usually feel confusing

### A. “Almost orthogonal” does not mean the data is useless

For two random unit vectors $u$ and $v$, their cosine similarity is

$$
\cos(\theta)=u^T v.
$$

In high dimensions, random vectors tend to have

$$
\cos(\theta) \approx 0,
$$

which means an angle near $90^\circ$: they are nearly perpendicular.

The notebook confirms that the variation of cosine similarity shrinks approximately like $1/d$.

**Interpretation:** if every pair has cosine near zero, cosine has little power to distinguish one random vector from another.

**Important exception:** real MNIST digits are not random vectors. They share structure — for example, ink tends to occur near the image centre. Therefore their cosine similarities are not concentrated near zero in the same way.

### B. “Nearest is almost as far as farthest” is about *relative* distance

The notebook measures:

$$
\text{relative contrast}
= \frac{d_{\max}-d_{\min}}{d_{\min}}.
$$

If this is close to zero, then the closest and farthest stored points are nearly the same distance away **relative to their size**.

For example:

- nearest distance = 100
- farthest distance = 101

The raw difference is 1, but the relative contrast is only $1/100=0.01$. Calling one point “near” and one “far” is not very informative.

This is why methods such as k-nearest neighbours, radius search, and distance-based clustering may suffer on truly unstructured high-dimensional data.

### C. “784 dimensions” does not mean MNIST fills all of $\mathbb{R}^{784}$

A random 784-number vector usually looks like static, not a handwritten digit. Valid digit images obey many hidden constraints:

- neighbouring pixels are correlated;
- digits are centred and have strokes;
- only certain shapes are plausible;
- changes such as thickness, slant, and position are related.

So MNIST occupies a tiny, structured subset of the full 784-dimensional space. This is the key reason real data often escapes the worst version of the curse.

## 6. How to read the MNIST part of the notebook

### Random vectors vs MNIST cosine histogram

The notebook makes two groups:

1. random vectors with the same number of dimensions as MNIST;
2. actual MNIST image vectors.

Read the histogram like this:

- Random-vector cosine values should form a narrow bump around 0: almost orthogonal.
- MNIST cosine values should be shifted away from 0 and have meaningful spread: digit images share pixel structure.

**Conclusion:** “high-dimensional” alone is not the full story. The distribution of the data matters.

### Relative-contrast bar chart

The notebook compares random points and MNIST points.

- A **small** bar means nearest and farthest are hard to distinguish.
- A **larger** MNIST bar means there is still usable separation between similar and dissimilar digits.

**Conclusion:** Euclidean distance is not automatically meaningless just because the feature vector has 784 entries.

### PCA cumulative-variance plot

PCA finds new axes ordered by how much variation in the dataset each axis explains.

- The horizontal axis is the number of retained PCA directions.
- The vertical axis is the fraction of variation retained.
- If the curve rises quickly, a smaller number of directions captures much of the dataset's structure.

For example, “90% variance at $k=86$” means 86 PCA directions retain 90% of the variation in these 784-pixel images.

It does **not** mean that the formal intrinsic dimension is exactly 86. It means 86 is a useful *linear compression size* for preserving 90% of this dataset's variance.

## 7. Why the notebook shows cubes, balls, and shells

These are not separate facts to memorise. They are different symptoms of one cause: when $d$ appears in an exponent or in a sum of many coordinate contributions, the behaviour can change dramatically.

| Geometry example | What it teaches for ML |
|---|---|
| Corners move out as $\sqrt{d}$ | Distances and “shape” are unlike low-dimensional intuition. |
| Volume moves into a shell | Typical points can live in unexpected regions. |
| Ball becomes tiny inside a cube | A compact central region may represent very little of possible feature space. |
| Grid needs $r^d$ samples | Training data cannot uniformly cover a large feature space. |
| Distances concentrate | Similarity-based algorithms need carefully chosen features or metrics. |

## 8. What we do about the curse in real ML

We usually do **not** try to fill the entire high-dimensional space. We exploit the structure in the data.

- **Feature selection:** keep genuinely useful features and remove noise/redundancy.
- **PCA:** replace many correlated features with fewer informative directions.
- **Regularisation:** discourage a model from fitting accidental quirks in sparse data.
- **Better representations:** use embeddings or learned features where similar items are meaningfully close.
- **More data:** helpful when the extra data actually covers meaningful variation.
- **Approximate neighbour search:** useful when exact distance search is too costly or unstable.

## 9. Curse versus blessing of dimensionality

High dimension is not automatically bad.

- **Curse:** random/unstructured space is huge, sparse, and has weak distance contrast.
- **Blessing:** extra dimensions can give different classes enough room to separate.

For instance, a curved boundary that is difficult to separate in 2D may become linearly separable after a nonlinear feature transformation into a richer space. Kernels and neural networks use this idea deliberately.

The practical goal is not “always reduce dimensions.” It is:

> Keep or create dimensions that represent useful structure; remove dimensions that are mostly noise, redundancy, or irrelevant variation.

## 10. Final memory version

If you remember only four sentences, remember these:

1. A dimension is a feature; an MNIST image has 784 pixel features.
2. With many dimensions, a fixed dataset is sparse because covering space needs exponentially many examples.
3. For uniformly random high-dimensional points, angles and distances lose contrast, so “similar” becomes harder to define.
4. Real data is structured rather than uniform; PCA and good representations find that structure, which is why high-dimensional machine learning can still work.

## Suggested reading order

1. Read Sections 1–3 of this guide.
2. Run notebook Sections 1, 5, 6, and 7. Focus on the plot titles and the interpretation above, not every formula.
3. Run the MNIST Sections 8–10.
4. Return to the cube, shell, and ball sections only when you want the geometric proof behind the intuition.

The longer, formula-first companion is available in [curse_of_dimensionality_notes.md](curse_of_dimensionality_notes.md).
