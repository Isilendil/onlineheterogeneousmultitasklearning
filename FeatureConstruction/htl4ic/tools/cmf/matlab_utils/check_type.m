function check_type(obj, typename)
% CHECK_TYPE - Check that obj is of the given class.

assert(isa(obj, typename), 'Argument "%s" is not of type %s', ...
       inputname(1), typename);
