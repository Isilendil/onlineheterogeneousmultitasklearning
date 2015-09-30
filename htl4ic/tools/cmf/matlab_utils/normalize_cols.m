% Normalize so that each column of M is a probability distribution. 
% Will fail if any columns sums to 0

function M = normalize_cols(A)
    n = size(A,2);
    v = 1./sum(A,1)';
    M = A * spdiags(v,0,n,n);
