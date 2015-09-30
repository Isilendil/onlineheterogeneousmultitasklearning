% A = param*simU
function [result] = combineAU(A, simU)
A_sum = sum(abs(A'));
U_sum = sum(abs(simU'));

param = A_sum./U_sum;

b = repmat(param, 1, size(simU,2));
result = b.*simU;
