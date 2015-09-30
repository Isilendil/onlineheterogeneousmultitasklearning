
for iter = 1 : 45

load(sprintf('../../TextImage/data/original/%d', iter));
load(sprintf('../../TextImage/data/similarity/pearson/%d', iter));

n = size(image_fea, 1);
d = size(text_fea, 2);
image_fea_het = zeros(n, d);

K = round(size(co_text_fea, 1) / 10);

for t = 1 : n
	
	cii_T = cii';
	similarity = cii_T(t,:);

  [value, index] = sort(similarity, 'descend');
	index = index(1:K);
	value = value(1:K);
	sim = value / sum(value);

	image_fea_het(t,:) = sim * co_text_fea(index,:);

end


save(sprintf('../../TextImage/data/feature_het/%d', iter), 'image_fea_het');

end
