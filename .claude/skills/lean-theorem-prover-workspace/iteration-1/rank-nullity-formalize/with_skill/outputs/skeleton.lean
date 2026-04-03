/-
# Rank-Nullity Theorem

For any linear map f : V → W between finite-dimensional vector spaces
over a field K, the rank of f plus the nullity of f equals the
dimension of the domain:

  rank(f) + nullity(f) = dim(V)

where rank(f) = dim(im(f)) and nullity(f) = dim(ker(f)).

## Approach

The proof uses Mathlib's existing infrastructure:
- `LinearMap.quotKerEquivRange` gives V / ker(f) ≃ₗ[K] range(f)
- `Submodule.finrank_quotient_add_finrank` gives
    finrank(V / N) + finrank(N) = finrank(V)
- Combining these via `LinearEquiv.finrank_eq` yields the result.

We also state a cardinal-rank version and a subtraction form as corollaries.
-/

import Mathlib

open Module LinearMap Submodule

namespace RankNullity

universe u

variable {K : Type*} [DivisionRing K]
variable {V : Type u} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
variable {W : Type u} [AddCommGroup W] [Module K W]

/-! ### Cardinal version -/

/-- **Rank-nullity (cardinal form).**
    For any linear map f between modules over a division ring,
    the cardinal rank of the range plus the cardinal rank of the kernel
    equals the cardinal rank of the domain.
    (This is `LinearMap.rank_range_add_rank_ker` in Mathlib.) -/
theorem rank_range_add_rank_ker (f : V →ₗ[K] W) :
    Module.rank K (LinearMap.range f) + Module.rank K (LinearMap.ker f) =
      Module.rank K V := by
  sorry

/-! ### Finite-dimensional version (finrank) -/

/-- **Rank-nullity (finrank form).**
    For a linear map f : V →ₗ[K] W with V finite-dimensional over a
    division ring K, the natural-number rank (finrank of the range) plus
    the nullity (finrank of the kernel) equals finrank of V. -/
theorem finrank_range_add_finrank_ker (f : V →ₗ[K] W) :
    finrank K (LinearMap.range f) + finrank K (LinearMap.ker f) =
      finrank K V := by
  sorry

/-! ### Subtraction form -/

/-- **Rank equals dimension minus nullity.**
    Equivalent subtraction form of rank-nullity:
    finrank(range f) = finrank(V) - finrank(ker f). -/
theorem finrank_range_eq_finrank_sub_finrank_ker (f : V →ₗ[K] W) :
    finrank K (LinearMap.range f) = finrank K V - finrank K (LinearMap.ker f) := by
  sorry

/-- **Nullity equals dimension minus rank.**
    Equivalent subtraction form of rank-nullity:
    finrank(ker f) = finrank(V) - finrank(range f). -/
theorem finrank_ker_eq_finrank_sub_finrank_range (f : V →ₗ[K] W) :
    finrank K (LinearMap.ker f) = finrank K V - finrank K (LinearMap.range f) := by
  sorry

end RankNullity
