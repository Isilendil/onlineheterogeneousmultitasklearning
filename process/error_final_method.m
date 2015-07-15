
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultLineLineWidth', 1.5);
set(0, 'DefaultLineMarkerSize', 8);

% image
%========================================================
load('error_final_image');

image = mean(mean_error_PA1_personal_image);
image = [image, mean(mean_error_PA1_shared_image)];
%image = [image, mean(mean_error_dso1_image)];
image = [image, mean(mean_error_PA1_extra_sim_image)];
image = [image, mean(mean_error_PA1_extra_image)];

figure;
hold on;
box on;
b = bar(diag(image), 'stack');
set(gcf, 'unit', 'centimeters', 'Position', [0, 0, 14.6, 11.1]);
legend0 = legend('PA-personal', 'PA-shared', 'PA-extra-sim', 'PA-extra');
%legend0 = legend('PA-personal', 'PA-shared', 'dso1', 'PA-extra-sim', 'PA-extra');
set(legend0, 'Fontsize', 15);
ymin = min(image);
ymax = max(image);
axis([0, 5, floor(ymin/5)*5, ceil(ymax/5)*5]);
%axis([0, 6, floor(ymin/5)*5, ceil(ymax/5)*5]);
set(gca, 'XTick', []);
ylabel('\fontsize{20} Average rate of mistakes');
grid;
saveas(gcf, '../figure/image/error_final_method_image.fig');
saveas(gcf, '../figure/image/error_final_method_image.pdf');
%========================================================


% text 
%========================================================
load('error_final_text');

text = mean(mean_error_PA1_personal_text);
text = [text, mean(mean_error_PA1_shared_text)];
%text = [text, mean(mean_error_dso1_text)];
text = [text, mean(mean_error_PA1_extra_sim_text)];
text = [text, mean(mean_error_PA1_extra_text)];

figure;
hold on;
box on;
b = bar(diag(text), 'stack');
set(gcf, 'unit', 'centimeters', 'Position', [0, 0, 14.6, 11.1]);
legend0 = legend('PA-personal', 'PA-shared', 'PA-extra-sim', 'PA-extra');
%legend0 = legend('PA-personal', 'PA-shared', 'dso1', 'PA-extra-sim', 'PA-extra');
set(legend0, 'Fontsize', 15);
ymin = min(text);
ymax = max(text);
axis([0, 5, floor(ymin/5)*5, ceil(ymax/5)*5]);
%axis([0, 6, floor(ymin/5)*5, ceil(ymax/5)*5]);
set(gca, 'XTick', []);
ylabel('\fontsize{20} Average rate of mistakes');
grid;
saveas(gcf, '../figure/text/error_final_method_text.fig');
saveas(gcf, '../figure/text/error_final_method_text.pdf');
%========================================================
