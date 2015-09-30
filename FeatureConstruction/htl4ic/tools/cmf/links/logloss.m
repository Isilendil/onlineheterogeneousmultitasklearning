function value = logloss(X,W,AB,f)
% LOGLOSS(X,W,AB,f) - Compute the weighted log-likelihood of the
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


idx = find(W);
x = X(idx);

ab = AB(idx);
t1 = 1./(1+exp(-ab));
t0 = 1-t1;
p = x.*t1+(1-x).*t0;
if any(t1 == 0)
  value = Inf;
  return;
end
w = W(idx);

log_likelihood = sum(w.*log(p));

value = -log_likelihood;
