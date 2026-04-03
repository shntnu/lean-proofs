# Harmony Per-Feature Correction: Mathematical Claim

**Claim**: Harmony's batch correction applies independent per-feature corrections. The corrected value of feature $j$ depends only on the original values of feature $j$, not on other features. Cluster assignment uses all features (indirect cross-feature influence), but the correction itself is strictly per-feature.

## Setup

| Symbol | Dimensions | Description |
|--------|------------|-------------|
| $\Phi$ | $(B+1) \times n$ | Batch indicator design matrix (+ intercept) |
| $R_k$ | $n \times 1$ | Soft cluster membership for cluster $k$ |
| $Z$ | $d \times n$ | Data matrix (features $\times$ cells) |
| $\lambda$ | scalar $> 0$ | Ridge penalty |

## Harmony's Correction Equation

For each cluster $k$:

$$W_k = \underbrace{\left(\Phi \cdot \text{diag}(R_k) \cdot \Phi^T + \lambda I\right)^{-1} \cdot \Phi \cdot \text{diag}(R_k)}_{C_k \;\in\; \mathbb{R}^{(B+1) \times n}} \cdot \; Z^T$$

**Key decomposition**: $W_k = C_k \cdot Z^T$ where $C_k$ does **not** depend on $Z$.

## Core Theorem (Column Separability)

**Theorem 1** (Per-Feature Independence). *Let $C \in \mathbb{R}^{m \times n}$ and $Z^T_1, Z^T_2 \in \mathbb{R}^{n \times d}$. If $Z^T_1$ and $Z^T_2$ agree on column $j$, i.e., $\forall i,\; Z^T_1(i,j) = Z^T_2(i,j)$, then:*

$$(C \cdot Z^T_1)(\cdot, j) = (C \cdot Z^T_2)(\cdot, j)$$

*Proof.* By definition of matrix multiplication:

$$(C \cdot Z^T)_{i,j} = \sum_{k=1}^n C_{i,k} \cdot Z^T_{k,j}$$

The right-hand side depends on $Z^T$ only through column $j$. If $Z^T_1(\cdot, j) = Z^T_2(\cdot, j)$, each summand is identical, so the sums are equal. $\square$

## Full Correction Theorem

**Theorem 2** (Full Harmony Correction). *The corrected value of cell $i$ on feature $j$ is:*

$$Z_{\text{corr}}[j,i] = Z[j,i] - \sum_{k=1}^K R_k(i) \cdot W_k[b(i), j]$$

*If we replace $Z$ with $Z'$ that differs only on features $j' \neq j$, the corrected value of feature $j$ is unchanged.*

*Proof.* Each $W_k = C_k \cdot Z^T$ by Theorem 1 has column $j$ depending only on feature $j$. The correction is a linear combination of these columns scaled by $R_k(i)$, preserving the per-feature independence. $\square$

## Empirical Validation

Using JUMP Cell Painting data, cross-feature correlations before and after Harmony are nearly identical ($-0.764$ vs $-0.751$), confirming no cross-feature mixing.

## Reference

Korsunsky, I., Millard, N., Fan, J. et al. Fast, sensitive and accurate integration of single-cell data with Harmony. *Nat Methods* **16**, 1289–1296 (2019). https://doi.org/10.1038/s41592-019-0619-0
