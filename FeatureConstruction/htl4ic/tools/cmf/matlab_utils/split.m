% Split vector in a length k vector (a) and the rest (b)

function [a,b] = split(v,k)

idx = randperm(length(v));
a = v(idx(1:k));
b = v(idx((k+1):end));