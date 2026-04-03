# Rank-Nullity Theorem

## Claim

For any linear map f : V -> W between finite-dimensional vector spaces over a
field K, the rank of f plus the nullity of f equals the dimension of the domain:

    rank(f) + nullity(f) = dim(V)

where:
- rank(f)    = dim(range(f))   -- the dimension of the image of f
- nullity(f) = dim(ker(f))     -- the dimension of the kernel of f
- dim(V)     = the dimension of the domain V

## Equivalent formulations

1. **Cardinal version** (no finite-dimensionality required):
   Module.rank K (LinearMap.range f) + Module.rank K (LinearMap.ker f) = Module.rank K V

2. **Natural-number version** (finite-dimensional spaces):
   Module.finrank K (LinearMap.range f) + Module.finrank K (LinearMap.ker f) = Module.finrank K V

3. **Surjectivity corollary**: If f is surjective, then
   dim(W) + nullity(f) = dim(V)

4. **Injectivity corollary**: If f is injective, then
   rank(f) = dim(V)

## Reference

This is a standard result in linear algebra. In Mathlib it is captured by
`LinearMap.rank_range_add_rank_ker` (cardinal version) and related lemmas
in `Mathlib.LinearAlgebra.Dimension.RankNullity`.
