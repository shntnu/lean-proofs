/-
# Permutation Preserves Variance

Column-wise permutation of a matrix preserves the sum of squared entries
(Frobenius norm squared). This formalizes a key property of the parallel
analysis procedure used in morphological profiling: permuting each column
independently to destroy correlations does not change the total variance.

## Source

"Deconstruct sphering" notebook, Cell 68: column-wise permutation in
parallel analysis to generate the null singular value distribution.

## Mathematical Statement

Given M ∈ ℝᵐˣⁿ and a family of permutations σⱼ : m ≃ m (one per column j),
define M' by M'(i,j) = M(σⱼ(i), j). Then:

  ∑ᵢ ∑ⱼ M'(i,j)² = ∑ᵢ ∑ⱼ M(i,j)²

## Proof sketch

1. Swap summation order: ∑ᵢ ∑ⱼ → ∑ⱼ ∑ᵢ
2. For each fixed j, ∑ᵢ f(σⱼ(i)) = ∑ᵢ f(i) by Equiv.sum_comp
3. Swap back
-/

import Mathlib

open Matrix Finset

namespace PermutationPreservesVariance

variable {R : Type*} [CommRing R]

/-! ### Core lemma: permutation preserves column sum of squares -/

/-- Permuting the entries of a function preserves the sum of squares.
    This is the single-column case: ∑ᵢ f(σ(i))² = ∑ᵢ f(i)². -/
theorem sum_sq_perm_eq {m : Type*} [Fintype m] [DecidableEq m]
    (f : m → R) (σ : Equiv.Perm m) :
    ∑ i, (f (σ i)) ^ 2 = ∑ i, (f i) ^ 2 :=
  Equiv.sum_comp σ (f · ^ 2)

/-! ### Main theorem: column-wise permutation preserves Frobenius norm squared -/

/-- Column-wise permutation preserves the sum of squared entries.
    Given a matrix M and a family of row permutations σ (one per column),
    the permuted matrix M'(i,j) = M(σⱼ(i), j) has the same ∑ᵢⱼ M(i,j)².

    This is the algebraic foundation for parallel analysis: the permutation
    null distribution has the same total variance budget as the original data. -/
theorem frobenius_sq_perm_invariant {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m]
    (M : Matrix m n R) (σ : n → Equiv.Perm m) :
    ∑ i : m, ∑ j : n, (M (σ j i) j) ^ 2 = ∑ i : m, ∑ j : n, (M i j) ^ 2 := by
  calc ∑ i : m, ∑ j : n, (M (σ j i) j) ^ 2
      = ∑ j : n, ∑ i : m, (M (σ j i) j) ^ 2 := Finset.sum_comm
    _ = ∑ j : n, ∑ i : m, (M i j) ^ 2 := by congr 1; ext j; exact sum_sq_perm_eq (M · j) (σ j)
    _ = ∑ i : m, ∑ j : n, (M i j) ^ 2 := Finset.sum_comm

end PermutationPreservesVariance
