function [factor s] = sample_factor(factor, params)
% SAMPLE_FACTOR - Given a m x k matrix sample params.stochastic_batch_size rows.
%
% If there are not stochastic_batch_size rows, we use them all.
%
% Arguments:
%
% factor: Matrix (m x k)
%
% Return Values:
%
% factor: Sampled matrix (ns x k)
% s: The indices of the rows chosen (length(s) == ns)

if params.stochastic_opt && params.stochastic_batch_size < rows(factor)
  s = sample(1:rows(factor), params.stochastic_batch_size);
  factor = factor(s,:);
else
  s = 1:rows(factor);
end
