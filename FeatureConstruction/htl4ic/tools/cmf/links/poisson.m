function value = poisson(X, W, AB, f)
% GKL - Compute the negative log-likelihood of X under a Poisson distribution.
%
% Implementation Details:
%
% We must accept the case where the loss is infinite, or where the
% log-likelihood is positive. The former can happen when using gkl
% to evaluate the loss on a holdout set; the latter can happen when
% a step is too large (ie, while testing for sufficient decrease).
%
% Arguments:
%
% X: Data matrix (m x n)
% W: Weight matrix (m x n)
% AB: Natural parameters (m x n)
% f: Prediction link. Not currently used.
%
% Return Values:
%
% value: The log-likelihood of the data where x_{ij} ~ Pois((f(AB))_{ij})

if not(all(size(AB) == size(X)))
  error('Parameters do not conform');
end

idx = find(W); % location of nonzero weights
x = X(idx);  % data
a = AB(idx); % natural params
t = exp(a);  % expectation params
w = W(idx);  % weights

if any(x < 0 | fix(x) ~= x)
  error('RFA:InvalidArgument',...
        'Poisson log-likelihood assumes that samples are in {0,1,2}');
end

if any(w < 0) | any(not(isfinite(w)))
  error('RFA:InvalidArgument', 'Weights cannot be negative');
end

% p(x) = \lambda^x*exp(-\lambda) / x!
% log{p(x)} = x ln(\lambda) - \lambda - ln{x!}
% where \lambda = exp(natural param)
log_likelihood = sum(w .* (x.*a - t - gammaln(x+1)));
value = -log_likelihood;

if not(isfinite(value))
% $$$   is_any_non_finite_ab = any(not(isfinite(a)))
% $$$   is_any_non_finite_x = any(not(isfinite(x)))
% $$$   is_any_non_finite_t = any(not(isfinite(t)))
% $$$   is_any_non_finite_gammaln_x = any(not(isfinite(gammaln(x+1))))
% $$$   warning('RFA:InvalidLoss', 'value = %g. %d/%d of the log(t) are invalid',...
% $$$           value, sum(t == 0), length(t));
  value = Inf;
end

% $$$   T = exp(AB);
% $$$   if any(T <= 0)
% $$$     value = Inf;
% $$$     return;
% $$$     %warning('There are %d/%d zero parameters', sum(sum(T == 0)), numel(T));
% $$$     %T(T == 0) = 0.001;
% $$$   end
% $$$   L = X .* log(T) - T - gammaln(X+1);
% $$$   log_likelihood = sum(sum(W .* L));
% $$$   value = -log_likelihood;
% $$$ 
% $$$   if not(isfinite(value))
% $$$     warning('Not finite');
% $$$   end

% $$$   [i, j] = find(X & W);
% $$$   idx = sub2ind(size(X), i, j);
% $$$   x = X(idx);
% $$$   w = W(idx);
% $$$   t = AB(idx);
% $$$   breg = exp(t) - x.*t + x.*log(x) - x;
% $$$   value = sum(w .* breg);
% $$$ 
% $$$   [i, j] = find((X == 0) & W);
% $$$   idx = sub2ind(size(X), i, j);
% $$$   w = W(idx);
% $$$   t = AB(idx);
% $$$   breg = exp(t);
% $$$   value = value + sum(w .* breg);
  
% $$$   Xest = f(AB);
% $$$   [i,j] = find(X & W); idx = sub2ind(size(X),i,j);
% $$$   w = W(idx);
% $$$   value = 0;
% $$$   value = value + sum(w.*(X(idx) .* (log2(X(idx)) - AB(idx)))); % x*log(x/y), y = exp(AB)
% $$$   value = value - sum(sum(W .* (X - Xest))); % This makes it Generalized KL

