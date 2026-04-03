# Transpose of a Matrix Product: Mathematical Claim

**Claim**: The transpose of a matrix product reverses the order of the factors. That is, for any matrices $A$ and $B$ of compatible dimensions, $(A \cdot B)^T = B^T \cdot A^T$.

## Setup

| Symbol | Dimensions | Description |
|--------|------------|-------------|
| $A$ | $m \times n$ | Left matrix factor |
| $B$ | $n \times p$ | Right matrix factor |
| $R$ | — | Base ring (commutative) |

## Statement

**Theorem** (Transpose of Product). *Let $R$ be a commutative ring, and let $A \in R^{m \times n}$, $B \in R^{n \times p}$. Then:*

$$(A \cdot B)^T = B^T \cdot A^T$$

## Proof Sketch

By definition of matrix multiplication and transpose:

$$((A \cdot B)^T)_{i,j} = (A \cdot B)_{j,i} = \sum_{k=1}^{n} A_{j,k} \cdot B_{k,i}$$

Meanwhile:

$$(B^T \cdot A^T)_{i,j} = \sum_{k=1}^{n} B^T_{i,k} \cdot A^T_{k,j} = \sum_{k=1}^{n} B_{k,i} \cdot A_{j,k}$$

Since $R$ is commutative, $A_{j,k} \cdot B_{k,i} = B_{k,i} \cdot A_{j,k}$ for each $k$, so the sums are equal. The identity follows by extensionality (equality at every entry). $\square$

## Notes

- Commutativity of the base ring is essential: the identity fails over non-commutative rings.
- This is a standard result in linear algebra, available in Mathlib as `Matrix.transpose_mul`.
- The proof boils down to commutativity of the dot product (`dotProduct_comm`).
