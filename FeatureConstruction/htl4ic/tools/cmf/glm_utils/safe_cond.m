function k = safe_cond(M)
% Compute the condition number of a potentially non-finite matrix.
%
% Arguments:
%
% M: The matrix whose condition number we want.
%
% Return Values;
%
% k: If any entry of M is not finite, NaN. Otherwise k = cond(M).

if not(all(all((isfinite(M)))))
  k = NaN;
else
  k = cond(M);
end


