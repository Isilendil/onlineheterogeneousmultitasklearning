
load('../co_id');

for iter = 1 : 6 % [200 400 600 800 1000 1600]

	switch iter
		case 1
		  number = 200;
		case 2
		  number = 400;
		case 3
		  number = 600;
		case 4
		  number = 800;
		case 5
		  number = 1000;
		case 6
		  number = 1600;
	end

for i = 1 : 45

load(sprintf('../../TextImage/data/original/%d', i));
load(sprintf('../../TextImage/data/similarity/pearson/%d', i));

n = size(image_fea, 1);
d = size(text_fea, 2);
image_fea_het = zeros(n, d);

%K = round(size(co_text_fea, 1) / 10);
K = round(number / 10);

for t = 1 : n
	
	cii_T = cii';
	similarity = cii_T(t,co_id_1600(1:number));

  [value, index] = sort(similarity, 'descend');
	index = index(1:K);
	value = value(1:K);
	sim = value / sum(value);

	image_fea_het(t,:) = sim * co_text_fea(co_id_1600(index),:);

end


save(sprintf('../../TextImage/data/feature_het/%d/%d', number, i), 'image_fea_het');

end

end
