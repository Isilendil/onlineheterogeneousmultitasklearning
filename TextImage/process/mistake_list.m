
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultLineMarkerSize', 15);

id_list = [50:50:500];

% image
%========================================================
load('mean_std_matrix_image');

for i = 1 : 45
  figure;
  hold on;
  box on;
	
  plot(id_list, mean_matrix_PA1_personal_image(i,:), 'go-');
  plot(id_list, mean_matrix_PA1_shared_image(i,:), 'cx-');
  plot(id_list, mean_matrix_OGD_personal_image(i,:), 'm^-');
  %plot(id_list, mean_matrix_dso1_image(i,:), 'k<-');
  plot(id_list, mean_matrix_PA1_extra_sim_image(i,:), 'rs-');
  plot(id_list, mean_matrix_PA1_extra_image(i,:), 'b+-');
  legend0 = legend('PA-personal', 'PA-shared', 'OGD-personal', 'PA-extra-sim', 'PA-extra');
  %legend0 = legend('PA-personal', 'PA-shared', 'OGD-personal', 'dso1', 'PA-extra-sim', 'PA-extra');
  xlabel('\fontsize{20} Number of samples');
	ylabel('\fontsize{20} Online average rate of mistakes');
	set(gcf, 'unit', 'centimeters', 'position', [0, 0, 14.6, 11.1]);
	grid;

	saveas(gcf, sprintf('../figure/image/%d.fig', i));
	saveas(gcf, sprintf('../figure/image/%d.pdf', i));
	close(figure(gcf));
end
%========================================================


% text 
%========================================================
load('mean_std_matrix_text');

for i = 1 : 45
  figure;
  hold on;
  box on;

  plot(id_list, mean_matrix_PA1_personal_text(i,:), 'go-');
  plot(id_list, mean_matrix_PA1_shared_text(i,:), 'cx-');
  plot(id_list, mean_matrix_OGD_personal_text(i,:), 'm^-');
  %plot(id_list, mean_matrix_dso1_text(i,:), 'k<-');
  plot(id_list, mean_matrix_PA1_extra_sim_text(i,:), 'rs-');
  plot(id_list, mean_matrix_PA1_extra_text(i,:), 'b+-');
  legend0 = legend('PA-personal', 'PA-shared', 'OGD-personal', 'PA-extra-sim', 'PA-extra');
  %legend0 = legend('PA-personal', 'PA-shared', 'OGD-personal', 'dso1', 'PA-extra-sim', 'PA-extra');
  xlabel('\fontsize{20} Number of samples');
	ylabel('\fontsize{20} Online average rate of mistakes');
	set(gcf, 'unit', 'centimeters', 'position', [0, 0, 14.6, 11.1]);
	grid;

	saveas(gcf, sprintf('../figure/text/%d.fig', i));
	saveas(gcf, sprintf('../figure/text/%d.pdf', i));
	close(figure(gcf));
end
%========================================================
