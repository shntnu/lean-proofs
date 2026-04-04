# SVD and PCA Equivalence

## Claim

If a matrix X has a singular value decomposition X = U * S * Vᵀ where U is
orthogonal (UᵀU = I), then XᵀX = V * (SᵀS) * Vᵀ.

This is the algebraic core of why PCA (which seeks eigenvectors of XᵀX, the covariance
matrix) can be computed via SVD: the right singular vectors V are exactly the principal
components, and the squared singular values (diagonal of SᵀS) are the eigenvalues of XᵀX.

## Objects

- X ∈ R^{m×n} — data matrix
- U ∈ R^{m×m} — left orthogonal factor (UᵀU = I)
- V ∈ R^{n×n} — right orthogonal factor (VᵀV = I)
- S ∈ R^{m×n} — singular value matrix

## Proof sketch

1. Expand Xᵀ using transpose-of-product rules
2. Use associativity to group UᵀU
3. Apply the orthogonality hypothesis UᵀU = I
4. Simplify the remaining product

## Decomposition

- **Core lemma** (`transpose_triple_mul`): (A * B * C)ᵀ = Cᵀ * Bᵀ * Aᵀ
- **Main theorem** (`svd_pca_equiv`): XᵀX = V * (SᵀS) * Vᵀ given the SVD factorization and orthogonality of U
