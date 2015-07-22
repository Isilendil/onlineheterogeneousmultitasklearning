function [U, V_1, V_2] = MF(C_1, C_2, num_fea)

  lambda_1 = 0.5;
	lambda_2 = 0.5;

	gamma_1 = 1;
	gamma_2 = 1;
	gamma_3 = 1;
  eta = 1;

	n = size(C_1, 1);
  d_1 = size(C_1, 2);
  d_2 = size(C_2, 2);

  U = rand(n, num_fea);
  V_1 = rand(d_1, num_fea);
	V_2 = rand(d_2, num_fea);

  U_ = zeros(size(U));
	V_1_ = zeros(size(V_1));
	V_2_ = zeros(size(V_2));

	while (norm(U-U_)>eps) && (norm(V_1-V_1_)>eps) && (norm(V_2-V_2_)>eps)
		U_ = U;
		V_1_ = V_1;
		V_2_ = V_2;

    U = U - eta * ( lambda_1 * (-C_1*V_1 + U*V_1'*V_1) + lambda_2 * (-C_2*V_2 + U*V_2'*V_2) + gamma_1/2*U); 
		V_1 = V_1 - eta * (lambda_1 * (-U'*C_1 + U'*U*V_1')' + gamma_2/2*V_1);
		V_2 = V_2 - eta * (lambda_2 * (-U'*C_2 + U'*U*V_2')' + gamma_3/2*V_2);
	end
