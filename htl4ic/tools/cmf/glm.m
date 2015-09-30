function [Vs obj debug] = glm(Xs, Ws, params, varargin)
% function [Vs obj debug] = glm(Xs, Ws, params, varargin)
% GLM - Factors three matrices X = UV', Y = VZ' and Q=VR' where the V factors is shared.
%
% [model obj debug] = glm(X, Wx, wx_con, Y, Wy, wy_con, params, split, varargin)
% Given two matrices X (m x n) and Y (n x r) this algorithms factors them
% into X = UV' and Y = VZ' where error between the matrices and their
% reconstructions are Bregman divergences.
%
% Arguments:
%
% Xs: Data matrices 
% Ws: Weight matrices
% dims: dimensions of each factor
% rc_pairs: factor ids for row and column of each data matrix
%
% params: Optimization and model parameters. Instance of @glmparams.
%
% Optional Arguments:
%
% mock: Mock the parameter updates, return random parameters. [default: false]
% mock_loss: Mock the reconstruction error. [default: false]
% init_model: Used the given @model3f as starting parameters. [default: none]
%
% Return Values:
%
% model: The learned model. Instance of @model3f.
% obj: The training error after each update. The first value is the training
%      error using random parameters (or init_model).
% debug: Anything that peers into the internals of the optimization. Right
%        now the only fields are 'cputime', the time taken to finish the first
%        k iterations; and 'model', a vector of models generated at each
%        iteration

% Author: ajit@cs.cmu.edu (Ajit Singh)

error(nargchk(3, Inf, nargin));


% HACK: If X is sparse then accessing rows is very expensive (column-major
% storage is used). This can add > 30% to the cost of each iteration for
% large data sets. Where we need a row of X, X(i,:), it can be replaced by
% a column of Xt, Xt(:,i)'. Likewise for Y.
Xts = cell(length(Xs));
Wts = cell(length(Ws));
for i=1:length(Xs)
  Xts{i} = Xs{i}';
  Wts{i} = Ws{i}';
end

% HACK: Field references for objects (subsref) are much slower than field
% references for structures. To avoid subsref being the dominant cost in
% many utility functions, such as sample_factor, cast @glmparams -> struct.
dims = zeros(1, max(params.rc_pairs(:)));
for i=1:length(Xs)
  [m,n] = size(Xs{i});
  if dims(params.rc_pairs(i,1)) == 0
    dims(params.rc_pairs(i,1)) = m;
  else
    assert(dims(params.rc_pairs(i,1))==m, 'Incompatible size of X%d', i);
  end
  
  if dims(params.rc_pairs(i,2)) == 0
    dims(params.rc_pairs(i,2)) = n;
  else
    assert(dims(params.rc_pairs(i,2))==n, 'Incompatible size of X%d', i);
  end
end

assert(all(dims>0), 'There are unused factors');

assert(length(params.alphas) == length(Xs), 'Require exactly %d alphas, got %d', length(Xs), length(params.alphas));

assert(all(isbetween(params.alphas, 0.0, 1.0, 'closed')), 'alphas must be in [0,1] (is %g %g)', params.alphas);

assert(any(params.alphas ~= 0), 'All the data weights are zero');

[Vs unused] = process_options(varargin, 'init_model', [ ]);
if isempty(Vs)
  Vs=random_model(length(dims), dims, params);
else
  for i=1:length(dims)
    assert(rows(Vs{i})==dims(i));
  end
end


for i=1:length(Xs)
  assert(rows(Ws{i})==rows(Xs{i}) && cols(Ws{i})==cols(Xs{i}));
end


LogIf(params.gradient, 'Using the gradient step instead of Newton.\n');
WarnIf(params.add_bias_term, 'Using add_bias_term, experimental');
LogIf(params.no_adjusted_dependent_variates, 'Using no_adjusted_dependent_variates.\n');

% debug.cputime = [ 0 ]; % i^th entry is time it took to complete i iterations.
% debug.model = [ Vs ];

obj = loss_relational(Xs, Ws, Vs, params.rc_pairs, params.scales, params.alphas, params.fs, params.loss_fs);

fprintf(1, 'Iteration 0 (random parameters): obj = %g\n', obj);
update_seq = randperm(length(Vs));
Vs_new = cell(length(Vs),1);
for iter = 1:params.maxiter
    start_time = cputime;
    updated = repmat(false, 1, length(Vs));
    %
    for i = update_seq
      Xsi = {}; % data matrices needed for updating Vs{i}
      Wsi = {}; % weigt matrices needed for updating Vs{i}
      Vsi = {}; % relevant factors needed for updating Vsi{i}
      fsi = {};
      f_primesi = {};
      loss_fsi = {};
      alphasi = [];
      ni = 0;
      for t = 1:length(Xs)
        vi = 0;
        if params.rc_pairs(t,1) == i
          ni = ni + 1;
          Xsi{ni} = Xts{t};
          Wsi{ni} = Wts{t};
          vi  = params.rc_pairs(t,2);
          alphasi = [alphasi params.alphas(t)];
        elseif params.rc_pairs(t,2) == i
          ni = ni+1;
          Xsi{ni} = Xs{t};
          Wsi{ni} = Ws{t};
          vi  = params.rc_pairs(t,1);
          alphasi = [alphasi params.alphas(t)];
        end
        if vi > 0
          if updated(vi)
            Vsi{ni} = Vs_new{vi};
          else
            Vsi{ni} = Vs{vi};
          end
          fsi{ni} = params.fs{t};
          f_primesi{ni} = params.f_primes{t};
          loss_fsi{ni} = params.loss_fs{t};
        end
      end
      
      Vs_new{i} = newton_update_relational(Xsi,Wsi,Vsi,Vs{i},iter,fsi,f_primesi,loss_fsi,...
                                        params.scales(i), alphasi, sprintf('V%d',i), params);
      updated(i) = true;
    end
      
    

    duration = cputime - start_time;
    loss_iter = loss_relational(Xs,Ws,Vs_new,params.rc_pairs, params.scales, params.alphas, params.fs, params.loss_fs);
    epsilon = loss_iter - obj(end);
    if (epsilon <= 0 && isfinite(epsilon)) || ...
            (iter <= params.miniter && isfinite(epsilon)) || ...
            ((params.stochastic_opt || params.add_bias_term) && isfinite(epsilon))
        obj = [obj obj(end) + epsilon];
        Vs = Vs_new;
 
    elseif not(isfinite(epsilon))
        if params.stochastic_opt
            warning('RFA:BadResult', 'Infinite loss...throwing away the update');
        else
            error('RFA:BadResult', 'Infinite loss on non-stochastic descent');
        end
    else
        warning('RFA:BadResult', 'Freaky, epsilon = %e\n', epsilon);
        if not(params.stochastic_opt || params.add_bias_term)
            break;
        end
    end

    oc = abs(epsilon/obj(end));
    if mod(iter,1) == 0
        fprintf(1, 'Iteration %d: eps = %g, obj = %g, oc = %.3f, time = %.3f sec\n', iter, epsilon, obj(end), oc, duration);
    end

    if not(params.stochastic_opt)
        if oc < params.obj_threshold && iter >= params.miniter
            break
        end
    end
end

end % function glm


function Vs = random_model(num_factors, sizes, params)
% Arguments:
%
% X: Data matrix (m x n)
% Y: Data matrix (n x r)
%
% Return Values:


error(nargchk(3, 3, nargin));

assert(params.k > 0 & params.k == fix(params.k), 'k is not an embedding dimension (%f)', params.k);


for i=1:num_factors
  Vs{i} = normalize_rows(rand(sizes(i), params.k));
end
if params.add_bias_term
  error('Bias term not supported');
end
end


function obj = loss_relational(Xs, Ws, Vs, rc_pairs, scales, alphas, fs, loss_fs)

obj = 0;
for i=1:length(Xs)
  T = sparse_predict(Ws{i}, Vs{rc_pairs(i,1)}, Vs{rc_pairs(i,2)});
  obj = obj + alphas(i) * loss_fs{i}(Xs{i}, Ws{i}, T, fs{i});
end

for j=1:length(Vs)
  obj = obj + scales(j) * sum(Vs{j}(:).^2)/(2*numel(Vs{j}));
end

end % end function

function T = sparse_predict(W,U,V)
T = sparse(W);
n = size(W,2);
for i=1:n
  nzinds = find(W(:,i));
  T(nzinds,i) = U(nzinds,:)*V(i,:)';
end
end % end function