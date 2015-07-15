
m = 500;
similarity_method = 'pearson';

% error_final
mean_error_PA1_personal_image = [];
std_error_PA1_personal_image = [];
mean_error_PA1_personal_text = [];
std_error_PA1_personal_text = [];

mean_error_PA1_shared_image = [];
std_error_PA1_shared_image = [];
mean_error_PA1_shared_text = [];
std_error_PA1_shared_text = [];

mean_error_dso1_image = [];
std_error_dso1_image = [];
mean_error_dso1_text = [];
std_error_dso1_text = [];

mean_error_PA1_extra_image = [];
std_error_PA1_extra_image = [];
mean_error_PA1_extra_text = [];
std_error_PA1_extra_text = [];

mean_error_PA1_extra_sim_image = [];
std_error_PA1_extra_sim_image = [];
mean_error_PA1_extra_sim_text = [];
std_error_PA1_extra_sim_text = [];


file_error_final_image = fopen('error_final_table_image', 'w');
fprintf(file_error_final_image, 'Target Task \t PA_personal \t PA_shared \t dso1 \t PA_extra \t PA_extra_sim \n');
file_error_final_text = fopen('error_final_table_text', 'w');
fprintf(file_error_final_text, 'Target Task \t PA_personal \t PA_shared \t dso1 \t PA_extra \t PA_extra_sim \n');


% mistakes list
mean_matrix_PA1_personal_image = [];
std_matrix_PA1_personal_image = [];
mean_matrix_PA1_personal_text = [];
std_matrix_PA1_personal_text = [];

mean_matrix_PA1_shared_image = [];
std_matrix_PA1_shared_image = [];
mean_matrix_PA1_shared_text = [];
std_matrix_PA1_shared_text = [];

mean_matrix_dso1_image = [];
std_matrix_dso1_image = [];
mean_matrix_dso1_text = [];
std_matrix_dso1_text = [];

mean_matrix_PA1_extra_image = [];
std_matrix_PA1_extra_image = [];
mean_matrix_PA1_extra_text = [];
std_matrix_PA1_extra_text = [];

mean_matrix_PA1_extra_sim_image = [];
std_matrix_PA1_extra_sim_image = [];
mean_matrix_PA1_extra_sim_text = [];
std_matrix_PA1_extra_sim_text = [];

for i = 1 : 45
	% error final
  load(sprintf('../stat/%s/%d-stat', similarity_method, i));
	fprintf(file_error_final_image, '%d \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \n', i, mean(err_PA1_personal_image)/m*100, std(err_PA1_personal_image)/m*100, mean(err_PA1_shared_image)/m*100, std(err_PA1_shared_image)/m*100, mean(err_dso1_image)/m*100, std(err_dso1_image)/m*100, mean(err_PA1_extra_image)/m*100, std(err_PA1_extra_image)/m*100, mean(err_PA1_extra_sim_image)/m*100, std(err_PA1_extra_sim_image)/m*100);
	fprintf(file_error_final_text, '%d \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \t %.4f %.4f \n', i, mean(err_PA1_personal_text)/m*100, std(err_PA1_personal_text)/m*100, mean(err_PA1_shared_text)/m*100, std(err_PA1_shared_text)/m*100, mean(err_dso1_text)/m*100, std(err_dso1_text)/m*100, mean(err_PA1_extra_text)/m*100, std(err_PA1_extra_text)/m*100, mean(err_PA1_extra_sim_text)/m*100, std(err_PA1_extra_sim_text)/m*100);

  mean_error_PA1_personal_image = [mean_error_PA1_personal_image, mean(err_PA1_personal_image)/m*100];
  std_error_PA1_personal_image = [std_error_PA1_personal_image, std(err_PA1_personal_image)/m*100];
  mean_error_PA1_personal_text = [mean_error_PA1_personal_text, mean(err_PA1_personal_text)/m*100];
  std_error_PA1_personal_text = [std_error_PA1_personal_text, std(err_PA1_personal_text)/m*100];

  mean_error_PA1_shared_image = [mean_error_PA1_shared_image, mean(err_PA1_shared_image)/m*100];
  std_error_PA1_shared_image = [std_error_PA1_shared_image, std(err_PA1_shared_image)/m*100];
  mean_error_PA1_shared_text = [mean_error_PA1_shared_text, mean(err_PA1_shared_text)/m*100];
  std_error_PA1_shared_text = [std_error_PA1_shared_text, std(err_PA1_shared_text)/m*100];

  mean_error_dso1_image = [mean_error_dso1_image, mean(err_dso1_image)/m*100];
  std_error_dso1_image = [std_error_dso1_image, std(err_dso1_image)/m*100];
  mean_error_dso1_text = [mean_error_dso1_text, mean(err_dso1_text)/m*100];
  std_error_dso1_text = [std_error_dso1_text, std(err_dso1_text)/m*100];

  mean_error_PA1_extra_image = [mean_error_PA1_extra_image, mean(err_PA1_extra_image)/m*100];
  std_error_PA1_extra_image = [std_error_PA1_extra_image, std(err_PA1_extra_image)/m*100];
  mean_error_PA1_extra_text = [mean_error_PA1_extra_text, mean(err_PA1_extra_text)/m*100];
  std_error_PA1_extra_text = [std_error_PA1_extra_text, std(err_PA1_extra_text)/m*100];

  mean_error_PA1_extra_sim_image = [mean_error_PA1_extra_sim_image, mean(err_PA1_extra_sim_image)/m*100];
  std_error_PA1_extra_sim_image = [std_error_PA1_extra_sim_image, std(err_PA1_extra_sim_image)/m*100];
  mean_error_PA1_extra_sim_text = [mean_error_PA1_extra_sim_text, mean(err_PA1_extra_sim_text)/m*100];
  std_error_PA1_extra_sim_text = [std_error_PA1_extra_sim_text, std(err_PA1_extra_sim_text)/m*100];

  % mistakes list
  mean_matrix_PA1_personal_image = [mean_matrix_PA1_personal_image; mean(mistakes_list_PA1_personal_image)];
  std_matrix_PA1_personal_image = [std_matrix_PA1_personal_image; std(mistakes_list_PA1_personal_image)];
  mean_matrix_PA1_personal_text = [mean_matrix_PA1_personal_text; mean(mistakes_list_PA1_personal_text)];
  std_matrix_PA1_personal_text = [std_matrix_PA1_personal_text; std(mistakes_list_PA1_personal_text)];

  mean_matrix_PA1_shared_image = [mean_matrix_PA1_shared_image; mean(mistakes_list_PA1_shared_image)];
  std_matrix_PA1_shared_image = [std_matrix_PA1_shared_image; std(mistakes_list_PA1_shared_image)];
  mean_matrix_PA1_shared_text = [mean_matrix_PA1_shared_text; mean(mistakes_list_PA1_shared_text)];
  std_matrix_PA1_shared_text = [std_matrix_PA1_shared_text; std(mistakes_list_PA1_shared_text)];

  mean_matrix_dso1_image = [mean_matrix_dso1_image; mean(mistakes_list_dso1_image)];
  std_matrix_dso1_image = [std_matrix_dso1_image; std(mistakes_list_dso1_image)];
  mean_matrix_dso1_text = [mean_matrix_dso1_text; mean(mistakes_list_dso1_text)];
  std_matrix_dso1_text = [std_matrix_dso1_text; std(mistakes_list_dso1_text)];

  mean_matrix_PA1_extra_image = [mean_matrix_PA1_extra_image; mean(mistakes_list_PA1_extra_image)];
  std_matrix_PA1_extra_image = [std_matrix_PA1_extra_image; std(mistakes_list_PA1_extra_image)];
  mean_matrix_PA1_extra_text = [mean_matrix_PA1_extra_text; mean(mistakes_list_PA1_extra_text)];
  std_matrix_PA1_extra_text = [std_matrix_PA1_extra_text; std(mistakes_list_PA1_extra_text)];

  mean_matrix_PA1_extra_sim_image = [mean_matrix_PA1_extra_sim_image; mean(mistakes_list_PA1_extra_sim_image)];
  std_matrix_PA1_extra_sim_image = [std_matrix_PA1_extra_sim_image; std(mistakes_list_PA1_extra_sim_image)];
  mean_matrix_PA1_extra_sim_text = [mean_matrix_PA1_extra_sim_text; mean(mistakes_list_PA1_extra_sim_text)];
  std_matrix_PA1_extra_sim_text = [std_matrix_PA1_extra_sim_text; std(mistakes_list_PA1_extra_sim_text)];

end

fclose(file_error_final_image);
fclose(file_error_final_text);

save('error_final_image', 'mean_error_PA1_personal_image', 'std_error_PA1_personal_image', 'mean_error_PA1_shared_image', 'std_error_PA1_shared_image', 'mean_error_dso1_image', 'std_error_dso1_image', 'mean_error_PA1_extra_image', 'std_error_PA1_extra_image', 'mean_error_PA1_extra_sim_image', 'std_error_PA1_extra_sim_image');
save('error_final_text', 'mean_error_PA1_personal_text', 'std_error_PA1_personal_text', 'mean_error_PA1_shared_text', 'std_error_PA1_shared_text', 'mean_error_dso1_text', 'std_error_dso1_text', 'mean_error_PA1_extra_text', 'std_error_PA1_extra_image', 'mean_error_PA1_extra_sim_text', 'std_error_PA1_extra_sim_text');

save('mean_std_matrix_image', 'mean_matrix_PA1_personal_image', 'std_matrix_PA1_personal_image', 'mean_matrix_PA1_shared_image', 'std_matrix_PA1_shared_image', 'mean_matrix_dso1_image', 'std_matrix_dso1_image', 'mean_matrix_PA1_extra_image', 'std_matrix_PA1_extra_image', 'mean_matrix_PA1_extra_sim_image', 'std_matrix_PA1_extra_sim_image');
save('mean_std_matrix_text', 'mean_matrix_PA1_personal_text', 'std_matrix_PA1_personal_text', 'mean_matrix_PA1_shared_text', 'std_matrix_PA1_shared_text', 'mean_matrix_dso1_text', 'std_matrix_dso1_text', 'mean_matrix_PA1_extra_text', 'std_matrix_PA1_extra_text', 'mean_matrix_PA1_extra_sim_text', 'std_matrix_PA1_extra_sim_text');
