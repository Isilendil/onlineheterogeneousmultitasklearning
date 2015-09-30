function str = bool2str(val)
% BOOL2STR - Convert a boolean to a string representation, "true" or "false"
%
% Arguments:
%
% val: A boolean value, or something that can be cast to boolean
%
% Return Values:
%
% str: A string "true" or "false" based on the value.

% Author: Ajit Singh (ajit@cs.cmu.edu)

val = logical(val);
if val
  str = 'true';
else
  str = 'false';
end
