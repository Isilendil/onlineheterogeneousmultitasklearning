%SORT_BY sort a vector the order induced by another vector
%   SORT_BY(a,b) returns a permutation

function res = sort_by(a,b)
    [ignore,idx] = sort(b,'descend');
    res = a(idx);