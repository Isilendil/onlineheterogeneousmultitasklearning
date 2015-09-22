function  Experiment_hom_s(data_file)
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
load(sprintf('../../../../OnlineHeterogeneousMultitaskLearning/source/TextImage/data/original/%d', data_file));
%load(sprintf('%s','boats_toy'));
%load(sprintf('%s','flowers_tree'));
%load(sprintf('%s','vehicle_tree'));

%=========================================
load(sprintf('../../../../OnlineHeterogeneousMultitaskLearning/source/TextImage/data/similarity/pearson/%d', data_file));
%load(sprintf('%s','boats_toy_sim'));
%load(sprintf('%s','flowers_tree_sim'));
%load(sprintf('%s','vehicle_tree_sim'));
P_it = P_ti';
%=========================================

num_old = 50;
num_co = 1600;
num_new = 500;

%ID_old = randperm(num_old);
%for i = 1 : 100
    %ID_new(i,:) = randperm(num_new)+num_old;
%end

load('../ID');

Y_new = image_gnd(num_old+1 : num_old+num_new);
X_new = image_fea(num_old+1 : num_old+num_new,:);

Y_co = zeros(num_co, 1);
image_co = co_image_fea;
text_co = co_text_fea;

Y = [Y_co; Y_new];
X = [image_co; X_new];

%Y = image_gnd(1:num_old+num_new,:);
%Y = full(Y);
%X = image_fea(1:num_old+num_new,:);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%co-occurrence data
m_text = size(co_text_fea, 1);
n_text = m_text + size(text_fea, 1);

text_X = [text_fea; co_text_fea];
text_Y = [text_gnd; zeros(1600, 1)];

MaxX=max(text_X,[],2);
MinX=min(text_X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
text_X = bsxfun(@minus, text_X, MinX);
text_X = bsxfun(@rdivide, text_X , DifX_2);


P = sum(text_X.*text_X,2);
P = full(P);
%disp('Pre-computing kernel matrix...');
text_K1 = exp(-(repmat(P',n_text,1) + repmat(P,1,n_text)- 2*text_X*text_X')/(2*options.sigma^2));
%text_K1 = exp(-(repmat(P',n_text,1) + repmat(P,1,n_text)- 2*text_X*text_X')/(2*1^2));
%text_K1 = text_X*text_X';

text_fea2 = co_text_fea;
P2 = sum(text_fea2.*text_fea2,2);
P2 = full(P2);
text_K2 = exp(-(repmat(P2',m_text,1) + repmat(P2,1,m_text)- 2*text_fea2*text_fea2')/(2*options.sigma2^2));
%text_K2 = exp(-(repmat(P2',m_text,1) + repmat(P2,1,m_text)- 2*text_fea2*text_fea2')/(2*2^2));
%text_K2 = text_fea2*text_fea2';

[h_PA, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(text_gnd, text_K1, options, ID_text);
predicted_Y = predict_PA(text_K1, h_PA);
%predicted_Y = predict_knn(ctt, text_gnd, options);
text_Y(n_text-m_text+1 : n_text) = predicted_Y;
Y(1:num_co) = predicted_Y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
K1 = exp(-(repmat(P',n,1) + repmat(P,1,n)- 2*X*X')/(2*options.sigma^2));
%K1 = X*X';

X2 = X(n-m+1:n,:);
Y2 = Y(n-m+1:n);
P2 = sum(X2.*X2,2);
P2 = full(P2);
K2 = exp(-(repmat(P2',m,1) + repmat(P2,1,m)- 2*X2*X2')/(2*options.sigma2^2));
% K2 = X2*X2';


%ID_old_subset = ID_old;
ID_old_subset = ID_co;

P_it = P_it(num_old+1:num_old+num_new,:);

%% learn the old classifier
[h, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(Y, K1, options, ID_old_subset);

%fprintf(1,'The old classifier has %f support vectors\n',length(h.SV));
%% run experiments:

ID_new = ID_new - 50 + options.Number_old;

for i=1:size(ID_new,1),
   % fprintf(1,'running on the %d-th trial...\n',i);
    ID = ID_new(i, :);
    
    %1. PA-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1_s(Y2,K2,options,ID);
    nSV_PA1(i) = length(classifier.SV);
    err_PA1(i) = err_count;
    time_PA1(i) = run_time;
    mistakes_list_PA1(i,:) = mistakes;
    SVs_PA1(i,:) = SVs;
    TMs_PA1(i,:) = TMs;
    
    
    %2. HomOTL-I
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1_s(Y,K1,K2,options,ID,h);
    nSV_OTL_PA(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL_PA(i) = err_count;
    time_OTL_PA(i) = run_time;
    mistakes_list_OTL_PA(i,:) = mistakes;
    SVs_OTL_PA(i,:) = SVs;
    TMs_OTL_PA(i,:) = TMs;
    
    %3. HomOTL-II
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2_s(Y,K1,K2,options,ID,h);
    nSV_OTL2_PA(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2_PA(i) = err_count;
    time_OTL2_PA(i) = run_time;
    mistakes_list_OTL2_PA(i,:) = mistakes;
    SVs_OTL2_PA(i,:) = SVs;
    TMs_OTL2_PA(i,:) = TMs;
    
    %4. HomOTL-III
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL3_s(Y,K1,K2,options,ID,h);
    nSV_OTL3_PA(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL3_PA(i) = err_count;
    time_OTL3_PA(i) = run_time;
    mistakes_list_OTL3_PA(i,:) = mistakes;
    SVs_OTL3_PA(i,:) = SVs;
    TMs_OTL3_PA(i,:) = TMs;
    

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
    
    %7. OHT-fixed
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = OHT1f_s(Y2,K2,P_it,text_gnd,options,ID);
    nSV_OHT1f(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OHT1f(i) = err_count;
    time_OHT1f(i) = run_time;
    mistakes_list_OHT1f(i,:) = mistakes;
    SVs_OHT1f(i,:) = SVs;
    TMs_OHT1f(i,:) = TMs;
    
    %8. OHT-fixed
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = OHT2f_s(Y2,K2,P_it,text_gnd,options,ID);
    nSV_OHT2f(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OHT2f(i) = err_count;
    time_OHT2f(i) = run_time;
    mistakes_list_OHT2f(i,:) = mistakes;
    SVs_OHT2f(i,:) = SVs;
    TMs_OHT2f(i,:) = TMs;
    



end


stat_file = sprintf('stat/%s-stat', data_file);
%save(stat_file, 'nSV_OTL_PA', 'err_OTL_PA', 'time_OTL_PA', 'mistakes_list_OTL_PA', 'SVs_OTL_PA', 'TMs_OTL_PA', 'nSV_OTL2_PA', 'err_OTL2_PA', 'time_OTL2_PA', 'mistakes_list_OTL2_PA', 'SVs_OTL2_PA', 'TMs_OTL2_PA', 'nSV_OTL_knn', 'err_OTL_knn', 'time_OTL_knn', 'mistakes_list_OTL_knn', 'SVs_OTL_knn', 'TMs_OTL_knn', 'nSV_OTL2_knn', 'err_OTL2_knn', 'time_OTL2_knn', 'mistakes_list_OTL2_knn', 'SVs_OTL2_knn', 'TMs_OTL2_knn');
%save(stat_file, 'nSV_OTL_PA', 'err_OTL_PA', 'time_OTL_PA', 'mistakes_list_OTL_PA', 'SVs_OTL_PA', 'TMs_OTL_PA', 'nSV_OTL2_PA', 'err_OTL2_PA', 'time_OTL2_PA', 'mistakes_list_OTL2_PA', 'SVs_OTL2_PA', 'TMs_OTL2_PA');
save(stat_file, 'nSV_OTL_PA', 'err_OTL_PA', 'time_OTL_PA', 'mistakes_list_OTL_PA', 'SVs_OTL_PA', 'TMs_OTL_PA', 'nSV_OTL2_PA', 'err_OTL2_PA', 'time_OTL2_PA', 'mistakes_list_OTL2_PA', 'SVs_OTL2_PA', 'TMs_OTL2_PA', 'nSV_OTL3_PA', 'err_OTL3_PA', 'time_OTL3_PA', 'mistakes_list_OTL3_PA', 'SVs_OTL3_PA', 'TMs_OTL3_PA');
%save(stat_file, 'nSV_PA1', 'err_PA1', 'time_PA1', 'mistakes_list_PA1', 'SVs_PA1', 'TMs_PA1', 'nSV_OTL', 'err_OTL', 'time_OTL', 'mistakes_list_OTL', 'SVs_OTL', 'TMs_OTL', 'nSV_OTL2', 'err_OTL2', 'time_OTL2', 'mistakes_list_OTL2', 'SVs_OTL2', 'TMs_OTL2', 'nSV_OHT1', 'err_OHT1', 'time_OHT1', 'mistakes_list_OHT1', 'SVs_OHT1', 'TMs_OHT1', 'nSV_OHT2', 'err_OHT2', 'time_OHT2', 'mistakes_list_OHT2', 'SVs_OHT2', 'TMs_OHT2');

fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'number of mistakes,            size of support vectors,           cpu running time\n');
fprintf(1,'PA             %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_PA1)/m*100,  std(err_PA1)/m*100, mean(nSV_PA1), std(nSV_PA1), mean(time_PA1), std(time_PA1));
fprintf(1,'HomOTL_PA-I       %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL_PA)/m*100,  std(err_OTL_PA)/m*100, mean(nSV_OTL_PA), std(nSV_OTL_PA), mean(time_OTL_PA), std(time_OTL_PA));
fprintf(1,'HomOTL-II      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL2_PA)/m*100, std(err_OTL2_PA)/m*100, mean(nSV_OTL2_PA), std(nSV_OTL2_PA), mean(time_OTL2_PA), std(time_OTL2_PA));
fprintf(1,'HomOTL-III      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL3_PA)/m*100, std(err_OTL3_PA)/m*100, mean(nSV_OTL3_PA), std(nSV_OTL3_PA), mean(time_OTL3_PA), std(time_OTL3_PA));
fprintf(1,'OHT-I  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT1)/m*100,   std(err_OHT1)/m*100, mean(nSV_OHT1), std(nSV_OHT1), mean(time_OHT1), std(time_OHT1));
fprintf(1,'OHT-II  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT2)/m*100,   std(err_OHT2)/m*100, mean(nSV_OHT2), std(nSV_OHT2), mean(time_OHT2), std(time_OHT2));
fprintf(1,'OHT-I-fixed  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT1f)/m*100,   std(err_OHT1f)/m*100, mean(nSV_OHT1f), std(nSV_OHT1f), mean(time_OHT1f), std(time_OHT1f));
fprintf(1,'OHT-II-fixed  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT2f)/m*100,   std(err_OHT2f)/m*100, mean(nSV_OHT2f), std(nSV_OHT2f), mean(time_OHT2f), std(time_OHT2f));
%fprintf(1,'HomOTL_knn-I       %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL_knn)/m*100,  std(err_OTL_knn)/m*100, mean(nSV_OTL_knn), std(nSV_OTL_knn), mean(time_OTL_knn), std(time_OTL_knn));
%fprintf(1,'HomOTL-II      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL2_knn)/m*100, std(err_OTL2_knn)/m*100, mean(nSV_OTL2_knn), std(nSV_OTL2_knn), mean(time_OTL2_knn), std(time_OTL2_knn));
%fprintf(1,'Het             %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_Het)/m*100,  std(err_Het)/m*100, mean(nSV_Het), std(nSV_Het), mean(time_Het), std(time_Het));
%fprintf(1,'OHT-I  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT1)/m*100,   std(err_OHT1)/m*100, mean(nSV_OHT1), std(nSV_OHT1), mean(time_OHT1), std(time_OHT1));
%fprintf(1,'OHT-II  %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OHT2)/m*100,   std(err_OHT2)/m*100, mean(nSV_OHT2), std(nSV_OHT2), mean(time_OHT2), std(time_OHT2));
fprintf(1,'-------------------------------------------------------------------------------\n');

