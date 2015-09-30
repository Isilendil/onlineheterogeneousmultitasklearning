function M = log_sparse_matrix(A)
    [m,n] = size(A);
    [i,j,v] = find(A);
    M = sparse(i,j,log(v),m,n);
    