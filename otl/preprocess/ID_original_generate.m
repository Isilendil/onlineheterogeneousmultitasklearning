
n = 4000;

n_target = round(n * (1/4));
n_source = round(n * (3/4) * (1/10));
n_codata = round(n * (3/4) * (9/10));

ID_original = randperm(n);

ID_target = ID_original(1 : n_target);
ID_source = ID_original(n_target+1 : n_target+n_source);
ID_codata = ID_original(n_target+n_source+1 : end);

save('ID_original', 'ID_original', 'ID_target', 'ID_source', 'ID_codata');
