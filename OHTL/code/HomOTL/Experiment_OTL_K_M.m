function  Experiment_OTL_K_M(dataset_name)
% Experiment_OTL_K_M: the main function used to compare all the online
% algorithms
%--------------------------------------------------------------------------
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
%--------------------------------------------------------------------------

m_old = 100;
m_new = 500;

%load dataset
load(sprintf('../../../TextImage/data/original/%d',dataset_name));
load('ID_hom');

data_old = [image_gnd(m_new+1:m_new+m_old,:), image_fea(m_new+1:m_new+m_old,:)];
data_new = [image_gnd(1:m_new,:), image_fea(1:m_new,:)];


data = [data_old; data_new];
[n,d]       = size(data);
% set parameters
options.C   = 5;

%% set parameters: 'sigma'( kernel width) and 't_tick'(step size for plotting figures)
options.sigma = 4;
options.sigma2 = 8;
options.t_tick= round(length(ID_new)/10);

%%
m = length(ID_new);
options.beta=sqrt(m)/(sqrt(m)+sqrt(log(2)));
options.Number_old=n-m;
%ID_old = 1:n-m;
Y=data(1:n,1);
Y=full(Y);
X = data(1:n,2:d);


% scale
MaxX=max(X,[],2);
MinX=min(X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
X = bsxfun(@minus, X, MinX);
X = bsxfun(@rdivide, X , DifX_2);


P = sum(X.*X,2);
P = full(P);
%disp('Pre-computing kernel matrix...');
K = exp(-(repmat(P',n,1) + repmat(P,1,n)- 2*X*X')/(2*options.sigma^2));
 K = X*X';

X2 = X(n-m+1:n,:);
Y2 = Y(n-m+1:n);
P2 = sum(X2.*X2,2);
P2 = full(P2);
K2 = exp(-(repmat(P2',m,1) + repmat(P2,1,m)- 2*X2*X2')/(2*options.sigma2^2));
 K2 = X2*X2';

%% learn the old classifier
[h, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(Y, K, options, ID_old);

%fprintf(1,'The old classifier has %f support vectors\n',length(h.SV));
%% run experiments:
for i=1:size(ID_new,1),
    %fprintf(1,'running on the %d-th trial...\n',i);
    ID = ID_new(i, :);
    
    %1. PA-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1_K_M(Y2,K2,options,ID);
    nSV_PA1(i) = length(classifier.SV);
    err_PA1(i) = err_count;
    time_PA1(i) = run_time;
    mistakes_list_PA1(i,:) = mistakes;
    SVs_PA1(i,:) = SVs;
    TMs_PA1(i,:) = TMs;
    
    %2. PAIO
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PAIO_K_M(Y,K,options,ID,h);
    nSV_PAI(i) = length(classifier.SV);
    err_PAI(i) = err_count;
    time_PAI(i) = run_time;
    mistakes_list_PAI(i,:) = mistakes;
    SVs_PAI(i,:) = SVs;
    TMs_PAI(i,:) = TMs;
    
    %3. HomOTL(fixed)
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTLf_K_M(Y,K,K2,options,ID,h);
    nSV_SC(i) = length(classifier.SV1)+length(classifier.SV2);
    err_SC(i) = err_count;
    time_SC(i) = run_time;
    mistakes_list_SC(i,:) = mistakes;
    SVs_SC(i,:) = SVs;
    TMs_SC(i,:) = TMs;
    
    %4. HomOTL-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1_K_M(Y,K,K2,options,ID,h);
    nSV_OTL(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL(i) = err_count;
    time_OTL(i) = run_time;
    mistakes_list_OTL(i,:) = mistakes;
    SVs_OTL(i,:) = SVs;
    TMs_OTL(i,:) = TMs;
    
    %5. HomOTL-II
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2_K_M(Y,K,K2,options,ID,h);
    nSV_OTL2(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2(i) = err_count;
    time_OTL2(i) = run_time;
    mistakes_list_OTL2(i,:) = mistakes;
    SVs_OTL2(i,:) = SVs;
    TMs_OTL2(i,:) = TMs;
    
end

stat_file = sprintf('../../stat/pearson/%d-hom-stat', dataset_name);
save(stat_file, 'err_PA1', 'err_PAI', 'err_SC', 'err_OTL', 'err_OTL2', 'nSV_PA1', 'nSV_PAI', 'nSV_SC', 'nSV_OTL', 'nSV_OTL2', 'time_PA1', 'time_PAI', 'time_SC', 'time_OTL', 'time_OTL2', 'mistakes_list_PA1', 'mistakes_list_PAI', 'mistakes_list_SC', 'mistakes_list_OTL', 'mistakes_list_OTL2', 'SVs_PA1', 'SVs_PAI', 'SVs_SC', 'SVs_OTL', 'SVs_OTL2', 'TMs_PA1', 'TMs_PAI', 'TMs_SC', 'TMs_OTL', 'TMs_OTL2');


fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'number of mistakes,            size of support vectors,           cpu running time\n');
fprintf(1,'PA             %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_PA1)/m*100,  std(err_PA1)/m*100, mean(nSV_PA1), std(nSV_PA1), mean(time_PA1), std(time_PA1));
fprintf(1,'PAIO           %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_PAI)/m*100,  std(err_PAI)/m*100, mean(nSV_PAI), std(nSV_PAI), mean(time_PAI), std(time_PAI));
fprintf(1,'HomOTL(fixed)  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_SC)/m*100,   std(err_SC)/m*100, mean(nSV_SC), std(nSV_SC), mean(time_SC), std(time_SC));
fprintf(1,'HomOTL-I       %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL)/m*100,  std(err_OTL)/m*100, mean(nSV_OTL), std(nSV_OTL), mean(time_OTL), std(time_OTL));
fprintf(1,'HomOTL-II      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL2)/m*100, std(err_OTL2)/m*100, mean(nSV_OTL2), std(nSV_OTL2), mean(time_OTL2), std(time_OTL2));
fprintf(1,'-------------------------------------------------------------------------------\n');

