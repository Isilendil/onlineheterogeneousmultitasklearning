function myassert(condition, message, varargin)
% MYASSERT - Custom version of Matlab 7 built-in assert.
%
% The signature is identical to Matlab 7's built-in assert, i.e.,
% assert(x > 0, 'x must be non-negative (is %d)', x)
%
% Arguments:
%
% condition: A logicial condition that we are asserting is true.
% message: A printf-style message that is used if the condition is false.
% varargin: Arguments for the printf message.
%
% Return Values:
%
% N/A

if ~condition
  if nargin == 1
    error('Assertion failed');
  elseif nargin == 2
    error(message);
  else
    error(sprintf(message, varargin{:}));
  end
end
