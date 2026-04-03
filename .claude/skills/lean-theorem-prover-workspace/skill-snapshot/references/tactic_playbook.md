# Tactic Playbook

Quick reference for Lean 4 / Mathlib tactics, organized by what you're trying to do.
Consult this when stuck — find your goal shape, pick a tactic, adjust.

## Table of Contents

1. [Decomposing Goals](#decomposing-goals)
2. [Rewriting](#rewriting)
3. [Closing Goals](#closing-goals)
4. [Working with Sums and Products](#working-with-sums-and-products)
5. [Working with Matrices](#working-with-matrices)
6. [Hypothesis Management](#hypothesis-management)
7. [Search Tactics](#search-tactics)
8. [Structural Tactics](#structural-tactics)

---

## Decomposing Goals

These tactics break a complex goal into simpler subgoals.

### `ext` / `funext`
**When:** Goal is `f = g` where `f, g` are functions or structures with extensionality.
```lean
-- Goal: colOf (C * Z₁) j = colOf (C * Z₂) j
ext i
-- New goal: colOf (C * Z₁) j i = colOf (C * Z₂) j i
```

### `intro`
**When:** Goal is `∀ x, P x` or `P → Q`.
```lean
-- Goal: ∀ (b : B_plus_1), (C * Z_T₁) b j = (C * Z_T₂) b j
intro b
-- New goal: (C * Z_T₁) b j = (C * Z_T₂) b j
```

### `constructor`
**When:** Goal is `P ∧ Q` or `⟨a, b⟩` (exists with conjunction).
```lean
-- Goal: P ∧ Q
constructor
-- Two subgoals: P and Q
```

### `cases h`
**When:** Hypothesis `h : P ∨ Q` or `h : ∃ x, P x`.
```lean
-- h : P ∨ Q
cases h with
| inl hp => ...  -- hp : P
| inr hq => ...  -- hq : Q
```

### `induction`
**When:** Goal involves a natural number or inductive type.
```lean
induction n with
| zero => ...
| succ n ih => ...  -- ih is the inductive hypothesis
```

---

## Rewriting

### `rw [h]`
**When:** Have `h : a = b`, goal contains `a`, want to replace with `b`.
```lean
-- h : Z₁ k j = Z₂ k j
-- Goal: C i k * Z₁ k j = C i k * Z₂ k j
rw [h]
-- Goal closed (becomes C i k * Z₂ k j = C i k * Z₂ k j)
```

- `rw [← h]` rewrites right-to-left (replace `b` with `a`)
- `rw [h₁, h₂, h₃]` chains multiple rewrites

### `simp only [...]`
**When:** Need to unfold specific definitions or apply specific simp lemmas.
```lean
simp only [colOf, Matrix.mul_apply]
-- Unfolds colOf and Matrix.mul_apply in the goal
```

Prefer `simp only` over bare `simp` — it's faster and predictable.

### `simp`
**When:** Goal should be closable by a combination of many simplification lemmas.
Use sparingly — can be slow and produce surprising results.

### `conv`
**When:** Need to rewrite inside a specific part of the goal.
```lean
conv_lhs => rw [Matrix.mul_apply]  -- rewrite only in left-hand side
```

---

## Closing Goals

### `exact e`
**When:** You have a term `e` whose type is exactly the goal.
```lean
-- Goal: colOf (C * Z₁) j i = colOf (C * Z₂) j i
exact congr_fun (mul_col_eq C Z₁ Z₂ j h) i
```

### `apply f`
**When:** You have `f : A → Goal` and can prove `A` separately.
```lean
-- Goal: ∑ k, f k = ∑ k, g k
apply Finset.sum_congr rfl
-- New goal: ∀ k ∈ Finset.univ, f k = g k
```

### `rfl`
**When:** Goal is `a = a` (definitionally equal terms).

### `ring`
**When:** Goal is an equation in a commutative (semi)ring.
```lean
-- Goal: a * b + b * a = 2 * a * b
ring
```

### `omega`
**When:** Goal is a linear arithmetic statement over `Nat` or `Int`.

### `norm_num`
**When:** Goal involves concrete numerical computations.

### `trivial`
**When:** Goal is obviously true (tries `rfl`, `assumption`, `True.intro`).

---

## Working with Sums and Products

### `Finset.sum_congr`
**When:** Goal is `∑ k in S, f k = ∑ k in S, g k` and you can prove `f k = g k`.
```lean
apply Finset.sum_congr rfl
intro k _
-- Goal: f k = g k
```
This is the workhorse for proving sum equalities. The `rfl` argument proves the
index sets are equal; then you prove each summand is equal.

### `Finset.sum_comm`
**When:** Need to swap summation order: `∑ i, ∑ j, f i j = ∑ j, ∑ i, f i j`.

### `Finset.sum_add_sum_compl`
**When:** Split a sum over a set into a sum over a subset and its complement.

### `mul_sum` / `sum_mul`
**When:** Factor a constant out of a sum: `a * ∑ k, f k = ∑ k, a * f k`.

---

## Working with Matrices

### `Matrix.mul_apply`
The fundamental unfolding: `(A * B) i k = ∑ j, A i j * B j k`.
```lean
simp only [Matrix.mul_apply]
```

### `Matrix.ext_iff` / `Matrix.ext`
**When:** Goal is `A = B` for matrices; reduce to `∀ i j, A i j = B i j`.
```lean
ext i j
-- Goal: A i j = B i j
```

### `Matrix.transpose_apply`
Unfolds `Aᵀ i j = A j i`.

### `Matrix.mul_assoc`
Matrix multiplication is associative: `(A * B) * C = A * (B * C)`.

### `Matrix.one_mul` / `Matrix.mul_one`
Identity matrix: `1 * A = A` and `A * 1 = A`.

---

## Hypothesis Management

### `have`
**When:** Need an intermediate result to break a proof into steps.
```lean
have h_eq : (C * Z_T₁) b j = (C * Z_T₂) b j := by
  exact congr_fun (mul_col_eq C Z_T₁ Z_T₂ j h_same) b
rw [h_eq]
```

### `specialize`
**When:** Want to apply a universal hypothesis to specific arguments.
```lean
-- h : ∀ k, Z₁ k j = Z₂ k j
specialize h k₀
-- h : Z₁ k₀ j = Z₂ k₀ j
```

### `obtain ⟨a, ha⟩ := h`
**When:** Destructure an existential hypothesis.

---

## Search Tactics

Use these when you don't know which lemma to apply.

### `exact?`
Searches the library for a term that closes the current goal.
Very useful but can be slow.

### `apply?`
Like `exact?` but searches for functions that could be applied.

### `simp?`
Runs `simp` and tells you which lemmas it used — lets you
replace `simp` with a `simp only [...]`.

### `rw?`
Searches for rewrite lemmas applicable to the current goal.

---

## Structural Tactics

### `congr` / `congr 1`
**When:** Goal is `f a₁ a₂ = f b₁ b₂`; reduce to proving arguments equal.
```lean
-- Goal: R_k k cell * x = R_k k cell * y
congr 1
-- Goal: x = y
```

### `congr_fun`
**When:** Have `h : f = g`, need `f x = g x`. (This is a term, not a tactic.)
```lean
exact congr_fun h x
```

### `congr_arg`
**When:** Have `h : a = b`, need `f a = f b`. (Term-mode.)
```lean
exact congr_arg f h
```

### `calc`
**When:** Proof is a chain of equalities/inequalities.
```lean
calc x = y := by ...
  _ = z := by ...
  _ = w := by ...
```
