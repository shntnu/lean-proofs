# Rank-Nullity Theorem

## Claim

For any linear map $f : V \to W$ between finite-dimensional vector spaces over a field $K$,
the rank of $f$ plus the nullity of $f$ equals the dimension of the domain:

$$\operatorname{rank}(f) + \operatorname{nullity}(f) = \dim(V)$$

where:
- $\operatorname{rank}(f) = \dim(\operatorname{im}(f))$ is the dimension of the image (range) of $f$,
- $\operatorname{nullity}(f) = \dim(\ker(f))$ is the dimension of the kernel (null space) of $f$,
- $\dim(V)$ is the dimension of the domain $V$.

## Objects

- $K$: a field (or more generally, a division ring)
- $V, W$: finite-dimensional vector spaces (modules) over $K$
- $f : V \to W$: a $K$-linear map
- $\ker(f)$: the kernel of $f$, i.e., $\{v \in V \mid f(v) = 0\}$
- $\operatorname{im}(f)$: the image (range) of $f$, i.e., $\{f(v) \mid v \in V\}$

## Properties

- Equality: $\operatorname{rank}(f) + \operatorname{nullity}(f) = \dim(V)$
- This is a fundamental theorem of linear algebra

## Proof sketch

The first isomorphism theorem gives $V / \ker(f) \cong \operatorname{im}(f)$.
Since dimensions are additive in short exact sequences (or equivalently,
$\dim(V / \ker(f)) + \dim(\ker(f)) = \dim(V)$ by the dimension formula for quotients),
we get $\dim(\operatorname{im}(f)) + \dim(\ker(f)) = \dim(V)$.

## Decomposition

1. **Core fact (cardinal rank):** For any linear map $f : V \to W$ over a ring with
   `HasRankNullity`, $\operatorname{rank}(f.\text{range}) + \operatorname{rank}(\ker(f)) = \operatorname{rank}(V)$
   as cardinals. (This is `LinearMap.rank_range_add_rank_ker` in Mathlib.)

2. **Finite-dimensional version (finrank):** When $V$ is finite-dimensional, the natural
   number version: $\operatorname{finrank}(\operatorname{im}(f)) + \operatorname{finrank}(\ker(f)) = \operatorname{finrank}(V)$.

3. **Alternative formulation (subtraction):**
   $\operatorname{rank}(f) = \dim(V) - \operatorname{nullity}(f)$.
