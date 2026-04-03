# SVD and PCA Equivalence

## Claim

If a matrix X has a singular value decomposition X = U * S * Vᵀ where U and V are
orthogonal matrices and S is diagonal, then the matrix XᵀX is diagonalized by V.

Concretely: XᵀX = V * (SᵀS) * Vᵀ.

This is the algebraic core of why PCA (which seeks eigenvectors of XᵀX, the covariance
matrix) can be computed via SVD: the right singular vectors V are exactly the principal
components, and the squared singular values (diagonal of SᵀS) are the eigenvalues of XᵀX.

## Objects

- X ∈ R^{m×n} — data matrix
- U ∈ R^{m×m} — left orthogonal factor (UᵀU = I)
- V ∈ R^{n×n} — right orthogonal factor (VᵀV = I)
- S ∈ R^{m×n} — "singular value" matrix (rectangular; not necessarily diagonal in the
  square sense, but treated as a general matrix factor here)

## Core algebraic fact

Given X = U * S * Vᵀ and UᵀU = I:

  XᵀX = (U * S * Vᵀ)ᵀ * (U * S * Vᵀ)
       = V * Sᵀ * Uᵀ * U * S * Vᵀ        (transpose of product)
       = V * Sᵀ * I * S * Vᵀ              (orthogonality of U)
       = V * (Sᵀ * S) * Vᵀ                (simplification)

## Proof sketch

1. Expand Xᵀ using transpose-of-product rules
2. Use associativity to group UᵀU
3. Apply the orthogonality hypothesis UᵀU = 1
4. Simplify the remaining product

## Decomposition

- **Core lemma**: transpose of a triple product (U * S * Vᵀ)ᵀ = V * Sᵀ * Uᵀ
- **Main theorem**: XᵀX = V * (SᵀS) * Vᵀ given the SVD factorization and orthogonality of U
