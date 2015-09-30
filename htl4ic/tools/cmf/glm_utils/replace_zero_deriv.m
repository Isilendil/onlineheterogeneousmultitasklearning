function [deriv, zeroderiv] = replace_zero_deriv(deriv, err, msg, params)
% Replace all zero derivatives with a non-zero value.
%
% Arguments:
%
% deriv: Vector of derivatives
% err: Vectors of residual errors
% msg: Prefix of a debugging message recording the number of zero derivatives.
% params: Optimization parameters (only debugging parameters are
% used).
%
% Return Values:
%
% deriv: Vector of derivatives, with no zero entries.
% zeroderiv: Boolean indicating whether or not any entries were replaced.

zeroderiv = (deriv == 0 & err ~= 0);
if any(zeroderiv)
  LogIf(params.debug && params.debug_deriv,...
        '%s: There are %d zero derivatives with nz err\n', msg, sum(zeroderiv));
end
deriv(deriv == 0) = 1;

