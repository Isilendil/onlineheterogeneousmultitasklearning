% Normalize so that each column of M is a probability distribution.
% Does not die on divide by zero errors.
function M = safe_normalize_cols(A)
    s = sum(A,1)';
    s(find(s==0)) = 1;
    n = size(A,2);
    M = A * spdiags(1./s,0,n,n);
