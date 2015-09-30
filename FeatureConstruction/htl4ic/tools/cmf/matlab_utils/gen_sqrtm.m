function D = gen_sqrtm(X)
% Generalized matrix square root, X does not have to be a square matrix.
% Handles sparse or dense matrices.

if (issparse(X))
    [U,S,V] = svds(X);
    D = U*sqrt(S)*V';
else
    [U,S,V] = svd(X);
    D = U*sqrt(S)*V';
end
