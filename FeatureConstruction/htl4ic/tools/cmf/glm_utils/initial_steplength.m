function eta = initial_steplength(params)
% INITIAL_STEPLENGTH - Choose the starting step length for the k^th iteration
%                      for Newton or Stochastic 2nd order gradient descent.
%
% Arguments:
%
% params: Optimization parameters
% k: Iteration number
%
% Return Values:
%
% eta: The initial steplength in (0,1].

if params.stochastic_opt
  eta = 1/max(params.k, params.min_scaling_factor);
elseif params.gradient
  eta = 1/params.k;
else
  eta = 1;
end

