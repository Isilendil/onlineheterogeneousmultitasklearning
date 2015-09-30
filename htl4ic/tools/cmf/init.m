% Initialize the environment
%
% Any path dependencies, default data sets, or introductory
% messages should be placed here.

% TODO(ajit): Break up into init script for different functions.

fprintf(1, 'Initializing environment for running relational matrix factorization:\n');
fprintf(1, '---> Setting paths...done\n');
addpath(cd);
addpath(fullfile(cd, 'eval'));
addpath(fullfile(cd, 'glm_utils'));
addpath(fullfile(cd, 'matlab_utils'));
addpath(fullfile(cd, 'links'));



% if not(exist(fullfile(cd,'RFA',sprintf('%s.%s', 'wieght_sample_mex', mexext), 'file'))
%   fprintf(1, '----> Compiling wieght_sample_mex...');
%   cd third_party/bagon;
%   compile_wieght_sample;
%   fprintf(1, 'done\n');
%   fprintf(1, ['If you got a bunch of errors of the form "Warning: You are'...
%               'using gcc version 3.4.6. The earliest version supported'...
%               'with mex is 4.0.0", just ignore it. The compiled object seems'...
%               'to work\n']);
%   cd ../..;
% end

% TODO(ajit): Either condition the following line on the MATLAB version, or
% change it to a warning for the user. setNumberOfComputationThreads is
% not an officially supported function. R2007b has
% maxNumCompThreads for controlling threads programmatically. All of this
% code assumes Matlab 7.
if verLessThan('matlab', '7.5.0')
  setNumberOfComputationalThreads(1); % much faster if using MKL in Matlab.
else
  maxNumCompThreads(1);
end
