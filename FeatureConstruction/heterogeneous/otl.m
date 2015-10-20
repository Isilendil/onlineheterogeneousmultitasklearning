
for iter = 1 : 4

load(sprintf('../../otl/original/%d', iter));
load(sprintf('../../otl/similarity/cosin/%d', iter));

n = size(X_target, 1);
d = size(X_source, 2);
X_target_het = zeros(n, d);

K = round(size(co_X_source, 1) / 10);

for t = 1 : n
	
	ctt_T = ctt';
	similarity = ctt_T(t,:);

  [value, index] = sort(similarity, 'descend');
	index = index(1:K);
	value = value(1:K);
	sim = value / sum(value);

	X_target_het(t,:) = sim * co_X_source(index,:);

end


save(sprintf('../../otl/feature_het/%d', iter), 'X_target_het');

end
