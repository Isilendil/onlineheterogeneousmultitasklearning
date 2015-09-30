function H_damped = estimate_stochastic_hessian(H_new, H_old, iter)
% ESTIMATE_STOCHASTIC_HESSIAN - Compute the exponentially weighted moving
%                               average of the Hessian
%
% Arguments:
%
% H_new: The instantaneous Hessian at the current iteration
% H_old: The EWMA Hessian from the previous iteration.
% iter: Iteration number (1..Inf)
%
% Return Values:
%
% H_damped: The EWMA Hessian for the given iteration.

assert(iter >= 1);
assert(not(isempty(H_new)));
if isempty(H_old) && iter == 1
  H_old = eye(size(H_new));
elseif isempty(H_old) && iter > 1
  error('Passing empty H_old after the first iteration');
end
rate = 2 / (iter + 1);
H_damped = (1 - rate) .* H_old + rate .* H_new;


