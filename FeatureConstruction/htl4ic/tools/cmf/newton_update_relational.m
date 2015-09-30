function [Z, delta, change] = newton_update_relational(Ys, Ws, Vs, Z, iter, fs, f_primes, loss_fs,...
  scale_z, alphas, factorname, params)
% for a factorizatio Ys{i} = Vs{i}*Z, updates the factor matrix Z, Ws{i} is the weight matrix on Ys{i}

if nargin < 12
  error('usage [Z, delta, change] = newton_update_relational(Ys, Ws, Vs, Z, iter, fs, f_primes, scale_z, alphas, factorname)');
end
r = size(Z,1);
num_mats = length(Ws);
lengths = [length(Ws) length(Ys) length(Vs) length(fs) length(f_primes) length(loss_fs) length(alphas)];
assert(all(lengths == num_mats), 'Ws, Ys, fs, f_primes, loss_fs, alphas must all be of the same size');
for i=1:num_mats
  assert(size(Ys{i},2)==r && size(Ws{i},2)==r);
end
if all(alphas == 0)
  delta = 0;
  change = 0;
  return;
end

if params.add_bias_term
  error('bia not supported yet');
  %     pidx = [1:k k+3];
  %     Ii = diag(params.scale_i * [ones(1,k) 0]);
  %     [Z_tied HZ delta change] = newton_step_z(Y, V(:,pidx), Z(:,pidx), Ii, iter, HZ, params, glmvars);
  %     Z(:,pidx) = Z_tied;
else
  Ii = scale_z * eye(params.k);
end


Zold = Z;
condition = repmat(NaN, 1, r);
stepsize  = repmat(NaN, 1, r);
unchanged = 0;
delta = 0;

Ys2 = cell(num_mats, r);
Ws2 = cell(num_mats, r);

% HACK: gene Ys2 and Ws2 since accessing Ys2{t,i} and Ws2{t,i}
% are much more efficient than accessing Ys{t}(:,i) and Ws{t}(:,i)
for t=1:num_mats
  Yt = Ys{t};
  Wt = Ws{t};
  for i=1:r
      Ys2{t,i} = Yt(:,i);
      Ws2{t,i} = Wt(:,i);
  end
end

for i = 1:r
  z = Z(i,:);
  Ci = scale_z .* z;
  
%   if params.add_bias_term
%     Ci(k+1:end) = 0;
%   end
  
  grad = Ci;
  covar = Ii;

  Vss = {}; % sample Vs
  ys = {};
  ws = {};
  Vzs = {};
  for t = 1:num_mats
    if alphas(t)==0
      continue;
    end
    inds = Ws2{t,i}>0;
    ys{t} = full(Ys2{t,i}(inds));
    ws{t} = full(Ws2{t,i}(inds));
    Vss{t} = Vs{t}(inds,:);
    nVs = rows(Vss{t});
    Vzs{t} = Vss{t}*z';
    if isempty(find(ws{t},1))
      LogIf(params.debug && params.debug_zeroweights, '%s(%d): All weights w == 0\n', factorname, i);
    end
    expecty = fs{t}(Vzs{t});
    err = (ys{t} - expecty)';
    raw_deriv = f_primes{t}(Vzs{t});
    % update gradient and hessian
    grad = grad + alphas(t) .* (ws{t}'.*-err) * Vss{t};
    d = ws{t} .* raw_deriv;
    
    % HACK: require lightspeed
    %D = diag(d);
    %D = spdiags(d, 0, nVs, nVs);
    %covar = covar + alphas(t) .* Vss{t}'* D *Vss{t};
    covar = covar + alphas(t) .* scale_cols(Vss{t}',d)*Vss{t};
  end
  eta = initial_steplength(params);

  if params.gradient
    Z(i,:) = Z(i,:) - eta .* grad;
  else
    invertible = check_covariance(covar, params, factorname, i);
    if not(invertible)
      unchanged = unchanged + 1;
      continue;
    end
    if params.linesearch && iter >= params.min_armijo_iter
      step = grad / covar;
      loss_old = 0;
      for t = 1:num_mats
        if alphas(t) > 0
          loss_old = loss_old + alphas(t)*loss_natural(ys{t}, ws{t}, Vzs{t}, z, loss_fs{t}, scale_z, params.k); 
        end
      end

      sufficient = false;
      while eta > params.mineta && not(sufficient)  
        z_new = z - eta .* step;
        loss_new = 0;
        for t = 1:num_mats
          if alphas(t) > 0
            loss_new = loss_new + alphas(t)*loss_natural(ys{t}, ws{t}, Vss{t}*z_new', z_new, loss_fs{t}, scale_z, params.k);
          end
        end
        sufficient = (loss_new - loss_old <= min(0,params.c * eta * step * grad'));
        if sufficient
          Z(i,:) = z_new;
          stepsize(i) = eta;
          delta = delta + (loss_new - loss_old);
          break;
        end
        eta = params.rho * eta;
      end
      if not(sufficient)
        LogIf(params.debug && params.debug_decrease,'Cancelling update of %s(%d). No good stepsize found\n',factorname, i);
        unchanged = unchanged + 1;
      end
    else
      step = grad / covar;
      Z(i,:) = Z(i,:) - eta .* step;
      stepsize(i) = eta;
    end
  end
end

change = mean_normchange(Z, Zold);
step_report(factorname, change, unchanged, condition, r, stepsize, delta, params);

end % newton_step_z

function obj = loss_natural(Y,W,T,Z,loss_f,scale_z,k)
% xloss_natural -- Compute the reconstruction loss of the Y matrix, given
% the factors and the natural parameters.
%
% obj = yloss_natural(Y,W,T,V,Z,params)
% Computes the reconstruction error of Y by f(T). The data, weights, and
% parameters can be either vectors or matrices.
%
% Arguments:
%
% Y: Data matrix (n x r)
% W: Weight matrix (n x r)
% T: Natural parameters (n x r)
% V: Row factors (n x k)
% Z: Column factors (r x k)
% params: Optimization parameters
%
% Return Values:
%
% obj: Reconstruction error

loss = loss_f(Y, W, T);

if cols(Z) > k
  Z = Z(:,1:k);
end

if numel(Z)>0
  reg_z = scale_z * sum(Z(:).^2)/(2*numel(Z));
end
obj = loss +  reg_z;
end % function xloss_natural



