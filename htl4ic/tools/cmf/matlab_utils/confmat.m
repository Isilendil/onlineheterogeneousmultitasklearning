function C = confmat(truth, estimate, values)
% CONFMAT - Create confusion matrix for categorical data
%
% C = confmat(truth, estimate, values)
% Create a k x k confusion matrix, where k is the number of values.
%
% Arguments:
%
% truth: True labels (1 x n vector)
% estimate: Estimated labels (1 x n vector)
%
% Return Values:
%
% C: k x k confusion matrix where C(i,j) is the number of times we estimated
%    values(j) when the true value was values(i).

% Author: Ajit Singh (ajit@cs.cmu.edu)

assert(all(ismember(truth, values)));
assert(all(ismember(estimate, values)));

values = unique(values);

WarnIf(length(values) > 100, 'Very large confusion matrix, %d classes', ...
       length(values));

k = length(values);
C = zeros(k, k);

for i = 1:k
  for j = 1:k
    C(i,j) = sum( truth == values(i) & estimate == values(j) );
  end
end
