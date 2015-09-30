function [Xs, Ws] = gen_data(dims, rc_pairs, k, sparsity)
%function [Xs, Ws] = gen_data(dims, rc_pairs, k, sparsity)

Vs = cell(1, length(dims));
Xs = cell(1, length(rc_pairs));
Ws = cell(1, length(rc_pairs));

for i=1:length(dims)
  Vs{i} = rand(dims(i), k);
end

for i=1:length(rc_pairs)
  rf_id = rc_pairs(i,1);
  cf_id = rc_pairs(i,2);
  Xs{i} = sprand(dims(rf_id),dims(cf_id),sparsity) .* (Vs{rf_id}*Vs{cf_id}');
  Ws{i} = spones(Xs{i});
end

