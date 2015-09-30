function [smallest value largest] = summary(X, mode)
  x = X(:);
  if strcmpi(mode, 'mean')
    value = mean(x);
  elseif strcmpi(mode, 'median')
    value = median(x);
  else
    error('Utils:InvalidArgument', 'Invalid mode argument (%s)', mode);
  end
  smallest = min(x);
  largest = max(x);
