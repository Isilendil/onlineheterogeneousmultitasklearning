function  EOE()
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
data_file = 'en-ch';
similarity_method = 'pearson';
load('../data/original/en-ch');
load('../data/ID');
load('../data/similarity/pearson/en-ch');

m = size(ID, 2);

% CH data
CH_Y = CH_label(1:m,:);
CH_Y = full(CH_Y);
CH_X = CH_fea(1:m,:);
CH_X = [CH_X; co_CH_fea];
[CH_n, CH_d] = size(CH_X);

% EN data
EN_Y = EN_label(1:m,:);
EN_Y = full(EN_Y);
EN_X = EN_fea(1:m,:);
EN_X = [EN_X; co_EN_fea];
[EN_n, EN_d] = size(EN_X);

% set parameters
options.C = 5;
options.sigma = 8;
options.sigma2 = 4;
options.t_tick = round(size(ID,2)/10);
options.K = 10;
options.m = m;
options.eta = 0.01;

options.gamma_1_1 = 0.5;
options.gamma_2_1 = 0.5;
options.alpha_1_1 = 0.5;
options.alpha_2_1 = 0.5;

options.gamma_1_2 = 0.5;
options.gamma_2_2 = 0.5;
options.alpha_1_2 = 0.5;
options.alpha_2_2 = 0.5;

options.gamma1 = 1;
options.gamma2 = 1;

%%
% scale
MaxX=max(CH_X,[],2);
MinX=min(CH_X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
CH_X = bsxfun(@minus, CH_X, MinX);
CH_X = bsxfun(@rdivide, CH_X , DifX_2);

MaxX=max(EN_X,[],2);
MinX=min(EN_X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
EN_X = bsxfun(@minus, EN_X, MinX);
EN_X = bsxfun(@rdivide, EN_X , DifX_2);


% kernel
P = sum(CH_X.*CH_X,2);
P = full(P);
CH_kernel = exp(-(repmat(P',CH_n,1) + repmat(P,1,CH_n)- 2*CH_X*CH_X')/(2*options.sigma^2));
P = sum(EN_X.*EN_X,2);
P = full(P);
EN_kernel = exp(-(repmat(P',EN_n,1) + repmat(P,1,EN_n)- 2*EN_X*EN_X')/(2*options.sigma^2));
%CH_kernel = CH_X * CH_X';
%EN_kernel = EN_X * EN_X';

%=================================================
vector_e = 2 .^ [-10:0];
%=================================================

for iter = 1 : length(vector_e)
	options.eta = vector_e(iter);


%% run experiments:
for i=1:size(ID,1),
   % fprintf(1,'running on the %d-th trial...\n',i);
    id_list = ID(i, :);

		%1. personal model
    [classifier, err_count, run_time, mistakes] = PA1(CH_Y,CH_kernel,options,id_list);
    %[classifier, err_count, run_time, mistakes] = PA1_linear(CH_X, CH_Y,options,id_list);
    err_PA1_personal_CH(i) = err_count;
    time_PA1_personal_CH(i) = run_time;
    mistakes_list_PA1_personal_CH(i,:) = mistakes;

    [classifier, err_count, run_time, mistakes] = PA1(EN_Y,EN_kernel,options,id_list);
    %[classifier, err_count, run_time, mistakes] = PA1_linear(EN_X, EN_Y,options,id_list);
    err_PA1_personal_EN(i) = err_count;
    time_PA1_personal_EN(i) = run_time;
    mistakes_list_PA1_personal_EN(i,:) = mistakes;
		
		%2. shared-loss model
    [classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = PA1_shared(CH_Y,CH_kernel,EN_Y,EN_kernel,options,id_list);
    %[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = PA1_shared_linear(CH_X, CH_Y, EN_X, EN_Y,options,id_list);
    err_PA1_shared_CH(i) = err_count_CH;
    mistakes_list_PA1_shared_CH(i,:) = mistakes_CH;
    err_PA1_shared_EN(i) = err_count_EN;
    mistakes_list_PA1_shared_EN(i,:) = mistakes_EN;
    time_PA1_shared(i) = run_time;

		%3. domain-specific (1) + optimization
		[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = dso1(CH_kernel, CH_Y, ccc', EN_kernel, EN_Y, cee', options, id_list);
		%[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = dso1_linear(CH_X(1:m,:), CH_Y, ccc', co_CH_fea, EN_X(1:m,:), EN_Y, cee', co_EN_fea, options, id_list);
    err_dso1_CH(i) = err_count_CH;
    mistakes_list_dso1_CH(i,:) = mistakes_CH;
    err_dso1_EN(i) = err_count_EN;
    mistakes_list_dso1_EN(i,:) = mistakes_EN;
    time_dso1(i) = run_time;
		
		%4. PA1_extra
		[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = PA1_extra(CH_kernel, CH_Y, ccc', EN_kernel, EN_Y, cee', options, id_list);
    err_PA1_extra_CH(i) = err_count_CH;
    mistakes_list_PA1_extra_CH(i,:) = mistakes_CH;
    err_PA1_extra_EN(i) = err_count_EN;
    mistakes_list_PA1_extra_EN(i,:) = mistakes_EN;
    time_PA1_extra(i) = run_time;

		%5. PA1_extra_sim
		[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = PA1_extra_sim(CH_kernel, CH_Y, ccc', EN_kernel, EN_Y, cee', options, id_list);
    err_PA1_extra_sim_CH(i) = err_count_CH;
    mistakes_list_PA1_extra_sim_CH(i,:) = mistakes_CH;
    err_PA1_extra_sim_EN(i) = err_count_EN;
    mistakes_list_PA1_extra_sim_EN(i,:) = mistakes_EN;
    time_PA1_extra_sim(i) = run_time;
		
		%6. latent + optimization
		%[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = lo(CH_Y, CH_kernel, EN_Y, EN_kernel, options, id_list);
    %err_lo_CH(i) = err_count_CH;
    %mistakes_list_lo_CH(i,:) = mistakes_CH;
    %err_lo_EN(i) = err_count_EN;
    %mistakes_list_lo_EN(i,:) = mistakes_EN;
    %time_lo(i) = run_time;
		
		%7. Online Gradient Descent algorithm
    [classifier, err_count, run_time, mistakes] = OGD(CH_Y, CH_kernel, options, id_list);
		err_OGD_personal_CH(i) = err_count;
		time_OGD_personal_CH(i) = run_time;
		mistakes_list_OGD_personal_CH(i,:) = mistakes;

    [classifier, err_count, run_time, mistakes] = OGD(EN_Y, EN_kernel, options, id_list);
		err_OGD_personal_EN(i) = err_count;
		time_OGD_personal_EN(i) = run_time;
		mistakes_list_OGD_personal_EN(i,:) = mistakes;

    %8. Heterogeneous Online Transfer Learning
		[classifier, err_count, run_time, mistakes] = HetOTL(CH_Y, CH_kernel, EN_kernel, options, id_list, ccc');
		err_HetOTL_CH(i) = err_count;
		time_HetOTL_CH(i) = run_time;
		mistakes_list_HetOTL_CH(i,:) = mistakes;

		[classifier, err_count, run_time, mistakes] = HetOTL(EN_Y, EN_kernel, CH_kernel, options, id_list, cee');
		err_HetOTL_EN(i) = err_count;
		time_HetOTL_EN(i) = run_time;
		mistakes_list_HetOTL_EN(i,:) = mistakes;

    %9. Heterogeneous Online Transfer Learning Shared
		[classifier_1, err_count_1, mistakes_1, classifier_2, err_count_2, mistakes_2, run_time] = HetOTL_shared(CH_kernel, CH_Y, ccc', EN_kernel, EN_Y, cee', options, id_list);
		err_HetOTL_shared_CH(i) = err_count_1;
		time_HetOTL_shared_CH(i) = run_time;
		mistakes_list_HetOTL_shared_CH(i,:) = mistakes_1;
		err_HetOTL_shared_EN(i) = err_count_2;
		time_HetOTL_shared_EN(i) = run_time;
		mistakes_list_HetOTL_shared_EN(i,:) = mistakes_2;

    %10. PA1 feature
		[classifier, err_count, run_time, mistakes] = PA1_fea(CH_Y, EN_kernel, ccc', options, id_list);
		err_PA1_fea_CH(i) = err_count;
		time_PA1_fea_CH(i) = run_time;
		mistakes_list_PA1_fea_CH(i,:) = mistakes;

		[classifier, err_count, run_time, mistakes] = PA1_fea(EN_Y, CH_kernel, cee', options, id_list);
		err_PA1_fea_EN(i) = err_count;
		time_PA1_fea_EN(i) = run_time;
		mistakes_list_PA1_fea_EN(i,:) = mistakes;


		%7. domain-specific (2) + latent + optimization
		%[classifier_CH, err_count_CH, mistakes_CH, classifier_EN, err_count_EN, mistakes_EN, run_time] = dslo2(CH_Y, CH_kernel, EN_Y, EN_kernel, options, id_list);
    %err_dslo2_CH(i) = err_count_CH;
    %mistakes_list_dslo2_CH(i,:) = mistakes_CH;
    %err_dslo2_EN(i) = err_count_EN;
    %mistakes_list_dslo2_EN(i,:) = mistakes_EN;
    %time_dslo2(i) = run_time;
		
    
    %1. PA-I
    %[classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y2,K2,options,ID);
    %nSV_PA1(i) = length(classifier.SV);
    %err_PA1(i) = err_count;
    %time_PA1(i) = run_time;
    %mistakes_list_PA1(i,:) = mistakes;
    %SVs_PA1(i,:) = SVs;
    %TMs_PA1(i,:) = TMs;
    
    
end


stat_file = sprintf('../stat/%s/en-ch-stat', similarity_method);
save(stat_file, 'err_PA1_personal_CH', 'time_PA1_personal_CH', 'mistakes_list_PA1_personal_CH', 'err_PA1_personal_EN', 'time_PA1_personal_EN', 'mistakes_list_PA1_personal_EN', 'err_OGD_personal_CH', 'time_OGD_personal_CH', 'mistakes_list_OGD_personal_CH', 'err_OGD_personal_EN', 'time_OGD_personal_EN', 'mistakes_list_OGD_personal_EN', 'err_PA1_shared_CH', 'mistakes_list_PA1_shared_CH', 'err_PA1_shared_EN', 'mistakes_list_PA1_shared_EN', 'time_PA1_shared', 'err_dso1_CH', 'mistakes_list_dso1_CH', 'err_dso1_EN', 'time_dso1', 'mistakes_list_dso1_EN', 'err_PA1_extra_CH', 'mistakes_list_PA1_extra_CH', 'err_PA1_extra_EN', 'time_PA1_extra', 'mistakes_list_PA1_extra_EN', 'err_PA1_extra_sim_CH', 'mistakes_list_PA1_extra_sim_CH', 'err_PA1_extra_sim_EN', 'mistakes_list_PA1_extra_sim_EN', 'time_PA1_extra_sim', 'err_HetOTL_CH', 'time_HetOTL_CH', 'mistakes_list_HetOTL_CH', 'err_HetOTL_EN', 'time_HetOTL_EN', 'mistakes_list_HetOTL_EN', 'err_HetOTL_shared_CH', 'time_HetOTL_shared_CH', 'mistakes_list_HetOTL_shared_CH', 'err_HetOTL_shared_EN', 'time_HetOTL_shared_EN', 'mistakes_list_HetOTL_shared_EN', 'err_PA1_fea_CH', 'time_PA1_fea_CH', 'mistakes_list_PA1_fea_CH', 'err_PA1_fea_EN', 'time_PA1_fea_EN', 'mistakes_list_PA1_fea_EN');

fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'                  number of mistakes,        cpu running time\n');
fprintf(1,'PA1_personal_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_personal_CH)/m*100,  std(err_PA1_personal_CH)/m*100, mean(time_PA1_personal_CH)/m*100, std(time_PA1_personal_CH));
fprintf(1,'PA1_personal_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_personal_EN)/m*100,  std(err_PA1_personal_EN)/m*100, mean(time_PA1_personal_EN)/m*100, std(time_PA1_personal_EN));
fprintf(1,'PA1_shared_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_shared_CH)/m*100,  std(err_PA1_shared_CH)/m*100, mean(time_PA1_shared)/m*100, std(time_PA1_shared));
fprintf(1,'PA1_shared_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_shared_EN)/m*100,  std(err_PA1_shared_EN)/m*100, mean(time_PA1_shared)/m*100, std(time_PA1_shared));
fprintf(1,'dso1_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_dso1_CH)/m*100,  std(err_dso1_CH)/m*100, mean(time_dso1)/m*100, std(time_dso1));
fprintf(1,'dso1_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_dso1_EN)/m*100,  std(err_dso1_EN)/m*100, mean(time_dso1)/m*100, std(time_dso1));
fprintf(1,'PA1_extra_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_extra_CH)/m*100,  std(err_PA1_extra_CH)/m*100, mean(time_PA1_extra)/m*100, std(time_PA1_extra));
fprintf(1,'PA1_extra_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_extra_EN)/m*100,  std(err_PA1_extra_EN)/m*100, mean(time_PA1_extra)/m*100, std(time_PA1_extra));
fprintf(1,'PA1_extra_sim_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_extra_sim_CH)/m*100,  std(err_PA1_extra_sim_CH)/m*100, mean(time_PA1_extra_sim)/m*100, std(time_PA1_extra_sim));
fprintf(1,'PA1_extra_sim_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_extra_sim_EN)/m*100,  std(err_PA1_extra_sim_EN)/m*100, mean(time_PA1_extra_sim)/m*100, std(time_PA1_extra_sim));
fprintf(1,'OGD_personal_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_OGD_personal_CH)/m*100,  std(err_OGD_personal_CH)/m*100, mean(time_OGD_personal_CH)/m*100, std(time_OGD_personal_CH));
fprintf(1,'OGD_personal_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_OGD_personal_EN)/m*100,  std(err_OGD_personal_EN)/m*100, mean(time_OGD_personal_EN)/m*100, std(time_OGD_personal_EN));
fprintf(1,'HetOTL_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_HetOTL_CH)/m*100,  std(err_HetOTL_CH)/m*100, mean(time_HetOTL_CH)/m*100, std(time_HetOTL_CH));
fprintf(1,'HetOTL_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_HetOTL_EN)/m*100,  std(err_HetOTL_EN)/m*100, mean(time_HetOTL_EN)/m*100, std(time_HetOTL_EN));
fprintf(1,'HetOTL_shared_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_HetOTL_shared_CH)/m*100,  std(err_HetOTL_shared_CH)/m*100, mean(time_HetOTL_shared_CH)/m*100, std(time_HetOTL_shared_CH));
fprintf(1,'HetOTL_shared_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_HetOTL_shared_EN)/m*100,  std(err_HetOTL_shared_EN)/m*100, mean(time_HetOTL_shared_EN)/m*100, std(time_HetOTL_shared_EN));
fprintf(1,'PA1_fea_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_fea_CH)/m*100,  std(err_PA1_fea_CH)/m*100, mean(time_PA1_fea_CH)/m*100, std(time_PA1_fea_CH));
fprintf(1,'PA1_fea_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_fea_EN)/m*100,  std(err_PA1_fea_EN)/m*100, mean(time_PA1_fea_EN)/m*100, std(time_PA1_fea_EN));
%fprintf(1,'dso2_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_dso2_CH)/m*100,  std(err_dso2_CH)/m*100, mean(time_dso2_CH)/m*100, std(time_dso2_CH));
%fprintf(1,'dso2_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_dso2_EN)/m*100,  std(err_dso2_EN)/m*100, mean(time_dso2_EN)/m*100, std(time_dso2_EN));
%fprintf(1,'lo_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_lo_CH)/m*100,  std(err_lo_CH)/m*100, mean(time_lo_CH)/m*100, std(time_lo_CH));
%fprintf(1,'lo_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_lo_EN)/m*100,  std(err_lo_EN)/m*100, mean(time_lo_EN)/m*100, std(time_lo_EN));
%fprintf(1,'dslo1_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_dslo1_CH)/m*100,  std(err_dslo1_CH)/m*100, mean(time_dslo1_CH)/m*100, std(time_dslo1_CH));
%fprintf(1,'dslo1_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_dslo1_EN)/m*100,  std(err_dslo1_EN)/m*100, mean(time_dslo1_EN)/m*100, std(time_dslo1_EN));
%fprintf(1,'dslo2_CH \t %.4f %.4f \t %.4f %.4f\n', mean(err_dslo2_CH)/m*100,  std(err_dslo2_CH)/m*100, mean(time_dslo2_CH)/m*100, std(time_dslo2_CH));
%fprintf(1,'dslo2_EN \t %.4f %.4f \t %.4f %.4f\n', mean(err_dslo2_EN)/m*100,  std(err_dslo2_EN)/m*100, mean(time_dslo2_EN)/m*100, std(time_dslo2_EN));
fprintf(1,'-------------------------------------------------------------------------------\n');


end
