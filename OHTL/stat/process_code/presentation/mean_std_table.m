
function mean_std_table()

directory = 'eoc';


for iter = 12 : 12

load(sprintf('../../process_result/%s/%d/error_final_vector', directory, iter));

file_name = fopen(sprintf('./table/mean_std_table', directory, iter), 'w');
fprintf(file_name, 'Task \t PA \t PANV \t PASL \t HetOTL \t OTLHS \n');
%fprintf(file_name, 'Task \t PA \t PA_NV \t PA_SL \t HTLIC_online \t HetOTL \t HetOTL_SL \t OTLHS \n');

for i = 1 : 45

  fprintf(file_name, '%d \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \n', i, mean_error_final_vector_PA(i), std_error_final_vector_PA(i), mean_error_final_vector_PA_NV(i), std_error_final_vector_PA_NV(i), mean_error_final_vector_PA_SL(i), std_error_final_vector_PA_SL(i), mean_error_final_vector_HetOTL(i), std_error_final_vector_HetOTL(i), mean_error_final_vector_OTLHS(i), std_error_final_vector_OTLHS(i));

end

fclose(file_name);

end
