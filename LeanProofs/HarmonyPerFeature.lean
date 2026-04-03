/-
# Harmony Per-Feature Correction: Formal Proof

Formal verification that Harmony's batch correction algorithm
(Korsunsky et al., Nature Methods 2019) applies independent
per-feature corrections — i.e., the corrected value of feature j
depends only on the original values of feature j, not on other features.

## Mathematical Setup

Given:
- Φ : (B+1) × n  design matrix (batch indicators + intercept)
- R_k : n-vector   soft cluster assignments for cluster k
- Z : d × n        data matrix (features × cells)
- λ > 0            ridge penalty

Harmony computes correction coefficients:
  W_k = (Φ · diag(R_k) · Φᵀ + λI)⁻¹ · Φ · diag(R_k) · Zᵀ

Key decomposition:
  W_k = C_k · Zᵀ   where C_k = (Φ · diag(R_k) · Φᵀ + λI)⁻¹ · Φ · diag(R_k)

Since C_k does not depend on Z, and matrix multiplication is
column-separable — (C · Zᵀ)[:,j] = C · Zᵀ[:,j] — column j of W_k
depends only on feature j.

## Core Theorem

If Zᵀ₁ and Zᵀ₂ agree on column j, then (C · Zᵀ₁)[:,j] = (C · Zᵀ₂)[:,j].

Equivalently: modifying feature j' ≠ j in Z cannot change the
correction applied to feature j.

## Reference

Gist: https://gist.github.com/shntnu/05755e1bda79539a7f491b86d42c59ba
-/

import Mathlib

open Matrix Finset

namespace HarmonyPerFeature

variable {R : Type*} [CommRing R]

/-! ### Column extraction and matrix multiplication -/

/-- Extract column `j` from a matrix as a column vector (function from rows). -/
def colOf {m n : Type*} (A : Matrix m n R) (j : n) : m → R :=
  fun i => A i j

/-- Core lemma: column j of a matrix product depends only on column j
of the right factor. This is the mathematical heart of Harmony's
per-feature independence. -/
theorem mul_col_eq {m n p : Type*} [Fintype n] [DecidableEq n]
    (C : Matrix m n R) (Z₁ Z₂ : Matrix n p R) (j : p)
    (h : ∀ k, Z₁ k j = Z₂ k j) :
    colOf (C * Z₁) j = colOf (C * Z₂) j := by
  sorry

/-- The per-feature independence property stated directly:
if two data matrices agree on feature j (column j of Zᵀ),
then the correction matrices C * Zᵀ agree on column j. -/
theorem harmony_per_feature_independence
    {B_plus_1 n d : Type*} [Fintype n] [DecidableEq n]
    (C : Matrix B_plus_1 n R) (Z_T₁ Z_T₂ : Matrix n d R) (j : d)
    (h_same_feature : ∀ (cell : n), Z_T₁ cell j = Z_T₂ cell j) :
    ∀ (b : B_plus_1), (C * Z_T₁) b j = (C * Z_T₂) b j := by
  sorry

/-! ### Stronger formulation: full correction is per-feature -/

/-- The full Harmony correction for a single cell:
  Z_corr[j,i] = Z[j,i] - ∑_k R_k(i) · W_k[b(i), j]
where W_k = C_k · Zᵀ.

This theorem states that if we replace Z with Z' that differs only
on feature j' ≠ j, the corrected value of feature j is unchanged. -/
theorem harmony_correction_independent
    {B_plus_1 n d K : Type*}
    [Fintype n] [DecidableEq n] [Fintype K]
    (C : K → Matrix B_plus_1 n R)        -- correction operator per cluster
    (R_k : K → n → R)                     -- soft cluster assignments
    (Z_T₁ Z_T₂ : Matrix n d R)           -- two data matrices (cells × features)
    (j : d)                                -- feature of interest
    (h_same : ∀ (cell : n), Z_T₁ cell j = Z_T₂ cell j) -- agree on feature j
    (cell : n) (batch : B_plus_1) :
    -- The corrections ∑_k R_k(cell) · W_k[batch, j] are equal
    (∑ k : K, R_k k cell * (C k * Z_T₁) batch j) =
    (∑ k : K, R_k k cell * (C k * Z_T₂) batch j) := by
  sorry

end HarmonyPerFeature
