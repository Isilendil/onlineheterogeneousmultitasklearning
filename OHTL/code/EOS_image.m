function  EOS_image(data_file)
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
similarity_method = 'pearson';
load(sprintf('../../TextImage/data/original/%d', data_file));
load('../../TextImage/data/ID');
load(sprintf('../../TextImage/data/similarity/%s/%d', similarity_method, data_file));

m = size(ID, 2);

% image data
image_Y = image_gnd(1:m,:);
image_Y = full(image_Y);
image_X = image_fea(1:m,:);
image_X = [image_X; co_image_fea];
[image_n, image_d] = size(image_X);

% text data
text_Y = text_gnd(1:m,:);
text_Y = full(text_Y);
text_X = text_fea(1:m,:);
text_X = [text_X; co_text_fea];
[text_n, text_d] = size(text_X);

% set parameters
options.C = 5;
%options.sigma_image = 4;
options.sigma_text = 4;
options.t_tick = round(size(ID,2)/10);
%options.K = 10;
options.m = m;

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
MaxX=max(image_X,[],2);
MinX=min(image_X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
image_X = bsxfun(@minus, image_X, MinX);
image_X = bsxfun(@rdivide, image_X , DifX_2);

MaxX=max(text_X,[],2);
MinX=min(text_X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
text_X = bsxfun(@minus, text_X, MinX);
text_X = bsxfun(@rdivide, text_X , DifX_2);

vector_S_image = 2 .^ [-10:10];

for iter = 1 : length(vector_S_image)
	options.sigma_image = vector_S_image(iter);


% kernel
P = sum(image_X.*image_X,2);
P = full(P);
image_kernel = exp(-(repmat(P',image_n,1) + repmat(P,1,image_n)- 2*image_X*image_X')/(2*options.sigma_image^2));
P = sum(text_X.*text_X,2);
P = full(P);
text_kernel = exp(-(repmat(P',text_n,1) + repmat(P,1,text_n)- 2*text_X*text_X')/(2*options.sigma_text^2));
%image_kernel = image_X * image_X';
%text_kernel = text_X * text_X';

%% run experiments:
for i=1:size(ID,1),
   % fprintf(1,'running on the %d-th trial...\n',i);
    id_list = ID(i, :);

		%1. personal model
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(image_Y,image_kernel,options,id_list);
    %[classifier, err_count, run_time, mistakes] = PA1_linear(image_X, image_Y,options,id_list);
    err_PA1(i) = err_count;
    time_PA1(i) = run_time;
    mistakes_list_PA1(i,:) = mistakes;
		nSV_PA1(i) = length(classifier.SV);
		SVs_PA1(i,:) = SVs;
		TMs_PA1(i,:) = TMs;

		
		%2. shared-loss model
    [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1_shared(image_Y,image_kernel,text_Y,text_kernel,options,id_list);
    %[classifier_image, err_count_image, mistakes_image, classifier_text, err_count_text, mistakes_text, run_time] = PA1_shared_linear(image_X, image_Y, text_X, text_Y,options,id_list);
    err_PA1_shared(i) = err_count;
    mistakes_list_PA1_shared(i,:) = mistakes;
    time_PA1_shared(i) = run_time;
		nSV_PA1_shared(i) = length(classifier.SV);
		SVs_PA1_shared(i,:) = SVs;
		TMs_PA1_shared(i,:) = TMs;


		%3. domain-specific (1) + optimization
		[classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = dso(image_kernel, image_Y, cii', text_kernel, text_Y, ctt', options, id_list);
		%[classifier_image, err_count_image, mistakes_image, classifier_text, err_count_text, mistakes_text, run_time] = dso_linear(image_X(1:m,:), image_Y, cii', co_image_fea, text_X(1:m,:), text_Y, ctt', co_text_fea, options, id_list);
    err_dso(i) = err_count;
    mistakes_list_dso(i,:) = mistakes;
    time_dso(i) = run_time;
		nSV_dso(i) = length(classifier.SV_1)+length(classifier.SV_2);
		SVs_dso(i,:) = SVs;
		TMs_dso(i,:) = TMs;
		

    %4. Heterogeneous Online Transfer Learning
		[classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HetOTL(image_Y, image_kernel, text_kernel, options, id_list, cii');
		err_HetOTL(i) = err_count;
		time_HetOTL(i) = run_time;
		mistakes_list_HetOTL(i,:) = mistakes;
		nSV_HetOTL(i) = length(classifier.SV1)+length(classifier.SV2);
		SVs_HetOTL(i,:) = SVs;
		TMs_HetOTL(i,:) = TMs;
		


    %5. Heterogeneous Online Transfer Learning Shared
		[classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HetOTL_shared(image_kernel, image_Y, cii', text_kernel, text_Y, ctt', options, id_list);
		err_HetOTL_shared(i) = err_count;
		time_HetOTL_shared(i) = run_time;
		mistakes_list_HetOTL_shared(i,:) = mistakes;
		nSV_HetOTL_shared(i) = length(classifier.SV1)+length(classifier.SV2);
		SVs_HetOTL_shared(i,:) = SVs;
		TMs_HetOTL_shared(i,:) = TMs;

    %6. PA1 feature
		[classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1_fea(image_Y, text_kernel, cii', options, id_list);
		err_PA1_fea(i) = err_count;
		time_PA1_fea(i) = run_time;
		mistakes_list_PA1_fea(i,:) = mistakes;
		nSV_PA1_fea(i) = length(classifier.SV);
		SVs_PA1_fea(i,:) = SVs;
		TMs_PA1_fea(i,:) = TMs;
    
    
end


stat_file = sprintf('../stat/eos_image/%d/%d-stat', iter, data_file);
save(stat_file, 'err_PA1', 'err_PA1_shared', 'err_dso', 'err_HetOTL', 'err_HetOTL_shared', 'err_PA1_fea', 'time_PA1', 'time_PA1_shared', 'time_dso', 'time_HetOTL', 'time_HetOTL_shared', 'time_PA1_fea', 'mistakes_list_PA1', 'mistakes_list_PA1_shared', 'mistakes_list_dso', 'mistakes_list_HetOTL', 'mistakes_list_HetOTL_shared', 'mistakes_list_PA1_fea', 'nSV_PA1', 'nSV_PA1_shared', 'nSV_dso', 'nSV_HetOTL', 'nSV_HetOTL_shared', 'nSV_PA1_fea', 'SVs_PA1', 'SVs_PA1_shared', 'SVs_dso', 'SVs_HetOTL', 'SVs_HetOTL_shared', 'SVs_PA1_fea', 'TMs_PA1', 'TMs_PA1_shared', 'TMs_dso', 'TMs_HetOTL', 'TMs_HetOTL_shared', 'TMs_PA1_fea');


fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'                  number of mistakes,        cpu running time\n');
fprintf(1,'PA1\t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1)/m*100,  std(err_PA1)/m*100, mean(time_PA1)/m*100, std(time_PA1));
fprintf(1,'PA1_shared \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_shared)/m*100,  std(err_PA1_shared)/m*100, mean(time_PA1_shared)/m*100, std(time_PA1_shared));
fprintf(1,'dso\t %.4f %.4f \t %.4f %.4f\n', mean(err_dso)/m*100,  std(err_dso)/m*100, mean(time_dso)/m*100, std(time_dso));
fprintf(1,'HetOTL\t %.4f %.4f \t %.4f %.4f\n', mean(err_HetOTL)/m*100,  std(err_HetOTL)/m*100, mean(time_HetOTL)/m*100, std(time_HetOTL));
fprintf(1,'HetOTL_shared\t %.4f %.4f \t %.4f %.4f\n', mean(err_HetOTL_shared)/m*100,  std(err_HetOTL_shared)/m*100, mean(time_HetOTL_shared)/m*100, std(time_HetOTL_shared));
fprintf(1,'PA1_fea\t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_fea)/m*100,  std(err_PA1_fea)/m*100, mean(time_PA1_fea)/m*100, std(time_PA1_fea));
fprintf(1,'-------------------------------------------------------------------------------\n');

end
