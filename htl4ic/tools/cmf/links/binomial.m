function value = binomial(n, X, W, AB, f)

check_samedims(X, AB, 'binomial');
assert(n > 0);

idx = find(W);
x = X(idx);
p = AB(idx);

assert(all(w > 0) & all(isfinite(w)), ...
       'RFA:InvalidArgument', 'Weights cannot be negative or infinite');

ll = gammaln(n+1) - gammaln(x+1) - gammaln(n-x+1) - x.*log(p) - (n-x).*log(1-p);
log_likelihood = sum(w .* ll);
value = -log_likelihood;

if not(isfinite(value))
  value = Inf;
end



