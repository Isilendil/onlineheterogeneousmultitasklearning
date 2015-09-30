function check_nonnegative(value)
% CHECK_NONNEGATIVE - Check that the value is non-negative.

assert(isnumeric(value), 'Expected a numeric type, got %s', class(value));
assert(value > 0);
