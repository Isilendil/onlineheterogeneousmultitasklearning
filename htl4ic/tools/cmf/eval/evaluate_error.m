function errs = evaluate_error(Xs, Vs, err_fs, params)
% EVALUATE_ERROR - Compute the error defined by the split on the test data.
%
% Arguments:
%
% model: An instance of @model4f.
% split: A split of the data, containing fields xtest, exi, exj, ytest, eyi, eyj, qtest,eqi,eqj
% params: Optimization parameters. f/ff define the prediction links.
% mode: Controls whether the error is computed on X, Y, or both ('all'). Opt.
%
% Return Values:
%
% tex: Error on the test data from X.
% tey. Error on the test data from Y.

% Author: Ajit Singh (ajit@cs.cmu.edu)

errs = cell(1,length(Xs));
for i = 1:length(Xs)
  if ~isempty(Xs{i})
    Ti = sparse_predict(Xs{i}, Vs{params.rc_pairs(i,1)}, Vs{params.rc_pairs(i,2)}, params.fs{i});
    errs{i} = err_fs{i}(Xs{i}, Ti);
  end
end

end

function T = sparse_predict(X,U,V,f)
T = sparse(X);
n = size(X,2);
for i=1:n
  nzinds = find(X(:,i));
  T(nzinds,i) = f(U(nzinds,:)*V(i,:)');
end
end % end function

