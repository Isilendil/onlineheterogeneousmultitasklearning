% Normalize so that each row on M is a probability distribution

function M = normalize_rows(A)
    M = spdiags(1./sum(A,2),0,size(A,1),size(A,1)) * A;
