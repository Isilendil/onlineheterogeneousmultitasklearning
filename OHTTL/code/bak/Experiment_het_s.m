function  Experiment_het_s(data_file)
% Experiment_OTL_K_M: the main function used to compare all the online
% algorithms
%==========================================================================
% Input:
%      dataset_name, name of the dataset, e.g. 'books_dvd'
%
% Output:
%      a table containing the accuracies, the numbers of support vectors,
%      the running times of all the online learning algorithms on the
%      inputed datasets
%      a figure for the online average accuracies of all the online
%      learning algorithms
%      a figure for the online numbers of SVs of all the online learning
%      algorithms
%      a figure for the online running time of all the online learning
%      algorithms
%==========================================================================

%load dataset

load(sprintf('../data/%s', data_file));

load('ID');
num_old = 50;

num_new = 500;

Y = image_gnd(1:num_old+num_new, :);
Y = full(Y);
X = image_fea(1:num_old+num_new, :);

[n,d]       = size(X);
m = size(ID_new, 2);
% set parameters
options.gamma1=1;
options.gamma2=1;
options.C   = 5;
options.sigma1 = 4;
options.sigma2 = 4;
options.sigma3 = 8;
options.t_tick = round(size(ID_new,2)/10);

%d_o=round((d-1)/2-0.1);
d_o = d/2;
%d_o = d - 100;

%%
%% scale
MaxX=max(X,[],2);
MinX=min(X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
X = bsxfun(@minus, X, MinX);
X = bsxfun(@rdivide, X , DifX_2);

X1 = X(:,1:d_o);
X2 = X(n-m+1:n,d_o+1:d);
X3 = X(n-m+1:n,:);
Y3 = Y(n-m+1:n);
P1 = sum(X1.*X1,2);
P1 = full(P1);
P2 = sum(X2.*X2,2);
P2 = full(P2);
P3 = sum(X3.*X3,2);
P3 = full(P3);
options.Num_old=n-m;
disp('Pre-computing kernel matrix...');
K1 = exp(-(repmat(P1',n,1) + repmat(P1,1,n)- 2*X1*X1')/(2*options.sigma1^2));
K2 = exp(-(repmat(P2',m,1) + repmat(P2,1,m)- 2*X2*X2')/(2*options.sigma2^2));
K3 = exp(-(repmat(P3',m,1) + repmat(P3,1,m)- 2*X3*X3')/(2*options.sigma3^2));
K4 = exp(-(repmat(P3',m,1) + repmat(P3,1,m)- 2*X3*X3')/(2*4^2));
%% learn the old classifier



	ID_old_subset = ID_old(1:50);

[h, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_het_s(Y, K1, options, ID_old_subset);

fprintf(1,'The old classifier has %f support vectors\n',length(h.SV));

%% run experiments:
for i=1:size(ID_new,1),
    %fprintf(1,'running on the %d-th trial...\n',i);
    ID = ID_new(i, :);
    
    %5. HetOTL
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HetOTL_s(Y,K1,K2,options,ID,h);
    nSV_COTL(i) = length(classifier.SV1)+length(classifier.SV2);
    err_COTL(i) = err_count;
    time_COTL(i) = run_time;
    mistakes_list_COTL(i,:) = mistakes;
    SVs_COTL(i,:) = SVs;
    TMs_COTL(i,:) = TMs;
end

stat_file = sprintf('stat/%s-het-stat', data_file);
save(stat_file, 'nSV_COTL', 'err_COTL', 'time_COTL', 'mistakes_list_COTL', 'SVs_COTL', 'TMs_COTL');


%% print and plot results

fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'HetOTL:   %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_COTL)/m*100,  std(err_COTL)/m*100,  mean(nSV_COTL), std(nSV_COTL), mean(time_COTL), std(time_COTL));
fprintf(1,'-------------------------------------------------------------------------------\n');


