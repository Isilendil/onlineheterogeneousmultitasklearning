function obj = glmparams(nm, nf, rc_pairs, links)
% GLMPARAMS - Constructor for a @glmparams object.
%
% This class contains all the information about models, optimization
% parameters, and debugging switches for glm* functions.
%
% nm : number of data matrices
% nf : number of factors
%
% 3. As a non-trivial constructor (see init_fields, below)
%
% obj = glmparams('poisson', 'logistic')
% obj2 = glmparams('binomial', 'gaussian', 'Nx', 5)
if nargin < 3
  error('Must specify nm, nf and rc_pairs');
elseif nargin == 3
  warning('No arguments to @glmparams ctor - defaulting to Gaussian links');
  links = repmat({'gaussian'}, 1, nm);
  obj = init_fields(nm, nf, rc_pairs, links);
  return;
else
  obj = init_fields(nm, nf, rc_pairs, links);
end

function params = init_fields(nm, nf, rc_pairs, links)
% INIT_FIELDS -- Define default parameters for glm.m.
%
% Examples:
%
% 1. To generate parameters where the link on X is Poisson and the link on Y
% is logistic:
%
%   params = glmparams('poisson', 'logistic');
%
% 2. To generate parameters where the link on X is Binomial(5,p) and the link
% on Y is gaussian:
%
%   params = glmparams('binomial', 'gaussian', 'Nx', 5);
%
% 3. To generate parmaeters where both links are Binomial, bu the scales
% differ:
%
%   params = glmparams('binomial', 'binomial', 'Nx', 5, 'Ny', 2);
%
% Arguments:
%   xl: Name of the prediction link for the X matrix.
%   yl: Name of the prediction link for the Y matrix.
%   Nx: (if xl == binomial) Scale for the binomial link on X. Default: NaN.
%   Ny: (if yl == binomial) Scale for the binomial link on Y. Default: NaN.
%
% Return Values:
%   params: Optimization and debugging parameters for glm.m

%error(nargchk(2, 6, nargin));

% If false, disable all debugging message regardless of what other
% debug variables are set to.
params.debug = true;

% Show debugging messages for potential problems in glm.m. Conditions
% include the following:
%   debug_deriv: Is the derivative of the link zero ?
%   debug_cond: Is an inverted matrix poorly conditioned ?
%   debug_decrease: Does the objective decrease with each Newton step ?
%   debug_summary_condition_number: Print a summary of the condition
%     numbers for each covariance term in a row update.
%   debug_normchange: Print the mean square changed in the norm.
%   debug_rowstats: Information about rows changed, and stepsize
%     statistics.
%   debug_zeroweights: Report when all the weights in a row/col are zero.
params.debug_deriv = false;
params.debug_cond = false;
params.debug_decrease = false;
params.debug_summary_condition_number = false;
params.debug_normchange = false;
params.debug_rowstats = true;
params.debug_zeroweights = false;

% If true, report "Updating U: Iteration %d" messages. Useful if
% a single per-row update is very expensive.
params.show_iter = false;

% Use an Armijo step size test. This should almost always be
% true. Armijo step sizes are used to test for sufficient decrease in
% the objective. If x_k is the current position, p_k is the step
% direction, and eta a scaling factor in (0,1], the Armijo test checks
% whether the descent in the direction of p_k is enough.
%
%    f(x_k + eta * p_k) - f(x_k) <= c * eta * p_k * f'(x_k)
%
% Note: Think of f( ) as the overall loss wrt each row of a factor
% matrix. If the test fails we set eta = rho * eta.
%
% To start using Armijo checks starting at iteration k >= 1, set
% min_armijo_iter. By default, it should be 0, which corresponds to
% running the test at each iteration.
%
% In theory there is always a value of eta that guarantees sufficient
% decrease, but numerically if the step size is below mineta, we stop
% trying to update the parameters.
%
% Also known as damped Newton-Raphson. Typically eta < 1 only if we are far
% from the local optima.
params.gradient = false; % make this true to invoke gradient descent instead of newton
params.linesearch = true;
params.c = 1e-3;
params.rho = 0.5;
params.min_armijo_iter = -1;
params.mineta = params.rho^5;

% If true, do not use the adjusted dependent variate update, instead
% use the standard newton step \Theta_new = \Theta_old - eta * grad / covar.
params.no_adjusted_dependent_variates = false;

% If true, check the condition number of covariance matrices. If the
% condition number is greater than ill_conditioned_threshold, do not
% update that row. Setting use_psd to true over-rides the condition
% number check with a typicall faster test for positive-definiteness
% (i.e., Cholesky decomposition).
%
% The check condition test is really needed when alpha is extremal.
params.check_condition_number = true;
params.ill_conditioned_threshold = 1e10;
params.use_psd = true;

% Stopping rules. If the change is the overall objective is less than
% obj_threshold (0.01 = 1%), stop. You can also guarantee that at most
% maxiter and at least miniter Newton steps are taken by glm.
params.obj_threshold = 0.0001;
params.maxiter = 10;
params.miniter = 0;

% Given a distributional assumption, choose the matching link and loss.
% Also provide the derivative of the link, for the Newton update.
assert(nf==max(rc_pairs(:)),'rc_pairs inconsistent with nf');
assert(nm==size(rc_pairs,1) && 2==size(rc_pairs,2),'rc_pairs dimensions incorrect, expect %d x %d vs. given %d x %d',...
       nm,2,size(rc_pairs,1),size(rc_pairs,2)); 
params.rc_pairs = rc_pairs;
params.pred_link_descs = cell(1,nm);
params.fs = cell(1,nm);
params.f_primes = cell(1,nm);
params.loss_fs = cell(1,nm);
for i=1:nm
  params.pred_link_descs{i} = links{i};
  % HACK: this won't work for binomial and sgl links
  [params.fs{i} params.f_primes{i} params.loss_fs{i}] = wrap_mk_prediction_link(links{i}, NaN, NaN);
end

% Regularization of factors, Currently only L2 regularization is supported
params.scales = zeros(1,nf);
for i=1:nf
  params.scales(i) = 1;
end

% Embedding dimension
params.k = 10;

% Data matrices weights
params.alphas = ones(1,nm)/nm; % default to equal weights

% Bias term, so that x_{ij} = f(u_{i\cdot}v_{j\cdot}^T + bias_j)
params.add_bias_term = false;

% If true use stochastic gradient or Hessian methods
%
% In stochasic Newton the update is w(t+1) = w(t) - 1/t * inv(H) * grad(f).
% To ensure that the first few steps do not dominate the weight update we
% replace 1/t with 1/max(t, params.min_scaling_factor). This can mitigate
% issues where the first few steps increase the loss by a lot.
params.stochastic_opt = false;
params.stochastic_batch_size = 100;
params.min_scaling_factor = 1;

% Specialized logic for certain weight functions
%
% If inline_standard_weights is true assume that the weight context passed
% to glm contains the fields 'pex', 'pey', 'disx', and 'disy'. Implement the
% following weight function as a special case in the update:
%   w = 1/pex * ((x|x) + disx * (~x));
% Inlining avoids expensive calls to data.m/weight_function in @movie.
%
% Note: On small data sets (e.g., israted_750, israted_250) inlining standard
% weights might have no effect. The speed-up is dramatic on large data sets
% (e.g., israted_2000, israted_10000).
params.inline_standard_weights = false;

% Performance tuning parameters
%
% For small to moderate data sets we can trade memory for speed by converting
% sparse vectors (rows of X, Y) into dense vectors. For larger matrices the
% rows themselves might be so large and sparse then the gain from vector ops
% on dense vectors is counter-acted by the cost of densifiying.
params.densify_rows = false;


function [f f_prime loss_f] = wrap_mk_prediction_link(xl, N, gamma)

if strcmpi(xl, 'binomial')
  [f f_prime loss_f] = mk_prediction_link(xl, N);
elseif strcmpi(xl, 'sgl')
  [f f_prime loss_f] = mk_prediction_link(xl, gamma);
else
  [f f_prime loss_f] = mk_prediction_link(xl);
end
