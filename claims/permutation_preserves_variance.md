# Permutation Preserves Variance

## Claim

Column-wise permutation of a matrix preserves the sum of squared entries
(Frobenius norm squared). If each column of a matrix is independently permuted,
the total variance — measured as ∑ᵢⱼ M(i,j)² — is unchanged.

This is the algebraic foundation for parallel analysis: the permutation null
distribution has the same total variance budget as the original data, just
spread differently across singular values.

## Objects

- M ∈ R^{m×n} — data matrix
- σ : n → Perm(m) — a family of permutations, one per column
- M' defined by M'(i,j) = M(σⱼ(i), j) — the column-wise permuted matrix

## Proof sketch

1. Swap summation order: ∑ᵢ ∑ⱼ f(i,j) = ∑ⱼ ∑ᵢ f(i,j)
2. For each fixed column j, ∑ᵢ g(σⱼ(i)) = ∑ᵢ g(i) since σⱼ is a bijection
3. Swap summation order back

## Decomposition

- **Column lemma** (`sum_sq_perm_eq`): for a single column, permutation preserves the sum of squares
- **Main theorem** (`frobenius_sq_perm_invariant`): column-wise permutation preserves the Frobenius norm squared

## Source

"Deconstruct sphering" notebook, Cell 68: column-wise permutation in
parallel analysis to generate the null singular value distribution.
