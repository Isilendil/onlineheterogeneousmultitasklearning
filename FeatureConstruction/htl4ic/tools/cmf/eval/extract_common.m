function [xtest exi exj] = extract_common(X, nsamples, pred)
% EXTRACT_COMMON - Extract test samples matching the given predicate,
% assuming the predicate is often true and that nsamples << number of
% times pred(X) is true.

if nsamples == 0
  xtest = [ ];
  exi = [ ];
  exj = [ ];
  return;
end

exi = repmat(NaN, 1, nsamples);
exj = repmat(NaN, 1, nsamples);
current = 1;
avoid = sparse(rows(X), cols(X));
numrows = rows(X);
numcols = cols(X);
while current <= nsamples
  i = ceil(rand * numrows);
  j = ceil(rand * numcols);
  if not(avoid(i,j)) && pred(X(i,j))
    xtest(current) = X(i,j);
    exi(current) = i;
    exj(current) = j;
    current = current + 1;
    avoid(i,j) = 1;
  end
end
