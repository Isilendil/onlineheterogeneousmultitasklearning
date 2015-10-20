
load('../../../EnglishChinese/data/original/en-ch');

n = size(CH_fea, 1);

loop = 100;

ID = zeros(loop, n);

for iter = 1 : loop
	ID(iter, :) = randperm(n);
end

m = size(co_CH_fea, 1);
ID_old = randperm(m);

save('ID_ench', 'ID', 'ID_old');
