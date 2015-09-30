function invertible = check_covariance(covar, params, factor, i)
% CHECK_COVARIANCE - Check that the covariance is invertible
%
% One way to improve the condition number is to increase
% params.scale, which increases the amount of regularization.
%
% Arguments:
%
% covar: A covariance matrix (k x k)
% params: Optimization parameters (see glmparams)
% factor: String name of the factor covar corresponds to (e.g., 'U')
% i: Row number in the factor (in 1...rows(factor))
%
% Return Values:
%
% invertible: If params.check_condition_number is false, then status = true.
%             Otherwise it is true iff the matrix is safe to invert.

if params.check_condition_number
  if params.use_psd
    invertible = ispsd(covar) && all(all((isfinite(covar))));
  else
    cond = safe_cond(covar);
    condition(i) = cond;
    invertible = all(all(isfinite(cond))) && ...
        cond <= params.ill_conditioned_threshold;
    LogIf(not(invertible) && params.debug && params.debug_cond,...
          'Will cancel update of %s(%d). Condition num = %f\n', factor, i, ...
          cond);
  end
else
  invertible = true;
end


