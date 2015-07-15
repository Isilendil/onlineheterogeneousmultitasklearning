
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultLineMarkerSize', 15);

% image
%========================================================
load('error_final_image');

image = mean_error_PA1_personal_image';
image = [image, mean_error_PA1_shared_image'];
%image = [image, mean_error_dso1_image'];
image = [image, mean_error_PA1_extra_sim_image'];
image = [image, mean_error_PA1_extra_image'];

figure;
hold on;
box on;
b = bar(image);
set(gcf, 'unit', 'centimeters', 'Position', [0, 0, 40.6, 9.2]);
legend0 = legend('PA-personal', 'PA-shared', 'PA-extra-sim', 'PA-extra');
%legend0 = legend('PA-personal', 'PA-shared', 'dso1', 'PA-extra-sim', 'PA-extra');
set(legend0, 'Fontsize', 15);
ymin = min(min(image));
ymax = max(max(image));
axis([0, 46, floor(ymin/5)*5, ceil(ymax/5)*5]);
set(gca, 'XTick', []);
ylabel('\fontsize{20} Average rate of mistakes');
grid;
saveas(gcf, '../figure/image/error_final_all_task_image.fig');
saveas(gcf, '../figure/image/error_final_all_task_image.pdf');
%========================================================


% text 
%========================================================
load('error_final_text');

text = mean_error_PA1_personal_text';
text = [text, mean_error_PA1_shared_text'];
%text = [text, mean_error_dso1_text'];
text = [text, mean_error_PA1_extra_sim_text'];
text = [text, mean_error_PA1_extra_text'];

figure;
hold on;
box on;
b = bar(text);
set(gcf, 'unit', 'centimeters', 'Position', [0, 0, 40.6, 9.2]);
legend0 = legend('PA-personal', 'PA-shared', 'PA-extra-sim', 'PA-extra');
%legend0 = legend('PA-personal', 'PA-shared', 'dso1', 'PA-extra-sim', 'PA-extra');
set(legend0, 'Fontsize', 15);
ymin = min(min(text));
ymax = max(max(text));
axis([0, 46, floor(ymin/5)*5, ceil(ymax/5)*5]);
set(gca, 'XTick', []);
ylabel('\fontsize{20} Average rate of mistakes');
grid;
saveas(gcf, '../figure/text/error_final_all_task_text.fig');
saveas(gcf, '../figure/text/error_final_all_task_text.pdf');
%========================================================
