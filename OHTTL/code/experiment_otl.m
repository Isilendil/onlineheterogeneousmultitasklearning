function  experiment_otl()

for data_file = 1 : 4


%load dataset
load(sprintf('../../otl/original/%d', data_file));
%load(sprintf('../../otl/similarity/cosin/%d', data_file));
load(sprintf('sourcecodata/otl/%d', data_file));

load('tool/ID_otl');


% data
X_source = co_X_target;
Y_source_knn = co_Y_knn;
Y_source_pa = co_Y_pa;
%Y_source_svm = co_Y_svm;
%Y_source_tsvm = co_Y_tsvm;


X = [X_source; X_target];

n_source = size(X_source, 1);
n_target = size(X_target, 1);

% set parameters
options.C   = 5;
options.sigma = 4;
options.sigma2 = 8;
options.t_tick = round(n_target / 10);
options.n_source = n_source;
options.beta=sqrt(n_target)/(sqrt(n_target)+sqrt(2*log(2)));


% scale
MaxX=max(X,[],2);
MinX=min(X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
X = bsxfun(@minus, X, MinX);
X = bsxfun(@rdivide, X , DifX_2);

X_source = X(1:n_source, :);
X_target = X(n_source+1:end, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = sum(X.*X,2);
P = full(P);
K = exp(-(repmat(P',n_source+n_target,1) + repmat(P,1,n_source+n_target)- 2*X*X')/(2*options.sigma^2));
%K = X*X';

P_target = sum(X_target.*X_target,2);
P_target = full(P_target);
K_target = exp(-(repmat(P_target',n_target,1) + repmat(P_target,1,n_target)- 2*X_target*X_target')/(2*options.sigma2^2));
%K_target = X_target*X_target';

%{
load(sprintf('../../TextImage/data/feature_HTLIC/%d', data_file));
X_htlic = image_fea_HTLIC;
P_htlic = sum(X_htlic.*X_htlic,2);
P_htlic = full(P_htlic);
%K_htlic = exp(-(repmat(P_htlic',n_target,1) + repmat(P_htlic,1,n_target)- 2*X_htlic*X_htlic')/(2*options.sigma2^2));
K_htlic = X_htlic * X_htlic';

load(sprintf('../../TextImage/data/feature_het/%d', data_file));
X_het = image_fea_het;
P_het = sum(X_het.*X_het,2);
P_het = full(P_het);
%K_het = exp(-(repmat(P_het',n_target,1) + repmat(P_het,1,n_target)- 2*X_het*X_het')/(2*options.sigma2^2));
K_het = X_het * X_het';

load(sprintf('../../TextImage/data/feature_PCA/%d', data_file));
X_pca = feature_pca;
P_pca = sum(X_pca.*X_pca,2);
P_pca = full(P_pca);
%K_pca = exp(-(repmat(P_pca',n_target,1) + repmat(P_pca,1,n_target)- 2*X_pca*X_pca')/(2*options.sigma2^2));
K_pca = X_pca * X_pca';
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% learn the old classifier

[h_pa, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(Y_source_pa, K, options, ID_old);
%[h_svm, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(Y_source_svm, K, options, ID_old);
%[h_tsvm, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(Y_source_tsvm, K, options, ID_old);
[h_knn, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = avePA1_K_M(Y_source_knn, K, options, ID_old);

%fprintf(1,'The old classifier has %f support vectors\n',length(h.SV));
%% run experiments:

for i = 1 : size(ID,1),
   % fprintf(1,'running on the %d-th trial...\n',i);
    id_list = ID(i, :);
    
    %1. PA
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y_target,K_target,options,id_list);
    nSV_pa(i) = length(classifier.SV);
    err_pa(i) = err_count;
    time_pa(i) = run_time;
    mistakes_list_pa(i,:) = mistakes;
    SVs_pa(i,:) = SVs;
    TMs_pa(i,:) = TMs;
    
    %{
    %2. HTLIC
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y_target,K_htlic,options,id_list);
    nSV_htlic(i) = length(classifier.SV);
    err_htlic(i) = err_count;
    time_htlic(i) = run_time;
    mistakes_list_htlic(i,:) = mistakes;
    SVs_htlic(i,:) = SVs;
    TMs_htlic(i,:) = TMs;
    
    %3. Het_feature
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y_target,K_het,options,id_list);
    nSV_het(i) = length(classifier.SV);
    err_het(i) = err_count;
    time_het(i) = run_time;
    mistakes_list_het(i,:) = mistakes;
    SVs_het(i,:) = SVs;
    TMs_het(i,:) = TMs;
    
    %4. PCA
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y_target,K_pca,options,id_list);
    nSV_pca(i) = length(classifier.SV);
    err_pca(i) = err_count;
    time_pca(i) = run_time;
    mistakes_list_pca(i,:) = mistakes;
    SVs_pca(i,:) = SVs;
    TMs_pca(i,:) = TMs;
    %}
    
    
    %5. HomOTL-I-PA
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1(Y_target,K,K_target,options,id_list,h_pa);
    nSV_OTL_pa(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL_pa(i) = err_count;
    time_OTL_pa(i) = run_time;
    mistakes_list_OTL_pa(i,:) = mistakes;
    SVs_OTL_pa(i,:) = SVs;
    TMs_OTL_pa(i,:) = TMs;
    
    %6. HomOTL-II-PA
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2(Y_target,K,K_target,options,id_list,h_pa);
    nSV_OTL2_pa(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2_pa(i) = err_count;
    time_OTL2_pa(i) = run_time;
    mistakes_list_OTL2_pa(i,:) = mistakes;
    SVs_OTL2_pa(i,:) = SVs;
    TMs_OTL2_pa(i,:) = TMs;
    


    %{
    %7. HomOTL-I-SVM
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1(Y_target,K,K_target,options,id_list,h_svm);
    nSV_OTL_svm(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL_svm(i) = err_count;
    time_OTL_svm(i) = run_time;
    mistakes_list_OTL_svm(i,:) = mistakes;
    SVs_OTL_svm(i,:) = SVs;
    TMs_OTL_svm(i,:) = TMs;
    
    %8. HomOTL-II-SVM
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2(Y_target,K,K_target,options,id_list,h_svm);
    nSV_OTL2_svm(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2_svm(i) = err_count;
    time_OTL2_svm(i) = run_time;
    mistakes_list_OTL2_svm(i,:) = mistakes;
    SVs_OTL2_svm(i,:) = SVs;
    TMs_OTL2_svm(i,:) = TMs;
    


    %9. HomOTL-I-TSVM
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1(Y_target,K,K_target,options,id_list,h_tsvm);
    nSV_OTL_tsvm(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL_tsvm(i) = err_count;
    time_OTL_tsvm(i) = run_time;
    mistakes_list_OTL_tsvm(i,:) = mistakes;
    SVs_OTL_tsvm(i,:) = SVs;
    TMs_OTL_tsvm(i,:) = TMs;
    
    %10. HomOTL-II-TSVM
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2(Y_target,K,K_target,options,id_list,h_tsvm);
    nSV_OTL2_tsvm(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2_tsvm(i) = err_count;
    time_OTL2_tsvm(i) = run_time;
    mistakes_list_OTL2_tsvm(i,:) = mistakes;
    SVs_OTL2_tsvm(i,:) = SVs;
    TMs_OTL2_tsvm(i,:) = TMs;
    %}
    


    %11. HomOTL-I-KNN
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1(Y_target,K,K_target,options,id_list,h_knn);
    nSV_OTL_knn(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL_knn(i) = err_count;
    time_OTL_knn(i) = run_time;
    mistakes_list_OTL_knn(i,:) = mistakes;
    SVs_OTL_knn(i,:) = SVs;
    TMs_OTL_knn(i,:) = TMs;
    
    %12. HomOTL-II-KNN
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL2(Y_target,K,K_target,options,id_list,h_knn);
    nSV_OTL2_knn(i) = length(classifier.SV1)+length(classifier.SV2);
    err_OTL2_knn(i) = err_count;
    time_OTL2_knn(i) = run_time;
    mistakes_list_OTL2_knn(i,:) = mistakes;
    SVs_OTL2_knn(i,:) = SVs;
    TMs_OTL2_knn(i,:) = TMs;
    


end


stat_file = sprintf('../stat/otl/%d', data_file);
save(stat_file, 'nSV_pa', 'err_pa', 'time_pa', 'mistakes_list_pa', 'SVs_pa', 'TMs_pa', 'nSV_OTL_knn', 'err_OTL_knn', 'time_OTL_knn', 'mistakes_list_OTL_knn', 'SVs_OTL_knn', 'TMs_OTL_knn', 'nSV_OTL2_knn', 'err_OTL2_knn', 'time_OTL2_knn', 'mistakes_list_OTL2_knn', 'SVs_OTL2_knn', 'TMs_OTL2_knn', 'nSV_OTL_pa', 'err_OTL_pa', 'time_OTL_pa', 'mistakes_list_OTL_pa', 'SVs_OTL_pa', 'TMs_OTL_pa', 'nSV_OTL2_pa', 'err_OTL2_pa', 'time_OTL2_pa', 'mistakes_list_OTL2_pa', 'SVs_OTL2_pa', 'TMs_OTL2_pa');

%{
'nSV_pa', 'err_pa', 'time_pa', 'mistakes_list_pa', 'SVs_pa', 'TMs_pa', 
'nSV_OTL_knn', 'err_OTL_knn', 'time_OTL_knn', 'mistakes_list_OTL_knn', 'SVs_OTL_knn', 'TMs_OTL_knn', 
'nSV_OTL2_knn', 'err_OTL2_knn', 'time_OTL2_knn', 'mistakes_list_OTL2_knn', 'SVs_OTL2_knn', 'TMs_OTL2_knn', 
'nSV_OTL_pa', 'err_OTL_pa', 'time_OTL_pa', 'mistakes_list_OTL_pa', 'SVs_OTL_pa', 'TMs_OTL_pa', 
'nSV_OTL2_pa', 'err_OTL2_pa', 'time_OTL2_pa', 'mistakes_list_OTL2_pa', 'SVs_OTL2_pa', 'TMs_OTL2_pa', 
%}



m = n_target;

fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'number of mistakes,            size of support vectors,           cpu running time\n');
fprintf(1,'pa             %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_pa)/m*100,  std(err_pa)/m*100, mean(nSV_pa), std(nSV_pa), mean(time_pa), std(time_pa));
fprintf(1,'HomOTL_PA       %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL_pa)/m*100,  std(err_OTL_pa)/m*100, mean(nSV_OTL_pa), std(nSV_OTL_pa), mean(time_OTL_pa), std(time_OTL_pa));
fprintf(1,'HomOTL2_PA      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL2_pa)/m*100, std(err_OTL2_pa)/m*100, mean(nSV_OTL2_pa), std(nSV_OTL2_pa), mean(time_OTL2_pa), std(time_OTL2_pa));
fprintf(1,'HomOTL_KNN       %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL_knn)/m*100,  std(err_OTL_knn)/m*100, mean(nSV_OTL_knn), std(nSV_OTL_knn), mean(time_OTL_knn), std(time_OTL_knn));
fprintf(1,'HomOTL2_KNN      %.4f \t %.4f \t %.4f \t %.4f \t %.4f \t %.4f\n', mean(err_OTL2_knn)/m*100, std(err_OTL2_knn)/m*100, mean(nSV_OTL2_knn), std(nSV_OTL2_knn), mean(time_OTL2_knn), std(time_OTL2_knn));
fprintf(1,'-------------------------------------------------------------------------------\n');


end
