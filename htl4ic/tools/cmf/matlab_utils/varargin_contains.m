function status = varargin_contains(name, varargin);
% VARARGIN_CONTAINS - Does varargin include the given string parameter ?
%
% status = varargin_contains(varg, name);
%
% Arguments:
%
% varg: varargin
% name: string
%
% Return Values:
%
% status: True if varg contains the name.

status = any(cellfun(@(argname)(strcmpi(argname, name)), varargin));
