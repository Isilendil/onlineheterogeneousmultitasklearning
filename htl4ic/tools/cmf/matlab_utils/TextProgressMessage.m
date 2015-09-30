function [power] = TextProgressMessage(iter,maxiter,power,prefix,printmsg)
% TextProgressMessage -- Print an update message to the console
%
% [power] = TextProgressMessage(iter,maxiter,power,prefix)
% Prints a status messages, to stderr, of the form
%   iteration 1 of 2000
%   iteration 2 of 2000
%   iteration 4 of 2000
%   iteration 8 of 2000
%   ...
%   iteration 1024 of 2000
%   iteration 2000 of 2000
%
% An example of the typical usage is
%    m = 125;
%    power = 1;
%    for i = 1:m
%      power = TextProgressMessage(i, m, power, 'Updating: ', true);
%    end
%
% Arguments
%
% iter: The current iteration
% maxiter: The maximum number of iterations to track
% power: Print a message if 2^power iterations have occurred.
% prefix: A prefix to the message.
% printmsg: If false, suppress printing of any status messages.
%
% Return Values
%
% power: Print another update message after 2^power iterations have passed.

% Author: ajit@cs.cmu.edu (Ajit Singh)

if nargin == 4
  printmsg = true;
end

if mod(iter,power) == 0 || iter == maxiter
  power = power * 2;
  if printmsg
    fprintf(1, '%siteration %d of %d\n', prefix, iter, maxiter);
  end
end
