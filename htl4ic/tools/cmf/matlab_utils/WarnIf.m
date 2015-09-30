function [ ] = WarnIf(printmsg, msg, varargin)
% WarnIf -- Send a warning to the console if a condition is true.
%
% [ ] = WarnIf(printmsg, msg, varargin)
% Acts like a version of fprintf to stderr, that prints the message only
% if printmsg is true.
%
% Example
%
% WarnIf(i ~= j, 'i ~= j (%d vs. %d)', i, j);
%
% Arguments
%
% printmsg: If this is true, print the message.
% msg: The message to print. Can be any valid fprintf string.
% varargin: Values passed to fprintf.
%
% Return Values
%
% None

if printmsg
  warning(msg, varargin{:});
end
