function value = has_empty_cols(M)
% HAS_EMPTY_COLS - Does the matrix have empty columns ?
%
% Arguments:
%
% M: A matrix
%
% Return Values:
%
% value: 1 iff the matrix has a column of zeros, else 0.

value = full(any(sum(abs(M), 1) == 0));
