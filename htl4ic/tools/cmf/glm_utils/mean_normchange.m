function change = mean_normchange(U, V)
% NORMCHANGE - Computes the averages L_2 norm between entries of two matrices.

change = mean((U(:) - V(:)).^2);
