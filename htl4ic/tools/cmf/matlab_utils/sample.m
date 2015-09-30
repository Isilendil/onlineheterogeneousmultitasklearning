function x = sample(v,k)

idx = randperm(length(v));
x = v(idx(1:k));