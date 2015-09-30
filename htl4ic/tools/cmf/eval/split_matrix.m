function [X_train xtest exi exj wf Exclude Exclude_t] = ...
    split_matrix(X, hold_zeros, hold_nnz, weight_function, weightfunc)
% SPLIT_MATRIX - Split a data matrix into a training matrix and a
% set of test observations, along with a weight function that
% assigns zero weight to the held out entries of X.
%
% Arguments:
%
% X: Matrix to split
% hold_: Number of entries to hold out
% weightfunc: A strictly positive weight function on X.
%
% Return Values:
%
% [See return values of wrapper]


if hold_zeros > numel(X) - nnz(X)
  error('RFA:InvalidRange', ...
        'There are %d zeroes in X, you want %d', numel(X) - nnz(X), ...
        hold_zeros);
end
if hold_nnz > nnz(X)
  error('RFA:InvalidRange', ...
        'There are %d nonzeros in X, you want %d', nnz(X), ...
        hold_nnz);
end

[X_train xtest exi exj] = mk_sparse_splits(X, hold_nnz, hold_zeros);
Exclude = logical(sparse(exi, exj, ones(size(exi)), rows(X), cols(X)));
Exclude_t = Exclude';
wf = @(x,i,j)(weight_function(x, i, j, Exclude, Exclude_t, weightfunc));

