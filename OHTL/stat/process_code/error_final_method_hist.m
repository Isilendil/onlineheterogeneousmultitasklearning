
function error_final_method_hist(directory)

%directory = {'eoc', 'eos_image', 'eos_text'}

set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 1.5);
set(0, 'DefaultLineMarkerSize', 8);

tick = 4;

for iter = 1 : 21 

%========================================================
load(sprintf('../process_result/%s/%d/error_final_vector', directory, iter));

mean_error_final = mean(mean_error_final_vector_PA);
%mean_error_final = [mean_error_final, mean(mean_error_final_vector_HTLIC_online];
mean_error_final = [mean_error_final, mean(mean_error_final_vector_PA_NV)];
mean_error_final = [mean_error_final, mean(mean_error_final_vector_PA_SL)];
mean_error_final = [mean_error_final, mean(mean_error_final_vector_HetOTL)];
mean_error_final = [mean_error_final, mean(mean_error_final_vector_HetOTL_SL)];
mean_error_final = [mean_error_final, mean(mean_error_final_vector_OTLHS)];

figure;
hold on;
box on;
b = bar(diag(mean_error_final), 'stack');
set(gcf, 'unit', 'centimeters', 'Position', [0, 0, 14.6, 11.1]);
legend0 = legend('PA', 'PA\_NV', 'PA\_SL', 'HetOTL', 'HetOTL\_S', 'OTLHS');
%legend0 = legend('PA', 'PA_NV', 'PA_SL', 'HTLIC\_online', 'HetOTL', 'HetOTL_S', 'OTLHS');
set(legend0, 'Fontsize', 15);
ymin = min(mean_error_final);
ymax = max(mean_error_final);
axis([0, length(mean_error_final)+1, floor(ymin/tick)*tick, ceil(ymax/tick)*tick]);
%axis([0, 7, floor(ymin/5)*5, ceil(ymax/5)*5]);
set(gca, 'XTick', []);
ylabel('\fontsize{20} Average rate of mistakes');
grid;
saveas(gcf, sprintf('../process_result/%s/%d/error_final_method_hist.fig', directory, iter));
saveas(gcf, sprintf('../process_result/%s/%d/error_final_method_hist.pdf', directory, iter));
saveas(gcf, sprintf('../process_result/%s/%d/error_final_method_hist.eps', directory, iter));
load(sprintf('../process_result/%s/%d/error_final_vector', directory, iter));
close(figure(gcf));
%========================================================


end
