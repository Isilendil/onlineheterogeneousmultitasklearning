function obj = rmse(x, xhat)
inds = find(x);
x = x(inds);
xhat = xhat(inds);

check_dims(x, rows(xhat), cols(xhat), 'x');

Res = (x - xhat).^2;
obj = sum(Res(:))/numel(Res);
obj = full(obj);
obj = sqrt(obj);

