function saveCellArray(filename,arr)

fid = fopen(filename,'wt');
[n,m] = size(arr);
for (i=1:n)
    for (j=1:m)
        fprintf(fid,'%15s ',char(arr(i,j)));
    end
    fprintf(fid,'\n');
end
fclose(fid);
return