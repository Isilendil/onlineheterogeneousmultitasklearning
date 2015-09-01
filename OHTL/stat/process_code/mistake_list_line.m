
function mistake_list_line(directory)

%directory = {'eoc', 'eos_image', 'eos_text'}

set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultLineMarkerSize', 15);

id_list = [50:50:500];

tick = 4;

for iter = 1 : 21

% image
%========================================================
load(sprintf('../process_result/%s/%d/mistake_list_matrix', directory, iter));

for i = 1 : 45
  figure;
  hold on;
  box on;

	plot(id_list, mean_mistake_list_matrix_PA(i,:), 'go-');
	plot(id_list, mean_mistake_list_matrix_PA_NV(i,:), 'cx-');
	plot(id_list, mean_mistake_list_matrix_PA_SL(i,:), 'm^-');
	%plot(id_list, mean_mistake_list_matrix_HTLIC_online(i,:), 'rs-');
	plot(id_list, mean_mistake_list_matrix_HetOTL(i,:), 'k<-');
	plot(id_list, mean_mistake_list_matrix_HetOTL_SL(i,:), 'rs-');
	plot(id_list, mean_mistake_list_matrix_OTLHS(i,:), 'b+-');
	
	%errorbar(id_list, mean_mistake_list_matrix_PA(i,:), std_mistake_list_matrix_PA(i,:), 'go-');
	%errorbar(id_list, mean_mistake_list_matrix_PA_NV(i,:), std_mistake_list_matrix_PA_NV(i,:), 'cx-');
	%errorbar(id_list, mean_mistake_list_matrix_PA_SL(i,:), std_mistake_list_matrix_PA_SL(i,:), 'm^-');
	%%plot(id_list, mean_mistake_list_matrix_HTLIC_online(i,:), std_mistake_list_matrix_HTLIC_online(i,:), 'rs-');
	%errorbar(id_list, mean_mistake_list_matrix_HetOTL(i,:), std_mistake_list_matrix_HetOTL(i,:), 'k<-');
	%errorbar(id_list, mean_mistake_list_matrix_HetOTL_SL(i,:), std_mistake_list_matrix_HetOTL_SL(i,:), 'rs-');
	%errorbar(id_list, mean_mistake_list_matrix_OTLHS(i,:), std_mistake_list_matrix_OTLHS(i,:), 'b+-');
	
  legend0 = legend('PA', 'PA\_NV', 'PA\_SL', 'HetOTL', 'HetOTL\_S', 'OTLHS');
  %legend0 = legend('PA', 'PA\_NV', 'PA\_SL', 'HTLIC\_online', 'HetOTL', 'HetOTL\_S', 'OTLHS');
  xlabel('\fontsize{20} Number of samples');
	ylabel('\fontsize{20} Online average rate of mistakes');
	set(gcf, 'unit', 'centimeters', 'position', [0, 0, 14.6, 11.1]);
	grid;

	saveas(gcf, sprintf('../process_result/%s/%d/%d.fig', directory, iter, i));
	saveas(gcf, sprintf('../process_result/%s/%d/%d.eps', directory, iter, i));
	saveas(gcf, sprintf('../process_result/%s/%d/%d.pdf', directory, iter, i));
	close(figure(gcf));
end
%========================================================



end
