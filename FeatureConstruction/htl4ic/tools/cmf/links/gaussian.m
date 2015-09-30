% Euclidean loss function, see glm_docpred for usage.

function value = gaussian(X, W, T, f)
% if ~issparse(X) && ~issparse(W) && ~issparse(T)
  mlog2pi = -1.837877;
  L = mlog2pi - 0.5 * (X-T).^2;
  log_likelihood = sum(sum(W.*L));
  value = -log_likelihood;
% else
%   if ~issparse(X)
%     X = sparse(X);
%   end
%   if ~issparse(W)
%     W = sparse(W);
%   end
%   if ~issparse(T)
%     T = sparse(T);
%   end
%   value = gaussian_mex(X,W,T);
% end

