
function error_process(directory)

%directory = {'eoc', 'eos_image', 'eos_text'}

m = 500;

for iter = 1 : 21

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error_final
mean_error_final_vector_PA = [];
std_error_final_vector_PA = [];

mean_error_final_vector_HTLIC_online = [];
std_error_final_vector_HTLIC_online = [];

mean_error_final_vector_PA_SL = [];
std_error_final_vector_PA_SL = [];

mean_error_final_vector_HetOTL = [];
std_error_final_vector_HetOTL = [];

mean_error_final_vector_HetOTL_SL = [];
std_error_final_vector_HetOTL_SL = [];

mean_error_final_vector_PA_NV = [];
std_error_final_vector_PA_NV = [];

mean_error_final_vector_PA_MV = [];
std_error_final_vector_PA_MV = [];

mean_error_final_vector_OTLHS = [];
std_error_final_vector_OTLHS = [];


%file_error_final_table = fopen(sprintf('../process_result/%s/%d/error_final_table', directory, iter), 'w');
%fprintf(file_error_final_table, 'Task \t PA \t PA_SL \t HetOTL \t HetOTL_SL \t PA_NV \t OTLHS \n');
%fprintf(file_error_final_table, 'Task \t PA \t HTLIC_online \t PA_SL \t HetOTL \t HetOTL_SL \t PA_NV \t PA_MV \t OTLHS \n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mistakes list
mean_mistake_list_matrix_PA = [];
std_mistake_list_matrix_PA = [];

mean_mistake_list_matrix_HTLIC_online = [];
std_mistake_list_matrix_HTLIC_online = [];

mean_mistake_list_matrix_PA_SL = [];
std_mistake_list_matrix_PA_SL = [];

mean_mistake_list_matrix_HetOTL = [];
std_mistake_list_matrix_HetOTL = [];

mean_mistake_list_matrix_HetOTL_SL = [];
std_mistake_list_matrix_HetOTL_SL = [];

mean_mistake_list_matrix_PA_NV = [];
std_mistake_list_matrix_PA_NV = [];

mean_mistake_list_matrix_PA_MV = [];
std_mistake_list_matrix_PA_MV = [];

mean_mistake_list_matrix_OTLHS = [];
std_mistake_list_matrix_OTLHS = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i = 1 : 45
  load(sprintf('../%s/%d/%d-stat', directory, iter, i));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% error final
  mean_error_final_vector_PA = [mean_error_final_vector_PA, mean(err_PA1)/m*100];
	std_error_final_vector_PA = [std_error_final_vector_PA, std(err_PA1)/m*100];

  %mean_error_final_vector_HTLIC_online = [mean_error_final_vector_HTLIC_online, mean(err_HTLIC_online)/m*100];
	%std_error_final_vector_HTLIC_online = [std_error_final_vector_HTLIC_online, std(err_HTLIC_online)/m*100];

  mean_error_final_vector_PA_SL = [mean_error_final_vector_PA_SL, mean(err_PA1_shared)/m*100];
	std_error_final_vector_PA_SL = [std_error_final_vector_PA_SL, std(err_PA1_shared)/m*100];

  mean_error_final_vector_HetOTL = [mean_error_final_vector_HetOTL, mean(err_HetOTL)/m*100];
	std_error_final_vector_HetOTL = [std_error_final_vector_HetOTL, std(err_HetOTL)/m*100];

  mean_error_final_vector_HetOTL_SL = [mean_error_final_vector_HetOTL_SL, mean(err_HetOTL_shared)/m*100];
	std_error_final_vector_HetOTL_SL = [std_error_final_vector_HetOTL_SL, std(err_HetOTL_shared)/m*100];

  mean_error_final_vector_PA_NV = [mean_error_final_vector_PA_NV, mean(err_PA1_fea)/m*100];
	std_error_final_vector_PA_NV = [std_error_final_vector_PA_NV, std(err_PA1_fea)/m*100];

  %mean_error_final_vector_PA_MV = [mean_error_final_vector_PA_MV, mean(err_PA_MV1)/m*100];
	%std_error_final_vector_PA_MV = [std_error_final_vector_PA_MV, std(err_PA_MV1)/m*100];

  mean_error_final_vector_OTLHS = [mean_error_final_vector_OTLHS, mean(err_dso)/m*100];
	std_error_final_vector_OTLHS = [std_error_final_vector_OTLHS, std(err_dso)/m*100];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % mistakes list
  mean_mistake_list_matrix_PA = [mean_mistake_list_matrix_PA; mean(mistakes_list_PA1)];
	std_mistake_list_matrix_PA = [std_mistake_list_matrix_PA; std(mistakes_list_PA1)];

  %mean_mistake_list_matrix_HTLIC_online = [mean_mistake_list_matrix_HTLIC_online; mean(mistakes_list_HTLIC_online1)];
	%std_mistake_list_matrix_HTLIC_online = [std_mistake_list_matrix_HTLIC_online; std(mistakes_list_HTLIC_online1)];

  mean_mistake_list_matrix_PA_SL = [mean_mistake_list_matrix_PA_SL; mean(mistakes_list_PA1_shared)];
	std_mistake_list_matrix_PA_SL = [std_mistake_list_matrix_PA_SL; std(mistakes_list_PA1_shared)];

  mean_mistake_list_matrix_HetOTL = [mean_mistake_list_matrix_HetOTL; mean(mistakes_list_HetOTL(:,4:13))];
	std_mistake_list_matrix_HetOTL = [std_mistake_list_matrix_HetOTL; std(mistakes_list_HetOTL(:,4:13))];

  mean_mistake_list_matrix_HetOTL_SL = [mean_mistake_list_matrix_HetOTL_SL; mean(mistakes_list_HetOTL_shared(:,4:13))];
	std_mistake_list_matrix_HetOTL_SL = [std_mistake_list_matrix_HetOTL_SL; std(mistakes_list_HetOTL_shared(:,4:13))];

  mean_mistake_list_matrix_PA_NV = [mean_mistake_list_matrix_PA_NV; mean(mistakes_list_PA1_fea)];
	std_mistake_list_matrix_PA_NV = [std_mistake_list_matrix_PA_NV; std(mistakes_list_PA1_fea)];

  %mean_mistake_list_matrix_PA_MV = [mean_mistake_list_matrix_PA_MV; mean(mistakes_list_PA_MV1)];
	%std_mistake_list_matrix_PA_MV = [std_mistake_list_matrix_PA_MV; std(mistakes_list_PA_MV1)];

  mean_mistake_list_matrix_OTLHS = [mean_mistake_list_matrix_OTLHS; mean(mistakes_list_dso)];
	std_mistake_list_matrix_OTLHS = [std_mistake_list_matrix_OTLHS; std(mistakes_list_dso)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%fclose(file_error_final_table);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save 
save(sprintf('../process_result/%s/%d/error_final_vector', directory, iter), 'mean_error_final_vector_PA', 'mean_error_final_vector_PA_SL', 'mean_error_final_vector_HetOTL', 'mean_error_final_vector_HetOTL_SL', 'mean_error_final_vector_PA_NV', 'mean_error_final_vector_OTLHS', 'std_error_final_vector_PA', 'std_error_final_vector_PA_SL', 'std_error_final_vector_HetOTL', 'std_error_final_vector_HetOTL_SL', 'std_error_final_vector_PA_NV', 'std_error_final_vector_OTLHS');
%save('error_final_vector', 'mean_error_final_vector_PA', 'mean_error_final_vector_HTLIC_online', 'mean_error_final_vector_PA_SL', 'mean_error_final_vector_HetOTL', 'mean_error_final_vector_HetOTL_SL', 'mean_error_final_vector_PA_NV', 'mean_error_final_vector_PA_MV', 'mean_error_final_vector_OTLHS', 'std_error_final_vector_PA', 'std_error_final_vector_HTLIC_online', 'std_error_final_vector_PA_SL', 'std_error_final_vector_HetOTL', 'std_error_final_vector_HetOTL_SL', 'std_error_final_vector_PA_NV', 'std_error_final_vector_PA_MV', 'std_error_final_vector_OTLHS');

save(sprintf('../process_result/%s/%d/mistake_list_matrix', directory, iter), 'mean_mistake_list_matrix_PA', 'mean_mistake_list_matrix_PA_SL', 'mean_mistake_list_matrix_HetOTL', 'mean_mistake_list_matrix_HetOTL_SL', 'mean_mistake_list_matrix_PA_NV', 'mean_mistake_list_matrix_OTLHS', 'std_mistake_list_matrix_PA', 'std_mistake_list_matrix_PA_SL', 'std_mistake_list_matrix_HetOTL', 'std_mistake_list_matrix_HetOTL_SL', 'std_mistake_list_matrix_PA_NV', 'std_mistake_list_matrix_OTLHS');
%save('mistake_list_matrix', 'mean_mistake_list_matrix_PA', 'mean_mistake_list_matrix_HTLIC_online', 'mean_mistake_list_matrix_PA_SL', 'mean_mistake_list_matrix_HetOTL', 'mean_mistake_list_matrix_HetOTL_SL', 'mean_mistake_list_matrix_PA_NV', 'mean_mistake_list_matrix_PA_MV', 'mean_mistake_list_matrix_OTLHS', 'std_mistake_list_matrix_PA', 'std_mistake_list_matrix_HTLIC_online', 'std_mistake_list_matrix_PA_SL', 'std_mistake_list_matrix_HetOTL', 'std_mistake_list_matrix_HetOTL_SL', 'std_mistake_list_matrix_PA_NV', 'std_mistake_list_matrix_PA_MV', 'std_mistake_list_matrix_OTLHS');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
