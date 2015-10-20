function Y = predict_knn(similarity, Y_train, k)

U = size(similarity, 1);

Y = zeros(U, 1);

for i = 1 : U

  [value, index] = sort(similarity(i,:), 'descend');
	sim = value(1:k) / sum(value(1:k));
  hat = sim * Y_train(index(1:k));
	Y(i) = sign(hat);
  
end


