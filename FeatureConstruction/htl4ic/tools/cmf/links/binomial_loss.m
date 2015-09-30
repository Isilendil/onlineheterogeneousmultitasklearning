function value = binomial_loss(n, X, W, AB, f)
% BINOMIAL_LOSS(n,X,W,AB,f) - Compute the weighted log-likelihood of the
% data under a binomial distribution.
%
% Arguments:
%
% X: Data (m x n)
% W: Non-negative weights (m x n)
% AB: Natural parameters (m x n)
% f: Prediction link (currently not used)
%
% Return Values:
%
% value: The weighted log-likelihood assuming that x_{ij} ~ Bin(f(AB)_{ij})

check_samedims(X, AB, 'binomial');
assert(n > 0);

idx = find(W);
x = X(idx);
p = sigmoid(AB(idx)); % Mean (after applying prediction link is np, dividing
                      % out n gives us sigmoid(AB(idx)).
w = W(idx);

assert(all(x >= 0 & x <= n & fix(x) == x), 'RFA:InvalidArgument', ...
       'Binomial log-likelihood assume that data is in {0,..%d}', n);
assert(all(w > 0) & all(isfinite(w)), ...
       'RFA:InvalidArgument', 'Weights cannot be negative or infinite');

ll = gammaln(n+1) - gammaln(x+1) - gammaln(n-x+1) + slog(x, p) + slog(n-x, 1-p);
log_likelihood = sum(w .* ll);
value = -log_likelihood;

if not(isfinite(value))
  value = Inf;
end


function value = slog(x,p)
% Like x.*log(p) except 0log(0) = 0
value = x.*log(p);
value(x == 0) = 0;

