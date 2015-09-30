
n = 1000;

loop = 100;

ID = zeros(loop, n);

for iter = 1 : loop
	ID(iter,:) = randperm(n);
end

save('../original/ID', 'ID');
