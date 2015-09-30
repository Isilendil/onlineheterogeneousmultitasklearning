function result = ispsd(X)
% ispsd - Returns true iff the matrix is positive semidefinite
%
% result = ispsd(X)
% Tests whether a dense matrix is positive semidefinite using a Cholesky
% factorization.
%
% Arguments:
%   X: An m x n dense matrix.
%
% Returns
%   result: A boolean that is true iff X is positive semidefinite.

% Author: ajit@cs.cmu.edu (Ajit Singh)

error(nargchk(1, 1, nargin));
assert(not(issparse(X)), 'Does not support sparse matrices yet.');

[R, p] = chol(X);
result = (p == 0);
