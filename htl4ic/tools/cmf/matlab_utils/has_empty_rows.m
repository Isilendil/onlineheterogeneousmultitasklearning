function value = has_empty_rows(M)
% HAS_EMPTY_ROWS - Return true iff the matrix has an empty row
%
% Arguments:
%
% M: A matrix
%
% Return Values:
%
% value: 0 if no row is empty, else 1.

value = full(any(sum(abs(M), 2) == 0));
