function [D didx] = create_scaling_matrix(factor, params)
% CREATE_SCALING_MATRIX - Create a diagonal scaling matrix D for the partial
% derivatives w.r.t. the given factor. Avoid the use of spdiags.
%
% D will be an n x n matrix, where n is the number of residuals computed
% in a row update (which depends on sample_factor_weighted.
%
% Arguments:
%
% factor: Matrix (m x k)
% params: Optimization parameters
%
% Return Values:
%
% D: Sparse diagonal matrix.
% didx: Indices of the diagonal of D.

[ignore s] = sample_factor_weighted(factor, ones(1, rows(factor)), params);
D = spdiags(ones(length(s), 1), 0, length(s), length(s));
didx = finddiag(D);

