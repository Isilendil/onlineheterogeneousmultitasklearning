
function mean_std_sv_table(directory)

%directory = {'roc', 'eos_image', 'eos_text'}

for iter = 1 : 21

load(sprintf('../process_result/%s/%d/sv_final_vector', directory, iter));

file_name = fopen(sprintf('../process_result/%s/%d/mean_std_sv_table', directory, iter), 'w');
fprintf(file_name, 'Task \t PA \t PA_NV \t PA_SL \t HetOTL \t HetOTL_SL \t OTLHS \n');
%fprintf(file_name, 'Task \t PA \t PA_NV \t PA_SL \t HTLIC_online \t HetOTL \t HetOTL_SL \t OTLHS \n');

for i = 1 : 45

  fprintf(file_name, '%d \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \n', i, mean_sv_final_vector_PA(i), std_sv_final_vector_PA(i), mean_sv_final_vector_PA_NV(i), std_sv_final_vector_PA_NV(i), mean_sv_final_vector_PA_SL(i), std_sv_final_vector_PA_SL(i), mean_sv_final_vector_HetOTL(i), std_sv_final_vector_HetOTL(i), mean_sv_final_vector_HetOTL_SL(i), std_sv_final_vector_HetOTL_SL(i), mean_sv_final_vector_OTLHS(i), std_sv_final_vector_OTLHS(i));

end

fclose(file_name);

end
