function [factor s] = sample_factor_weighted(factor, weights, params)

%check_length(weights, rows(factor));
if params.stochastic_opt && params.stochastic_batch_size < rows(factor)
  nzw = nnz(weights);
  if nzw > 0
    bs = min(params.stochastic_batch_size, nzw);
    %s = weighted_sample(1:rows(factor), weights, bs, false);
    s = wieght_sample(1:rows(factor), weights, bs);
    factor = factor(s,:);
  else
    % If all the weights are zero then just pick some points uniformly
    % at random. It doesn't really matter what we do here since all the
    % weights are zero.
    [factor s] = sample_factor(factor, params);
  end
else
  s = 1:rows(factor);
  s = s(weights ~= 0);
  factor = factor(s,:);
end

