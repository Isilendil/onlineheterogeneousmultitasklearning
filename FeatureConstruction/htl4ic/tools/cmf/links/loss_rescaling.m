% Determines a recalibration factor for L(U,V) so that L(U,V) and L(V,Z)
% are roughly on the same scale. Does so by generating random matrices,
% which should be bad for fitting both X and Y [ie, no signal] and then 
% compares the ratio of the losses. We average over a couple of runs.

% see alpha_matters.m
function scale = loss_rescaling(X,Wx,Y,Wy,params)

  [m,n] = size(X);
  [q,r] = size(Y); 
  if n ~= q
    error('X and Y are not conformable');
  end

  %Wx = ones(size(X));
  %Wy = ones(size(Y));
  k = params.k;

  res = [];

  for i = 1:10
    U = normalize_rows(rand(m,k));
    V = normalize_rows(rand(n,k));
    Z = normalize_rows(rand(r,k));    
    luv = params.loss_f(X,params.Wx,U*V',params.f); + ...
          sum(sum(params.scale .* U.^2))/2 + sum(sum(params.scale .* V.^2))/2;
    lvz = params.loss_ff(Y,params.Wy,V*Z',params.ff); + ...
          sum(sum(params.scale .* V.^2))/2 + sum(sum(params.scale .* ...
                                                     Z.^2))/2;  
    res = [res luv/lvz];
  end
  scale = mean(res);
