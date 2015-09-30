
for iter = 1 : 45

	load(sprintf('../../TextImage/data/original/%d', iter));

  [coeff, score, latent, tsquared, explained, mu] = pca(co_image_fea);
	
  for i = 1 : size(image_fea, 2)
	  if sum(explained(1:i)) >= 90
			d = i;
			break;
		end
	end

  feature_pca = image_fea * coeff(:, 1:d);

  save(sprintf('../../TextImage/data/feature_PCA/%d', iter), 'feature_pca');

end
