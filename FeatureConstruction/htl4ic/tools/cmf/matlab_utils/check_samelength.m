function check_samelength(x, y, msg)

error(nargchk(2, 3, nargin));
if nargin == 2
  msg = 'default-msg';
end

assert(length(x) == length(y), ...
       '%s: arguments are different length (%d vs. %d)', ...
       msg, length(x), length(y));
