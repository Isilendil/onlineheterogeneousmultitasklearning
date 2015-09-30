function P = load_sparse_matrix(file)

fprintf('Loading %s...',file);
records = load(file,'-ascii');
nrows = records(end,1);
ncols = records(end,2);
nonzeros = records(end,3);
if nonzeros ~= size(records,1)-1
    error('nonzeros(%d) ~= end-1(%d)',nonzeros,size(records,1)-1);
end
len = size(records,1)-1;
P = sparse(records(1:len,1),records(1:len,2),records(1:len,3),nrows,ncols);
fprintf('%d entries\n',nnz(P));