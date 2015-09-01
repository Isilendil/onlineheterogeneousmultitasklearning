
function sv_rt_process(directory)

%directory = {'eoc', 'eos_image', 'eos_text'}

m = 500;

for iter = 1 : 21

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sv_final
mean_sv_final_vector_PA = [];
std_sv_final_vector_PA = [];

mean_sv_final_vector_HTLIC_online = [];
std_sv_final_vector_HTLIC_online = [];

mean_sv_final_vector_PA_SL = [];
std_sv_final_vector_PA_SL = [];

mean_sv_final_vector_HetOTL = [];
std_sv_final_vector_HetOTL = [];

mean_sv_final_vector_HetOTL_SL = [];
std_sv_final_vector_HetOTL_SL = [];

mean_sv_final_vector_PA_NV = [];
std_sv_final_vector_PA_NV = [];

mean_sv_final_vector_PA_MV = [];
std_sv_final_vector_PA_MV = [];

mean_sv_final_vector_OTLHS = [];
std_sv_final_vector_OTLHS = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rt_final
mean_rt_final_vector_PA = [];
std_rt_final_vector_PA = [];

mean_rt_final_vector_HTLIC_online = [];
std_rt_final_vector_HTLIC_online = [];

mean_rt_final_vector_PA_SL = [];
std_rt_final_vector_PA_SL = [];

mean_rt_final_vector_HetOTL = [];
std_rt_final_vector_HetOTL = [];

mean_rt_final_vector_HetOTL_SL = [];
std_rt_final_vector_HetOTL_SL = [];

mean_rt_final_vector_PA_NV = [];
std_rt_final_vector_PA_NV = [];

mean_rt_final_vector_PA_MV = [];
std_rt_final_vector_PA_MV = [];

mean_rt_final_vector_OTLHS = [];
std_rt_final_vector_OTLHS = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for i = 1 : 45
  load(sprintf('../%s/%d/%d-stat', directory, iter, i));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% sv final
  mean_sv_final_vector_PA = [mean_sv_final_vector_PA, mean(nSV_PA1)/m*100];
	std_sv_final_vector_PA = [std_sv_final_vector_PA, std(nSV_PA1)/m*100];

  %mean_sv_final_vector_HTLIC_online = [mean_sv_final_vector_HTLIC_online, mean(nSV_HTLIC_online)/m*100];
	%std_sv_final_vector_HTLIC_online = [std_sv_final_vector_HTLIC_online, std(nSV_HTLIC_online)/m*100];

  mean_sv_final_vector_PA_SL = [mean_sv_final_vector_PA_SL, mean(nSV_PA1_shared)/m*100];
	std_sv_final_vector_PA_SL = [std_sv_final_vector_PA_SL, std(nSV_PA1_shared)/m*100];

  mean_sv_final_vector_HetOTL = [mean_sv_final_vector_HetOTL, mean(nSV_HetOTL)/m*100];
	std_sv_final_vector_HetOTL = [std_sv_final_vector_HetOTL, std(nSV_HetOTL)/m*100];

  mean_sv_final_vector_HetOTL_SL = [mean_sv_final_vector_HetOTL_SL, mean(nSV_HetOTL_shared)/m*100];
	std_sv_final_vector_HetOTL_SL = [std_sv_final_vector_HetOTL_SL, std(nSV_HetOTL_shared)/m*100];

  mean_sv_final_vector_PA_NV = [mean_sv_final_vector_PA_NV, mean(nSV_PA1_fea)/m*100];
	std_sv_final_vector_PA_NV = [std_sv_final_vector_PA_NV, std(nSV_PA1_fea)/m*100];

  %mean_sv_final_vector_PA_MV = [mean_sv_final_vector_PA_MV, mean(nSV_PA_MV1)/m*100];
	%std_sv_final_vector_PA_MV = [std_sv_final_vector_PA_MV, std(nSV_PA_MV1)/m*100];

  mean_sv_final_vector_OTLHS = [mean_sv_final_vector_OTLHS, mean(nSV_dso)/m*100];
	std_sv_final_vector_OTLHS = [std_sv_final_vector_OTLHS, std(nSV_dso)/m*100];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% rt final
  mean_rt_final_vector_PA = [mean_rt_final_vector_PA, mean(time_PA1)/m*100];
	std_rt_final_vector_PA = [std_rt_final_vector_PA, std(time_PA1)/m*100];

  %mean_rt_final_vector_HTLIC_online = [mean_rt_final_vector_HTLIC_online, mean(time_HTLIC_online)/m*100];
	%std_rt_final_vector_HTLIC_online = [std_rt_final_vector_HTLIC_online, std(time_HTLIC_online)/m*100];

  mean_rt_final_vector_PA_SL = [mean_rt_final_vector_PA_SL, mean(time_PA1_shared)/m*100];
	std_rt_final_vector_PA_SL = [std_rt_final_vector_PA_SL, std(time_PA1_shared)/m*100];

  mean_rt_final_vector_HetOTL = [mean_rt_final_vector_HetOTL, mean(time_HetOTL)/m*100];
	std_rt_final_vector_HetOTL = [std_rt_final_vector_HetOTL, std(time_HetOTL)/m*100];

  mean_rt_final_vector_HetOTL_SL = [mean_rt_final_vector_HetOTL_SL, mean(time_HetOTL_shared)/m*100];
	std_rt_final_vector_HetOTL_SL = [std_rt_final_vector_HetOTL_SL, std(time_HetOTL_shared)/m*100];

  mean_rt_final_vector_PA_NV = [mean_rt_final_vector_PA_NV, mean(time_PA1_fea)/m*100];
	std_rt_final_vector_PA_NV = [std_rt_final_vector_PA_NV, std(time_PA1_fea)/m*100];

  %mean_rt_final_vector_PA_MV = [mean_rt_final_vector_PA_MV, mean(time_PA_MV1)/m*100];
	%std_rt_final_vector_PA_MV = [std_rt_final_vector_PA_MV, std(time_PA_MV1)/m*100];

  mean_rt_final_vector_OTLHS = [mean_rt_final_vector_OTLHS, mean(time_dso)/m*100];
	std_rt_final_vector_OTLHS = [std_rt_final_vector_OTLHS, std(time_dso)/m*100];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save 
save(sprintf('../process_result/%s/%d/sv_final_vector', directory, iter), 'mean_sv_final_vector_PA', 'mean_sv_final_vector_PA_SL', 'mean_sv_final_vector_HetOTL', 'mean_sv_final_vector_HetOTL_SL', 'mean_sv_final_vector_PA_NV', 'mean_sv_final_vector_OTLHS', 'std_sv_final_vector_PA', 'std_sv_final_vector_PA_SL', 'std_sv_final_vector_HetOTL', 'std_sv_final_vector_HetOTL_SL', 'std_sv_final_vector_PA_NV', 'std_sv_final_vector_OTLHS');
%save('sv_final_vector', 'mean_sv_final_vector_PA', 'mean_sv_final_vector_HTLIC_online', 'mean_sv_final_vector_PA_SL', 'mean_sv_final_vector_HetOTL', 'mean_sv_final_vector_HetOTL_SL', 'mean_sv_final_vector_PA_NV', 'mean_sv_final_vector_PA_MV', 'mean_sv_final_vector_OTLHS', 'std_sv_final_vector_PA', 'std_sv_final_vector_HTLIC_online', 'std_sv_final_vector_PA_SL', 'std_sv_final_vector_HetOTL', 'std_sv_final_vector_HetOTL_SL', 'std_sv_final_vector_PA_NV', 'std_sv_final_vector_PA_MV', 'std_sv_final_vector_OTLHS');

save(sprintf('../process_result/%s/%d/rt_final_vector', directory, iter), 'mean_rt_final_vector_PA', 'mean_rt_final_vector_PA_SL', 'mean_rt_final_vector_HetOTL', 'mean_rt_final_vector_HetOTL_SL', 'mean_rt_final_vector_PA_NV', 'mean_rt_final_vector_OTLHS', 'std_rt_final_vector_PA', 'std_rt_final_vector_PA_SL', 'std_rt_final_vector_HetOTL', 'std_rt_final_vector_HetOTL_SL', 'std_rt_final_vector_PA_NV', 'std_rt_final_vector_OTLHS');
%save('rt_final_vector', 'mean_rt_final_vector_PA', 'mean_rt_final_vector_HTLIC_online', 'mean_rt_final_vector_PA_SL', 'mean_rt_final_vector_HetOTL', 'mean_rt_final_vector_HetOTL_SL', 'mean_rt_final_vector_PA_NV', 'mean_rt_final_vector_PA_MV', 'mean_rt_final_vector_OTLHS', 'std_rt_final_vector_PA', 'std_rt_final_vector_HTLIC_online', 'std_rt_final_vector_PA_SL', 'std_rt_final_vector_HetOTL', 'std_rt_final_vector_HetOTL_SL', 'std_rt_final_vector_PA_NV', 'std_rt_final_vector_PA_MV', 'std_rt_final_vector_OTLHS');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
