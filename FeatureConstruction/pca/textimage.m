
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

  [coeff, score, latent, tsquared, explained, mu] = pca(co_image_fea(co_id_1600(1:number),:));
	
  for j = 1 : size(image_fea, 2)
	  if sum(explained(1:j)) >= 90
			d = j;
			break;
		end
	end

  feature_pca = image_fea * coeff(:, 1:d);

  save(sprintf('../../TextImage/data/feature_PCA/%d/%d', number, i), 'feature_pca');

end

end
