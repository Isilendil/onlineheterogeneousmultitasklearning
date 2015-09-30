function value = density(M)
% DENSITY - Return the fraction of nonzero elements in a matrix.
%
% Arguments:
%
% M: A matrix (not necessarily a sparse matrix).
%
% Return Values:
%
% value: The fraction of nonzero elements in M.

value = nnz(M) / numel(M);
