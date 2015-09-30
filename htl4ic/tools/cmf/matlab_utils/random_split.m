%RANDOM_SPLIT Partition a vector randomly. k is the size of the first v
%   vector. b contains the rest of the elements.

function [a,b] = random_split(x,k)

n = length(x);
if k > n
    error('Cannot randomly sample %d out of %d elements',k,n);
end
idx = randperm(length(x));
a = x(idx(1:k));
b = x(idx((k+1):end));