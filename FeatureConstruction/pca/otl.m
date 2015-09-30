
fprintf(1, 'Too dangerous! \n');

%{
for iter = 1 : 4

	load(sprintf('../../otl/original/%d', iter));

  [coeff, score, latent, tsquared, explained, mu] = pca(co_X_target);
	
  for i = 1 : size(X_target, 2)
	  if sum(explained(1:i)) >= 90
			d = i;
			break;
		end
	end

  feature_pca = X_target * coeff(:, 1:d);

  save(sprintf('../../otl/feature_PCA/%d', iter), 'feature_pca');

end
%}
