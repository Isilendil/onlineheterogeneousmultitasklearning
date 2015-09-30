function check_samedims(X, Y, msg)

error(nargchk(2, 3, nargin));

if nargin == 2
  msg = 'default-msg';
end

assert(rows(X) == rows(Y) && cols(X) == cols(Y), ...
       '%s: X and Y are not the same shape, (%d x %d vs. %d x %d)', ...
       msg, rows(X), cols(X), rows(Y), cols(Y));
