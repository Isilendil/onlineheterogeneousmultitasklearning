function [Xn,Dr,Dc] = spectral_normalize(X)
% Normalize the matrix 
rs = sqrt(sum(X,2));
cs = sqrt(sum(X,1));
%fprintf(1,'rs=0: %d\n',length(find(rs==0)));
%fprintf(1,'cs=0: %d\n',length(find(cs==0)));
rs_idx = find(rs==0);
cs_idx = find(cs==0);
rs(find(rs==0)) = eps;
cs(find(cs==0)) = eps;
r = 1./rs;
c = 1./cs;
r(rs_idx) = 0;
c(cs_idx) = 0;
Dr = spdiags(r,0,size(X,1),size(X,1));
Dc = spdiags(c',0,size(X,2),size(X,2));
Xn = Dr * X * Dc;
