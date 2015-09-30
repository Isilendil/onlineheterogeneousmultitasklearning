function check_length(obj, len)
% CHECK_LENGTH - Check that obj is a vector of given length

sz = size(obj);
assert(any(sz == 1) || all(sz == 0), ...
       'Expected a vector, got a %d x %d matrix', sz(1), sz(2));
assert(length(obj) == len, 'Expected length %d, got %d', len, length(obj));
