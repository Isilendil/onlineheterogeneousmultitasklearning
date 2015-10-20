
load('../../../otl/original/1');

n = size(X_target, 1);

loop = 100;

ID = zeros(loop, n);

for iter = 1 : loop
	ID(iter, :) = randperm(n);
end

m = size(co_X_target, 1);
ID_old = randperm(m);

save('ID_otl', 'ID', 'ID_old');
