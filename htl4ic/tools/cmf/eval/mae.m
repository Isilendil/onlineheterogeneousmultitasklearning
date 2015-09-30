function obj = mae(x, xhat)
% MAE - Return the mean absolute error between estimate xhat, and
% truth x.
%
% Arguments:
%
% x: Ground truth (1 x n)
% xhat: Estimate (1 x n)
%
% Return Values:
%
% obj = The mean absolute error of predicting x by xhat.

inds = find(x);
x = x(inds);
xhat = xhat(inds);

check_dims(x, rows(xhat), cols(xhat), 'x');
Res = abs(x - xhat);
obj = sum(Res(:))/numel(Res);
obj = full(obj);

