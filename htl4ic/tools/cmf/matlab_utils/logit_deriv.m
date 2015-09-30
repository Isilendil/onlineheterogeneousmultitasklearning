function v = logit_deriv(x)
v = 1./(x .* (1-x));
