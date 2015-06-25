function  Experiment(data_file, similarity_file)
% Experiment: the main function used to compare all the online
% algorithms
%--------------------------------------------------------------------------
% Input:
%      dataset_name, name of the dataset, e.g. 'birds-food'
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


%load dataset
load(sprintf('../data/%s', data_file));
%load(sprintf('%s','boats_toy'));
%load(sprintf('%s','flowers_tree'));
%load(sprintf('%s','vehicle_tree'));

%=========================================
load(sprintf('../data/%s', similarity_file));
%load(sprintf('%s','boats_toy_sim'));
%load(sprintf('%s','flowers_tree_sim'));
%load(sprintf('%s','vehicle_tree_sim'));
P_it = P_ti';
%=========================================

load('ID');

Y = image_gnd(1:num_old+num_new,:);
Y = full(Y);
X = image_fea(1:num_old+num_new,:);

%temp = X(1:num_old,:);
%X(1:num_old,:) = normrnd(0,1,size(temp))+temp;

[n,d] = size(X);
%[n,d] = size(image_fea);
% set parameters
options.C   = 5;
options.sigma = 4;
options.sigma2 = 8;
options.t_tick = round(size(ID_new,2)/10);

%====================================
options.K = 100;
%====================================

%%
m = size(ID_new,2);
options.beta=sqrt(m)/(sqrt(m)+sqrt(2*log(2)));

options.Number_old=n-m;
%ID_old = 1:n-m;



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
disp('Pre-computing kernel matrix...');
K1 = exp(-(repmat(P',n,1) + repmat(P,1,n)- 2*X*X')/(2*options.sigma^2));
%K1 = X*X';

X2 = X(n-m+1:n,:);
Y2 = Y(n-m+1:n);
P2 = sum(X2.*X2,2);
P2 = full(P2);
K2 = exp(-(repmat(P2',m,1) + repmat(P2,1,m)- 2*X2*X2')/(2*options.sigma2^2));
% K2 = X2*X2';


ID_old_subset = ID_old;

P_it = P_it(num_old+1:num_old+num_new,:);


%% run experiments:
for i=1:size(ID_new,1),
   % fprintf(1,'running on the %d-th trial...\n',i);
    ID = ID_new(i, :);

		%1. personal model
		%2. shared-loss model
		%3. domain-specific (1) + optimization
		%4. domain-specific (2) + optimization
		%5. latent + optimization
		%6. domain-specific (1) + latent + optimization
		%7. domain-specific (2) + latent + optimization
		
    
    %1. PA-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y2,K2,options,ID);
    nSV_PA1(i) = length(classifier.SV);
    err_PA1(i) = err_count;
    time_PA1(i) = run_time;
    mistakes_list_PA1(i,:) = mistakes;
    SVs_PA1(i,:) = SVs;
    TMs_PA1(i,:) = TMs;
    
    
    %2. HomOTL-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1_s(Y,K1,K2,options,ID,h);
    nSV_OTL(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL(i) = err_count;
    time_OTL(i) = run_time;
    mistakes_list_OTL(i,:) = mistakes;
    SVs_OTL(i,:) = SVs;
    TMs_OTL(i,:) = TMs;
    
    %3. HomOTL-II
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2_s(Y,K1,K2,options,ID,h);
    nSV_OTL2(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2(i) = err_count;
    time_OTL2(i) = run_time;
    mistakes_list_OTL2(i,:) = mistakes;
    SVs_OTL2(i,:) = SVs;
    TMs_OTL2(i,:) = TMs;
    


    %5. OHT-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = OHT1_s(Y2,K2,P_it,text_gnd,options,ID);
    nSV_OHT1(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OHT1(i) = err_count;
    time_OHT1(i) = run_time;
    mistakes_list_OHT1(i,:) = mistakes;
    SVs_OHT1(i,:) = SVs;
    TMs_OHT1(i,:) = TMs;
    
    %6. OHT-II
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = OHT2_s(Y2,K2,P_it,text_gnd,options,ID);
    nSV_OHT2(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OHT2(i) = err_count;
    time_OHT2(i) = run_time;
    mistakes_list_OHT2(i,:) = mistakes;
    SVs_OHT2(i,:) = SVs;
    TMs_OHT2(i,:) = TMs;
    

end


stat_file = sprintf('stat/%s-stat', data_file);
save(stat_file, 'nSV_PA1', 'err_PA1', 'time_PA1', 'mistakes_list_PA1', 'SVs_PA1', 'TMs_PA1', 'nSV_OTL', 'err_OTL', 'time_OTL', 'mistakes_list_OTL', 'SVs_OTL', 'TMs_OTL', 'nSV_OTL2', 'err_OTL2', 'time_OTL2', 'mistakes_list_OTL2', 'SVs_OTL2', 'TMs_OTL2', 'nSV_OHT1', 'err_OHT1', 'time_OHT1', 'mistakes_list_OHT1', 'SVs_OHT1', 'TMs_OHT1', 'nSV_OHT2', 'err_OHT2', 'time_OHT2', 'mistakes_list_OHT2', 'SVs_OHT2', 'TMs_OHT2');

fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'number of mistakes,            size of support vectors,           cpu running time\n');
fprintf(1,'PA             %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_PA1)/m*100,  std(err_PA1)/m*100, mean(nSV_PA1), std(nSV_PA1), mean(time_PA1), std(time_PA1));
fprintf(1,'HomOTL-I       %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL)/m*100,  std(err_OTL)/m*100, mean(nSV_OTL), std(nSV_OTL), mean(time_OTL), std(time_OTL));
fprintf(1,'HomOTL-II      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL2)/m*100, std(err_OTL2)/m*100, mean(nSV_OTL2), std(nSV_OTL2), mean(time_OTL2), std(time_OTL2));
%fprintf(1,'Het             %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_Het)/m*100,  std(err_Het)/m*100, mean(nSV_Het), std(nSV_Het), mean(time_Het), std(time_Het));
fprintf(1,'OHT-I  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT1)/m*100,   std(err_OHT1)/m*100, mean(nSV_OHT1), std(nSV_OHT1), mean(time_OHT1), std(time_OHT1));
fprintf(1,'OHT-II  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT2)/m*100,   std(err_OHT2)/m*100, mean(nSV_OHT2), std(nSV_OHT2), mean(time_OHT2), std(time_OHT2));
fprintf(1,'-------------------------------------------------------------------------------\n');

