# Harmony Per-Feature Correction

## Claim

Harmony's batch correction applies independent per-feature corrections. The corrected value of feature $j$ depends only on the original values of feature $j$, not on other features. Cluster assignment uses all features (indirect cross-feature influence), but the correction itself is strictly per-feature.

Concretely: if $W_k = C_k \cdot Z^T$ where $C_k$ does not depend on $Z$, then column $j$ of $W_k$ depends only on feature $j$ of $Z$. The full correction $Z_{\text{corr}}[j,i] = Z[j,i] - \sum_k R_k(i) \cdot W_k[b(i), j]$ inherits this independence.

## Objects

| Symbol | Dimensions | Description |
|--------|------------|-------------|
| $\Phi$ | $(B+1) \times n$ | Batch indicator design matrix (+ intercept) |
| $R_k$ | $n \times 1$ | Soft cluster membership for cluster $k$ |
| $Z$ | $d \times n$ | Data matrix (features $\times$ cells) |
| $\lambda$ | scalar $> 0$ | Ridge penalty |
| $C_k$ | $(B+1) \times n$ | $(\Phi \cdot \text{diag}(R_k) \cdot \Phi^T + \lambda I)^{-1} \cdot \Phi \cdot \text{diag}(R_k)$ — does not depend on $Z$ |

## Proof sketch

1. Factor $W_k = C_k \cdot Z^T$ where $C_k$ is independent of $Z$
2. Matrix multiplication is column-separable: $(C \cdot Z^T)_{i,j} = \sum_k C_{i,k} \cdot Z^T_{k,j}$ depends only on column $j$
3. The full correction is a linear combination of these columns scaled by $R_k(i)$, preserving independence

## Decomposition

- **Column lemma** (`mul_col_eq`): if $Z^T_1$ and $Z^T_2$ agree on column $j$, then $(C \cdot Z^T_1)(\cdot, j) = (C \cdot Z^T_2)(\cdot, j)$
- **Per-feature theorem** (`harmony_per_feature_independence`): pointwise version for a single correction matrix
- **Full correction theorem** (`harmony_correction_independent`): summing over clusters preserves per-feature independence

## Source

Korsunsky, I., Millard, N., Fan, J. et al. Fast, sensitive and accurate integration of single-cell data with Harmony. *Nat Methods* **16**, 1289–1296 (2019). https://doi.org/10.1038/s41592-019-0619-0

See also: [original gist](https://gist.github.com/shntnu/05755e1bda79539a7f491b86d42c59ba), [motivating discussion](https://github.com/broadinstitute/jump_production/issues/17)
