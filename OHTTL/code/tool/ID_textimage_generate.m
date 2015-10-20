
load('../../../TextImage/data/original/1');

n = size(image_fea, 1);

loop = 100;

ID = zeros(loop, n);

for iter = 1 : loop
	ID(iter, :) = randperm(n);
end

m = size(co_image_fea, 1);
ID_old = randperm(m);

save('ID_textimage', 'ID', 'ID_old');
