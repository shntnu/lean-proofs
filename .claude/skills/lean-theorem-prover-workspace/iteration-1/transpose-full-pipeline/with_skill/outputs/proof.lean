/-
# Transpose of a Matrix Product

Formal verification that the transpose of a matrix product reverses the
order of the factors: (A * B)ᵀ = Bᵀ * Aᵀ.

This is a fundamental identity in linear algebra. Commutativity of the
base ring is essential — the proof reduces to commutativity of the
dot product at each matrix entry.

## Theorems

1. `transpose_mul_via_mathlib` — direct proof using `Matrix.transpose_mul`
2. `transpose_mul_elementwise` — elementwise proof from first principles
-/

import Mathlib

open Matrix Finset

namespace TransposeProduct

variable {R : Type*} [CommRing R]
variable {m n p : Type*} [Fintype m] [Fintype n] [Fintype p]
variable [DecidableEq m] [DecidableEq n] [DecidableEq p]

/-! ### Direct proof via Mathlib -/

/-- The transpose of a matrix product reverses the factors.
    Direct proof using the existing Mathlib lemma `Matrix.transpose_mul`. -/
theorem transpose_mul_via_mathlib (A : Matrix m n R) (B : Matrix n p R) :
    (A * B)ᵀ = Bᵀ * Aᵀ :=
  Matrix.transpose_mul A B

/-! ### Elementwise proof from first principles -/

/-- The transpose of a matrix product reverses the factors.
    Proved elementwise: at each entry (i, j), both sides reduce to
    ∑ k, A j k * B k i, using commutativity of multiplication. -/
theorem transpose_mul_elementwise (A : Matrix m n R) (B : Matrix n p R) :
    (A * B)ᵀ = Bᵀ * Aᵀ := by
  ext i j
  simp only [Matrix.transpose_apply, Matrix.mul_apply]
  exact Finset.sum_congr rfl fun k _ => mul_comm (A j k) (B k i)

end TransposeProduct
