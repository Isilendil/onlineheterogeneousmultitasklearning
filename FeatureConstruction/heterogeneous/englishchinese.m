

load('../../EnglishChinese/data/original/en-ch');
load('../../EnglishChinese/data/similarity/pearson/en-ch');

n = size(CH_fea, 1);
d = size(EN_fea, 2);
CH_fea_het = zeros(n, d);

K = round(size(co_EN_fea, 1) / 10);

for t = 1 : n
	
	ccc_T = ccc';
	similarity = ccc_T(t,:);

  [value, index] = sort(similarity, 'descend');
	index = index(1:K);
	value = value(1:K);
	sim = value / sum(value);

	CH_fea_het(t,:) = sim * co_EN_fea(index,:);

end


save('../../EnglishChinese/data/feature_het/en-ch', 'CH_fea_het');

