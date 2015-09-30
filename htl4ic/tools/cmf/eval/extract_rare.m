function [xtest exi exj] = extract_rare(X, nsamples, pred)
% EXTRACT_RARE - Extract test samples from X that match the given
% predicate. Implementation is efficient only if the predicate is
% rarely true.

if nsamples == 0
  xtest = [ ];
  exi = [ ];
  exj = [ ];
  return;
end

idx = find(pred(X));
matches = length(idx);
if matches < nsamples
  error('RFA:InvalidRange', ...
        'Want %d samples, only %d available (pred = %s)', ...
        nsamples, matches, func2str(pred));
end
idx = sample(idx, nsamples);
xtest = X(idx);
[exi exj] = ind2sub(size(X), idx);
xtest = xtest';
exi = exi';
exj = exj';
