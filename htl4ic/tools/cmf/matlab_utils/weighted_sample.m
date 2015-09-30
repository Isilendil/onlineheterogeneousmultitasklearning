function samples = weighted_sample(vector, prob, nsamples, replace)
% weighted_sample -- Generate a sample, without replacement, of vector where
%                    the probability of sampling vector(i) is prob(i).
%
% samples = weighted_sample(vector, prob, nsamples)
% Sample the elements of vector, without replacement, using the weights
% given by prob.
%
% Arguments:
%
% vector: Elements to sample.
% prob: Nonnegative sampling weights.
% nsamples: Number of samples to generate.
% replace: If true, sample with replacement.
%
% Return Values:
%
% samples: nsamples random samples from vector.

  if nargin < 4
    replace = false;
  end

  vector = vector(:);
  prob = prob(:);
  if length(vector) ~= length(prob)
    error('MatlabUtils:InvalidArgument',...
          'vector and prob are different sizes (%d vs. %d)',...
          length(vector), length(prob));
  end
  if length(vector) < nsamples && not(replace)
    error('MatlabUtils:InvalidArgument',...
          'Want %d samples, only have %d elements',...
          nsamples, length(vector));
  end
  if nsamples < 0
    error('MatlabUtils:InvalidArgument',...
          'nsamples must be non-negative (is %d)', nsamples);
  end

  if nsamples == 0
    samples = [ ];
    return;
  end

  if nnz(prob) == 0
    warning('All the sampling weights are zero, so no samples generated');
    samples = [ ];
    return;
  end

  prob = FixProb(prob);
  idx = ProbSample(length(vector), prob, nsamples, replace);
  samples = reshape(vector(idx), 1, length(idx));

function p = FixProb(prob)

  if any(prob < 0)
    first_loc = find(prob < 0, 1);
    error('MatlabUtils:InvalidArgument',...
          'prob contains negative values. First loc prob(%d) = %e\n',...
          first_loc, prob(first_loc));
  end
  if sum(prob) == 0
    error('MatlabUtils:InvalidArgument', 'Weights are all zeros');
  end
  p = prob ./ sum(prob);

function samples = ProbSample(n, prob, nsamples, replace)
% Sample the integers 1:n using the given probability distribution.
%
% samples = ProbSample(n, prob, samples)
% Sample the integers 1:n given the distribution, with or without
% replacement. The running time is O(nlogn + nsamples * n). If
% nsamples << n and replace = false, then the expected running time is
% O(nlogn + nsamples * ceil(log(n))).
%
% Arguments:
%
% n: Number of integers to sample
% prob: Probability distribution over 1...n
% nsamples: Number of elements to samples.
% replace: If true, sample with replacement.
%
% Return Values:
%
% samples: Unique samples from 1:n.

  if n < nsamples && not(replace)
    error('MatlabUtils:InvalidArgument',...
          'Want %d samples, only have %d elements to select',...
          nsamples, n);
  end
  if n ~= length(prob)
    error('MatlabUtils:InvalidArgument',...
          'n ~= length(prob) (%d vs. %d)', n, length(prob));
  end

  perm = 1:n;
  [prob, idx] = sort(prob, 'descend');
  perm = perm(idx);
  prob = prob';
  samples = repmat(NaN, 1, nsamples);
  zeroidx = find(~prob);
  prob(zeroidx) = [ ];
  perm(zeroidx) = [ ];

  if length(prob) < nsamples && not(replace)
    error('MatlabUtils:InvalidArgument',...
          'There are fewer non-zero prob than required (%d vs. %d)',...
          length(prob), nsamples);
  end

  samples = ProbSample_no_binary_search(prob, perm, samples, replace);
  % seems broken
  %samples = ProbSample_use_binary_search(prob, perm, samples, replace);

function samples = ProbSample_no_binary_search(prob, perm, samples, replace)

large_threshold = 90;

totalmass = 1;
cs = full(cumsum(prob));
nprob = length(cs);
if nprob <= large_threshold
  % One large block containing all the elements
  skipidx = [1 nprob];
  skips = [0 cs(end)];
else
  % Search blocks of size ceil(log(n))
  assert(nprob > 1);
  skipidx = [1 1:round(nprob/ceil(log(nprob))):nprob nprob];
  skips = [0 cs(skipidx(2:end)) cs(end)];
end
for i = 1:length(samples)
  rT = totalmass * rand(1);
  lidx = find(skips < rT, 1, 'last');
  uidx = find(skips >= rT, 1, 'first');
  lower = skipidx(lidx);
  upper = skipidx(uidx);
% $$$   lower
% $$$   upper
  while true
    % In practice it is faster to compare ceil(log(n)) elements in a
    % vectorized operation than it is to expand the operation into a
    % loop. This is the most expensive step.
    %
    % TODO(ajit): It would be faster to maintain cs as a sorted list,
    % removing entries instead of inserting -1, and using binary search
    % to find the right j. Need to find a matlab function that does binary
    % search efficiently. The other potential downside is cs(i) = [ ]
    % (to remove an entry from the vector) is rather slow.
    j = (lower - 1) + find(cs(lower:upper) >= rT, 1, 'first');

    % Since the search excludes elements that have already been
    % selected, there is no guarantee that the right j exists in
    % the current block cs(lower:upper). Check the next block.
    if isempty(j)
      lidx = uidx;
      uidx = uidx + 1;
      lower = skipidx(lidx);
      upper = skipidx(uidx);
    else
      break;
    end
  end
  samples(i) = perm(j);
  if not(replace)
    totalmass = totalmass - prob(j);
    cs(j) = -1;
  end
end

function samples = ProbSample_use_binary_search(prob, perm, samples, replace)

% TODO(ajit): Determine if it is buggy on sparse vectors.

totalmass = 1;
cs = cumsum(prob); % always sorted
for i = 1:length(samples)
  rT = totalmass * rand(1);
  j = bin_sear(cs, rT);
  if j > 1 && cs(j-1) >= rT
    j = j - 1;
  elseif j < length(cs) && cs(j+1) >= rT
    j = j + 1;
  end
  assert(cs(j) >= rT, 'bin_search failed, or was misused');
  samples(i) = perm(j);
  if not(replace)
    totalmass = totalmass - prob(j);
    cs(j) = [ ];
  end
end

function samples = ProbSample_weighted_no_replacement(n, prob, nsamples)

% Not tested. May have issues with zero probability events.

s = [1 nsamples];
m = length(prob);
c = cumsum(prob);
R = rand(s);
X = ones(s);
for i = 1:m-1
  X = X + (R > c(i));
end
samples = X;
