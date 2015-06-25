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
similarity_method = 'pearson';
load(sprintf('data/original/%s', data_file));
load(sprintf('data/similarity/%s/%s', similarity_method, similarity_file));
load('data/ID');

m = size(ID, 2);

% image data
image_Y = image_gnd(1:m,:);
image_Y = full(image_Y);
image_X = image_fea(1:m,:);
[image_n, image_d] = size(image_X);

% text data
text_Y = text_gnd(1:m,:);
text_Y = full(text_Y);
text_X = text_fea(1:m,:);
[text_n, text_d] = size(text_X);

% set parameters
options.C = 5;
options.sigma = 4;
options.sigma2 = 8;
options.t_tick = round(size(ID,2)/10);
options.K = 100;

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


% kernel
P = sum(image_X.*image_X,2);
P = full(P);
image_kernel = exp(-(repmat(P',image_n,1) + repmat(P,1,image_n)- 2*image_X*image_X')/(2*options.sigma^2));
P = sum(text_X.*text_X,2);
P = full(P);
text_kernel = exp(-(repmat(P',text_n,1) + repmat(P,1,text_n)- 2*text_X*text_X')/(2*options.sigma^2));
%iamge_kernel = image_X * image_X';
%text_kernel = text_X * text_X';

%% run experiments:
for i=1:size(ID,1),
   % fprintf(1,'running on the %d-th trial...\n',i);
    id_list = ID(i, :);

		%1. personal model
    [classifier, err_count, run_time, mistakes] = PA1(image_Y,image_kernel,options,id_list);
    err_PA1_personal_image(i) = err_count;
    time_PA1_personal_image(i) = run_time;
    mistakes_list_PA1_personal_image(i,:) = mistakes;

    [classifier, err_count, run_time, mistakes] = PA1(text_Y,text_kernel,options,id_list);
    err_PA1_personal_text(i) = err_count;
    time_PA1_personal_text(i) = run_time;
    mistakes_list_PA1_personal_text(i,:) = mistakes;
		
		%2. shared-loss model
    [classifier_image, err_count_image, mistakes_image, classifier_text, err_count_text, mistakes_text, run_time] = PA1_shared(image_Y,image_kernel,text_Y,text_kernel,options,id_list);
    err_PA1_shared_image(i) = err_count_image;
    mistakes_list_PA1_shared_image(i,:) = mistakes_image;
    err_PA1_shared_text(i) = err_count_text;
    mistakes_list_PA1_shared_text(i,:) = mistakes_text;
    time_PA1_shared(i) = run_time;

		%3. domain-specific (1) + optimization
		
		%4. domain-specific (2) + optimization

		%5. latent + optimization
		
		%6. domain-specific (1) + latent + optimization

		%7. domain-specific (2) + latent + optimization
		
    
    %1. PA-I
    %[classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = PA1(Y2,K2,options,ID);
    %nSV_PA1(i) = length(classifier.SV);
    %err_PA1(i) = err_count;
    %time_PA1(i) = run_time;
    %mistakes_list_PA1(i,:) = mistakes;
    %SVs_PA1(i,:) = SVs;
    %TMs_PA1(i,:) = TMs;
    
    
end


stat_file = sprintf('stat/%s/%s-stat', similarity_method, data_file);
save(stat_file, 'err_PA1_personal_image', 'time_PA1_personal_image', 'mistakes_list_PA1_personal_image', 'err_PA1_personal_text', 'time_PA1_personal_text', 'mistakes_list_PA1_personal_text');

fprintf(1,'-------------------------------------------------------------------------------\n');
fprintf(1,'                  number of mistakes,        cpu running time\n');
fprintf(1,'PA1_personal_image \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_personal_image)/m*100,  std(err_PA1_personal_image)/m*100, mean(time_PA1_personal_image), std(time_PA1_personal_image));
fprintf(1,'PA1_personal_text \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_personal_text)/m*100,  std(err_PA1_personal_text)/m*100, mean(time_PA1_personal_text), std(time_PA1_personal_text));
fprintf(1,'PA1_shared_image \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_shared_image)/m*100,  std(err_PA1_shared_image)/m*100, mean(time_PA1_shared), std(time_PA1_shared));
fprintf(1,'PA1_shared_text \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_shared_text)/m*100,  std(err_PA1_shared_text)/m*100, mean(time_PA1_shared), std(time_PA1_shared));
%fprintf(1,'PA1_personal_image \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_personal_image)/m*100,  std(err_PA1_personal_image)/m*100, mean(time_PA1_personal_image), std(time_PA1_personal_image));
%fprintf(1,'PA1_personal_image \t %.4f %.4f \t %.4f %.4f\n', mean(err_PA1_personal_image)/m*100,  std(err_PA1_personal_image)/m*100, mean(time_PA1_personal_image), std(time_PA1_personal_image));
fprintf(1,'-------------------------------------------------------------------------------\n');

