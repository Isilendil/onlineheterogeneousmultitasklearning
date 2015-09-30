function [f f_prime loss_f] = mk_prediction_link(type,varargin)
% MK_PREDICTION_LINK - Choose the prediction link, and its
% derivative and matching loss, by name.
%
% Arguments:
%
% type: A string indicate the link type ('gaussian', 'poisson', 'logistic')
%
% Return Values
%
% f: Prediction link.
% f_prime: Derivative of the prediction link.
% loss_f: Matching loss for f.

  if strcmpi(type, 'gaussian')
    f = @identity;
    f_prime = @(x)(ones(size(x)));
    loss_f = @gaussian;
  elseif strcmpi(type, 'poisson')
    f = @exp;
    f_prime = @exp;
    loss_f = @poisson;
  elseif strcmpi(type, 'logistic');
    f = @sigmoid;
    f_prime = @(x)(sigmoid(x) .* (1-sigmoid(x)));
    loss_f = @logloss;
  elseif strcmpi(type, 'binomial');
    assert(nargin > 1, ...
           'Call needs a second argument, the size of the binomial');
    n = varargin{1};
    assert(isfinite(n), 'Need finite N');
    f = @(x)(n*sigmoid(x));
    f_prime = @(x)(n * sigmoid(x) .* (1-sigmoid(x)));
    loss_f = @(x,w,t,f)(binomial_loss(n, x, w, t, f));
  elseif strcmpi(type, 'sgl')
    assert(nargin > 1, ...
           'Call needs a second argument, the scale of the SGL link');
    g = varargin{1};
    assert(isfinite(g));
    assert(g > 0);
    WarnIf(g > 50, 'Too sharp. Armijo test will probably cancel updates.');
    margin = 0.0; % margin doesn't seem to work
    f = @(x)(sigmoid(g .* (margin+x)));
    f_prime = @(x)(g .* sigmoid(g .* (margin+x)) .* (1-sigmoid(g .* (margin+x))));
    loss_f = @(x,w,t,f)(sgl_loss(g, margin, x, w, t, f));
  else
    error(sprintf('''%s'' is an invalid prediction link', type));
  end
