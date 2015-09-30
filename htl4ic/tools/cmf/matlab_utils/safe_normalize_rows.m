% Normalize so that each row on M is a probability distribution
% If a row is all zeros this function does not return divide by zero error
function M = safe_normalize_rows(A)
    s = sum(A,2);
    s(find(s==0)) = 1; 
    M = diag(1./s) * A;
