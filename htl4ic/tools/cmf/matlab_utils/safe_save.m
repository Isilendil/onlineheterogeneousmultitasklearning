function status = safe_save(filename, varargin)
% SAFE_SAVE - Save that tries harder to save the data than save, even if we
%             cannot write to the given directory.
%
% status = safe_save(filename, varargin)
%
% Arguments:
%
% filename: Name to save to.
% varargin: Arguments to save
%
% Return Values:
%
% status: True only when data was saved to the given filename. If the file
%         was saved to a temporary directory, or not at all, we return false.

writable = true;
if exist(filename, 'file')
  warning('File %s already exists. Will not overwrite.', filename);
  writable = false;
end

 sprintf('save(\''%s\''%s)', filename, ...
                           sprintf(',\''%s\''', varargin{:}))
if writable
  evalin('caller', sprintf('save(\''%s\''%s)', filename, ...
                           sprintf(',\''%s\''', varargin{:})));
else
  altfilename = tempname;
  evalin('caller', sprintf('save(\''%s\''%s)', altfilename, ...
                           sprintf(',\''%s\''', varargin{:})));
  LogIf(true, 'Wrote data to %s instead of %s\n', altfilename, filename);
end

status = logical(exist(filename, 'file')) && writable;

