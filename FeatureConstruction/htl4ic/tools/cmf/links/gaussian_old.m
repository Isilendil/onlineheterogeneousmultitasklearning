% Euclidean loss function, see glm_docpred for usage.

function value = gaussian(X, W, T, f)

mlog2pi = -1.837877;
inds = W>0;
% X = full(X(inds));
% W = full(W(inds));
% T = full(T(inds));
% if issparse(X)
%   X = full(X);
% end
% if issparse(W)
%   W = full(W);
% end
% if issparse(T)
%   T = full(T);
% end

%L = spones(W).*mlog2pi;
L = mlog2pi - 0.5 * (full(X)-full(T)).^2;

%  L = -0.5 * (X-T).^2;
log_likelihood = sum(sum(full(W).*L));
value = -log_likelihood;
