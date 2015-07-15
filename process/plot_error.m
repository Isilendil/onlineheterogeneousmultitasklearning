
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultLineMarkerSize', 15);

id_list = [50:50:500];

% image
%========================================================
load('mean_std_matrix_image');

figure;
hold on;
box on;
for i = 1 : 45
  plot(id_list, mean_matrix_PA1_personal_image(i,:), '');
  plot(id_list, mean_matrix_PA1_shared_image(i,:), '');
  plot(id_list, mean_matrix_dso1_image(i,:), '');
  plot(id_list, mean_matrix_PA1_extra_sim_image(i,:), '');
  plot(id_list, mean_matrix_PA1_sim_image(i,:), '');
  legend0 = legend('PA-personal', 'PA-shared', 'dso1', 'PA-extra-sim', 'PA-extra');
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

figure;
hold on;
box on;
for i = 1 : 45
  plot(id_list, mean_matrix_PA1_personal_text(i,:), '');
  plot(id_list, mean_matrix_PA1_shared_text(i,:), '');
  plot(id_list, mean_matrix_dso1_text(i,:), '');
  plot(id_list, mean_matrix_PA1_extra_sim_text(i,:), '');
  plot(id_list, mean_matrix_PA1_sim_text(i,:), '');
  legend0 = legend('PA-personal', 'PA-shared', 'dso1', 'PA-extra-sim', 'PA-extra');
  xlabel('\fontsize{20} Number of samples');
	ylabel('\fontsize{20} Online average rate of mistakes');
	set(gcf, 'unit', 'centimeters', 'position', [0, 0, 14.6, 11.1]);
	grid;

	saveas(gcf, sprintf('../figure/text/%d.fig', i));
	saveas(gcf, sprintf('../figure/text/%d.pdf', i));
	close(figure(gcf));
end
%========================================================
