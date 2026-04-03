/-
# Rank-Nullity Theorem: Formal Skeleton

For any linear map f : V → W between finite-dimensional vector spaces
over a field K:

    rank(f) + nullity(f) = dim(V)

i.e., finrank K (range f) + finrank K (ker f) = finrank K V.

## Mathlib API used

- `LinearMap` (`→ₗ[K]`)           — K-linear maps
- `LinearMap.range`, `LinearMap.ker` — image and kernel as submodules
- `Module.finrank`                 — dimension as a natural number
- `Module.rank`                    — dimension as a cardinal
- `FiniteDimensional`              — alias for `Module.Finite` over a field
- `LinearMap.rank_range_add_rank_ker` — cardinal rank-nullity (Mathlib)
-/

import Mathlib

open LinearMap Module Submodule

namespace RankNullity

/-! ### Setup -/

variable {K : Type*} [Field K]
variable {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
variable {W : Type*} [AddCommGroup W] [Module K W] [FiniteDimensional K W]

/-! ### Cardinal version

The cardinal version requires V and W to live in the same universe
(so that `Module.rank K (range f)` and `Module.rank K (ker f)` are
cardinals in the same universe and can be added).
In Mathlib this is `LinearMap.rank_range_add_rank_ker`. -/

universe u

/-- The rank-nullity theorem (cardinal version):
    rank(range f) + rank(ker f) = rank(V). -/
theorem rank_range_add_rank_ker'
    {V₀ : Type u} [AddCommGroup V₀] [Module K V₀] [FiniteDimensional K V₀]
    {W₀ : Type u} [AddCommGroup W₀] [Module K W₀] [FiniteDimensional K W₀]
    (f : V₀ →ₗ[K] W₀) :
    Module.rank K (LinearMap.range f) + Module.rank K (LinearMap.ker f) =
      Module.rank K V₀ := by
  sorry

/-! ### Finite-dimensional (finrank) version — the main formalization target

The `finrank` version works across universes because `finrank` returns `ℕ`. -/

/-- The rank-nullity theorem (natural-number version):
    finrank(range f) + finrank(ker f) = finrank(V). -/
theorem finrank_range_add_finrank_ker (f : V →ₗ[K] W) :
    finrank K (LinearMap.range f) + finrank K (LinearMap.ker f) =
      finrank K V := by
  sorry

/-! ### Corollaries -/

/-- If f is surjective then finrank(W) + finrank(ker f) = finrank(V). -/
theorem finrank_add_finrank_ker_of_surjective (f : V →ₗ[K] W)
    (hf : Function.Surjective f) :
    finrank K W + finrank K (LinearMap.ker f) = finrank K V := by
  sorry

/-- If f is injective then finrank(range f) = finrank(V). -/
theorem finrank_range_of_injective (f : V →ₗ[K] W)
    (hf : Function.Injective f) :
    finrank K (LinearMap.range f) = finrank K V := by
  sorry

/-- If f is injective and surjective then finrank(V) = finrank(W). -/
theorem finrank_eq_of_bijective (f : V →ₗ[K] W)
    (hf : Function.Bijective f) :
    finrank K V = finrank K W := by
  sorry

/-- The dimension of the kernel is at most the dimension of the domain. -/
theorem finrank_ker_le (f : V →ₗ[K] W) :
    finrank K (LinearMap.ker f) ≤ finrank K V := by
  sorry

/-- The rank of f is at most the dimension of the domain. -/
theorem finrank_range_le (f : V →ₗ[K] W) :
    finrank K (LinearMap.range f) ≤ finrank K V := by
  sorry

end RankNullity
