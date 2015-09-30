function [ ] = LogIf(printmsg, msg, varargin)
% LogIf -- Log a message to the console if a condition is true.
%
% [ ] = LogIf(printmsg, msg, varargin)
% Acts like a version of fprintf to stderr, that prints the message only
% if printmsg is true.
%
% Example
%
% LogIf(i ~= j, 'i ~= j (%d vs. %d)', i, j);
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
  fprintf(1, msg, varargin{:});
end
