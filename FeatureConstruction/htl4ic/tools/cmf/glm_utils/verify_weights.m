function [matrix func hasweights]  = verify_weights(W, X)
% VERIFY_WEIGHTS - Check that the weight matrix or function is usable.
%
% Arguments:
%
% W: Weight matrix or weight function.
% X: Corresponding data matrix.
%
% Return Values:
%
% matrix: If W was a weight matrix, then it is W. Otherwise = [ ].
% func: If W was a weight function, then it is W. Otherwise = [ ].
% hasweights: True iff W was a weight matrix.

matrix = [ ];
func = [ ];
if isa(W, 'function_handle')
  func = W;
  % TODO(ajit): Fix these test to deal with xcolscale_GZPUQ
% $$$   func(1.0, 1, 1); % Test that the signature is right.
% $$$   func(1.0, rows(X), cols(X)); % Test that we have the right matrix.
  hasweights = false;
else
  check_dims(W, rows(X), cols(X), 'W');
  matrix = W;
  hasweights = true;
  if not(isnumeric(W))
    warning('RFA:Performance', ...
            'W is of type %s, which will make w .* err very slow', class(W));
  end
end
end % function

