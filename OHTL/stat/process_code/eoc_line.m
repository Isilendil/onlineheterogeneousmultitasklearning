
function eoc_line()


set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultLineMarkerSize', 15);

id_list = [-10:10];

PA = zeros(1, 21);
PA_NV = zeros(1, 21);
PA_SL = zeros(1, 21);
%HTLIC_online = zeros(1, 21);
HetOTL = zeros(1, 21);
HetOTL_SL = zeros(1, 21);
OTLHS = zeros(1, 21);

for iter = 1 : 21
	load(sprintf('../process_result/eoc/%d/error_final_vector', iter));
	
	PA(iter) = mean(mean_error_final_vector_PA);
	PA_NV(iter) = mean(mean_error_final_vector_PA_NV);
	PA_SL(iter) = mean(mean_error_final_vector_PA_SL);
	%HTLIC_online(iter) = mean(mean_error_final_vector_HTLIC_online);
	HetOTL(iter) = mean(mean_error_final_vector_HetOTL);
	HetOTL_SL(iter) = mean(mean_error_final_vector_HetOTL_SL);
	OTLHS(iter) = mean(mean_error_final_vector_OTLHS);
end

figure;
hold on;
box on;

plot(id_list, PA, 'go-');
plot(id_list, PA_NV, 'cx-');
plot(id_list, PA_SL, 'm^-');
plot(id_list, HetOTL, 'k<-');
plot(id_list, HetOTL_SL, 'rs-');
plot(id_list, OTLHS, 'b+-');

legend0 = legend('PA', 'PA\_NV', 'PA\_SL', 'HetOTL', 'HetOTL\_S', 'OTLHS');
xlabel('\fontsize{20} log_2(C)');
ylabel('\fontsize{20} Average rate of mistakes');
set(gcf, 'unit', 'centimeters', 'position', [0, 0, 14.6, 11.1]);
grid;

saveas(gcf, sprintf('../process_result/eoc/eop.fig'));
saveas(gcf, sprintf('../process_result/eoc/eop.eps'));
saveas(gcf, sprintf('../process_result/eoc/eop.pdf'));
close(figure(gcf));

