# Transpose of a Matrix Product: Mathematical Claim

**Claim**: The transpose of a matrix product reverses the order of multiplication. That is, for any matrices $A$ and $B$ of compatible dimensions, $(A \cdot B)^T = B^T \cdot A^T$.

## Setup

| Symbol | Dimensions | Description |
|--------|------------|-------------|
| $A$ | $m \times n$ | Left factor matrix |
| $B$ | $n \times p$ | Right factor matrix |
| $A \cdot B$ | $m \times p$ | Matrix product |
| $(\cdot)^T$ | — | Matrix transpose |

## Statement

**Theorem** (Transpose of a Product). *Let $R$ be a commutative ring. For any matrices $A \in R^{m \times n}$ and $B \in R^{n \times p}$:*

$$(A \cdot B)^T = B^T \cdot A^T$$

## Proof sketch

By definition of matrix multiplication and transpose:

$$((A \cdot B)^T)_{i,j} = (A \cdot B)_{j,i} = \sum_{k=1}^{n} A_{j,k} \cdot B_{k,i}$$

$$(B^T \cdot A^T)_{i,j} = \sum_{k=1}^{n} B^T_{i,k} \cdot A^T_{k,j} = \sum_{k=1}^{n} B_{k,i} \cdot A_{j,k}$$

Since $R$ is commutative, $A_{j,k} \cdot B_{k,i} = B_{k,i} \cdot A_{j,k}$ for all $k$, so the two sums are equal entry-wise. $\square$

## Notes

This is a fundamental identity in linear algebra, used ubiquitously in:
- Least squares derivations
- Adjoint / dual operator theory
- Gradient computations in machine learning (backpropagation)
- The Harmony per-feature independence proof (where transposes of data matrices appear)
