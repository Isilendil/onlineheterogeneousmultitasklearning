
function error_final_all_task_hist()

directory = 'eoc';

set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultLineMarkerSize', 15);

tick = 4;

for iter = 12 : 12

%========================================================
load(sprintf('../../process_result/%s/%d/error_final_vector', directory, iter));

%mean_error_final = mean_error_final_vector_PA';
%mean_error_final = [mean_error_final, mean_error_final_vector_HTLIC_online'];
%mean_error_final = [mean_error_final, mean_error_final_vector_PA_NV'];
mean_error_final =  mean_error_final_vector_PA_SL';
mean_error_final = [mean_error_final, mean_error_final_vector_HetOTL'];
%mean_error_final = [mean_error_final, mean_error_final_vector_HetOTL_SL'];
mean_error_final = [mean_error_final, mean_error_final_vector_OTLHS'];

figure;
hold on;
box on;
b = bar(mean_error_final);
b(2).FaceColor = 'red';
set(gcf, 'unit', 'centimeters', 'Position', [0, 0, 40.6, 9.2]);
legend0 = legend('PASL', 'HetOTL', 'OTLHS');
%legend0 = legend('PA', 'PA\_NV', 'PA\_SL', 'HTLIC\_online', 'HetOTL', 'HetOTL\_S', 'OTLHS');
set(legend0, 'Fontsize', 15);
ymin = min(min(mean_error_final));
ymax = max(max(mean_error_final));
axis([0, 46, floor(ymin/tick)*tick, ceil(ymax/tick)*tick]);
set(gca, 'XTick', []);
ylabel('\fontsize{20} Average rate of mistakes');
grid;
saveas(gcf, './figure/error_final_all_task_hist.fig');
saveas(gcf, './figure/error_final_all_task_hist.eps');
saveas(gcf, './figure/error_final_all_task_hist.pdf');
close(figure(gcf));
%========================================================


end
