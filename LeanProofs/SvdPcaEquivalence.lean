/-
# SVD–PCA Equivalence

If X = U * S * Vᵀ with U orthogonal (UᵀU = 1), then XᵀX = V * (SᵀS) * Vᵀ.

This is the algebraic core of why PCA can be computed via SVD: the right singular
vectors V diagonalize the covariance matrix XᵀX, and the eigenvalues are the
squared singular values.
-/

import Mathlib

open Matrix

namespace SvdPcaEquivalence

variable {R : Type*} [CommRing R]

/-! ### Core lemma: transpose of a triple product -/

/-- The transpose of a triple matrix product reverses the order and transposes each factor:
    (A * B * C)ᵀ = Cᵀ * Bᵀ * Aᵀ. -/
theorem transpose_triple_mul {m n p : Type*} [Fintype m] [Fintype n] [Fintype p]
    (A : Matrix m p R) (B : Matrix p n R) (C : Matrix n n R) :
    (A * B * C)ᵀ = Cᵀ * Bᵀ * Aᵀ := by
  rw [transpose_mul, transpose_mul, Matrix.mul_assoc]

/-! ### Main theorem: SVD implies diagonalization of XᵀX -/

/-- If X = U * S * Vᵀ and U has orthonormal columns (Uᵀ * U = 1), then
    Xᵀ * X = V * (Sᵀ * S) * Vᵀ. This shows V diagonalizes the covariance matrix XᵀX. -/
theorem svd_pca_equiv {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]
    (U : Matrix m m R) (S : Matrix m n R) (V : Matrix n n R)
    (hU : Uᵀ * U = 1)
    (X : Matrix m n R) (hX : X = U * S * Vᵀ) :
    Xᵀ * X = V * (Sᵀ * S) * Vᵀ := by
  subst hX
  rw [transpose_triple_mul, transpose_transpose]
  simp only [Matrix.mul_assoc]
  rw [← Matrix.mul_assoc Uᵀ U _, hU, Matrix.one_mul]

end SvdPcaEquivalence
