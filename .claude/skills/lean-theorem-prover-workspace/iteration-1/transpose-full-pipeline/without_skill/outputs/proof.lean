/-
# Transpose of a Matrix Product Reverses the Order

Formal verification that for matrices A and B over a commutative semiring,
  (A * B)ᵀ = Bᵀ * Aᵀ

This is a fundamental identity in linear algebra.
-/

import Mathlib

open Matrix

namespace TransposeProduct

variable {R : Type*} [CommSemiring R]
variable {m n p : Type*}

/-! ### Direct application of Mathlib's lemma -/

/-- The transpose of a matrix product reverses the factor order.
    This version applies Mathlib's `Matrix.transpose_mul` directly. -/
theorem transpose_mul_eq [Fintype n] (A : Matrix m n R) (B : Matrix n p R) :
    (A * B)ᵀ = Bᵀ * Aᵀ :=
  Matrix.transpose_mul A B

/-! ### Element-wise proof from first principles -/

/-- The same result proved element-wise from the definitions of
    matrix multiplication and transpose, without calling `transpose_mul`. -/
theorem transpose_mul_eq_elementwise
    [DecidableEq m] [DecidableEq p] [Fintype m] [Fintype n] [Fintype p]
    (A : Matrix m n R) (B : Matrix n p R) :
    (A * B)ᵀ = Bᵀ * Aᵀ := by
  ext i j
  -- LHS: ((A * B)ᵀ) i j = (A * B) j i = ∑ k, A j k * B k i
  -- RHS: (Bᵀ * Aᵀ) i j = ∑ k, Bᵀ i k * Aᵀ k j = ∑ k, B k i * A j k
  simp only [Matrix.transpose_apply, Matrix.mul_apply]
  -- Now both sides are sums; they differ only by commutativity of (*)
  apply Finset.sum_congr rfl
  intro k _
  ring

/-! ### Corollaries -/

section Corollaries

variable {R : Type*}

/-- Transpose is an involution: (Aᵀ)ᵀ = A -/
theorem transpose_transpose_eq (A : Matrix m n R) :
    Aᵀᵀ = A :=
  Matrix.transpose_transpose A

/-- Transposing preserves the identity: (I)ᵀ = I -/
theorem transpose_one_eq [DecidableEq m] [Zero R] [One R] :
    (1 : Matrix m m R)ᵀ = 1 :=
  Matrix.transpose_one

end Corollaries

/-- Triple product: (A * B * C)ᵀ = Cᵀ * Bᵀ * Aᵀ -/
theorem transpose_triple_mul [Fintype n] [Fintype p] {q : Type*}
    (A : Matrix m n R) (B : Matrix n p R) (C : Matrix p q R) :
    (A * B * C)ᵀ = Cᵀ * Bᵀ * Aᵀ := by
  rw [Matrix.transpose_mul, Matrix.transpose_mul]
  exact (Matrix.mul_assoc Cᵀ Bᵀ Aᵀ).symm

end TransposeProduct
