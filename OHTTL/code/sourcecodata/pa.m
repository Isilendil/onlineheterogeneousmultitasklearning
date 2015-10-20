function w = pa(X, Y, C)

[L, d] = size(X);

w = zeros(d, 1);
%% loop

for t = 1 : L,
    %% prediction
    x_t = X(t,:)';
    f_t=w'*x_t;
    y_t=Y(t);

    if y_t*f_t<=1,
        l_t = 1 - y_t*f_t;
		    tau = min(C, l_t/(x_t'*x_t));
		    w = w + tau * y_t * x_t;
    end

end

