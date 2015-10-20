function  experiment_otl(data_file)

%load dataset
load(sprintf('../../../otl/original/%d', data_file));
load(sprintf('../../../otl/similarity/cosin/%d', data_file));



[L, d] = size(X_source);
U = size(co_X_source, 1);

C   = 5;
C_star = L * C / U;
s = 0;
k = round(size(X_source,1) / 10);


% scale
MaxX=max(X_source,[],2);
MinX=min(X_source,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
X_source = bsxfun(@minus, X_source, MinX);
X_source = bsxfun(@rdivide, X_source , DifX_2);

MaxX=max(co_X_source,[],2);
MinX=min(co_X_source,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
co_X_source = bsxfun(@minus, co_X_source, MinX);
co_X_source = bsxfun(@rdivide, co_X_source , DifX_2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kernel
%{
sigma = 4;

MaxX=max(text_X,[],2);
MinX=min(text_X,[],2);
DifX=MaxX-MinX;
idx_DifNonZero=(DifX~=0);
DifX_2=ones(size(DifX));
DifX_2(idx_DifNonZero,:)=DifX(idx_DifNonZero,:);
text_X = bsxfun(@minus, text_X, MinX);
text_X = bsxfun(@rdivide, text_X , DifX_2);
P = sum(text_X.*text_X,2);
P = full(P);
disp('Pre-computing kernel matrix...');
text_K1 = exp(-(repmat(P',n_text,1) + repmat(P,1,n_text)- 2*text_X*text_X')/(2*options.sigma^2));
text_K1 = exp(-(repmat(P',n_text,1) + repmat(P,1,n_text)- 2*text_X*text_X')/(2*1^2));
text_K1 = text_X*text_X';

text_fea2 = co_text_fea;
P2 = sum(text_fea2.*text_fea2,2);
P2 = full(P2);
text_K2 = exp(-(repmat(P2',m_text,1) + repmat(P2,1,m_text)- 2*text_fea2*text_fea2')/(2*options.sigma2^2));
text_K2 = exp(-(repmat(P2',m_text,1) + repmat(P2,1,m_text)- 2*text_fea2*text_fea2')/(2*2^2));
text_K2 = text_fea2*text_fea2';
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% svm
%{
[w, xi] = svm_qp_train(X_source, Y_source, C);
co_Y_svm = sign(co_X_source * w);
co_Y_svm(co_Y_svm==0) = 1;
model = svmtrain(X_source, Y_source);
co_Y_svm = svmclassify(co_X_source);
co_Y_svm(co_Y_svm==0) = 1;
rate_svm = sum(co_Y_svm~=Y_codata)/U;
%}

% tsvm
%{
w = cccp_tsvm_train(X_source, Y_source, co_X_source, C, C_star, s);
co_Y_tsvm = sign(co_X_source * w);
co_Y_tsvm(co_Y_tsvm==0) = 1;
rate_tsvm = sum(co_Y_tsvm~=Y_codata)/U;
%}

% knn
co_Y_knn = predict_knn(css, Y_source, k);
co_Y_knn(co_Y_knn==0) = 1;
rate_knn = sum(co_Y_knn~=Y_codata)/U;

% pa
w = pa(X_source, Y_source, C);
co_Y_pa = sign(co_X_source * w);
co_Y_pa(co_Y_pa==0) = 1;
rate_pa = sum(co_Y_pa~=Y_codata)/U;


Y_file = sprintf('otl/%d', data_file);
%save(Y_file, 'co_Y_svm', 'co_Y_tsvm', 'co_Y_knn', 'co_Y_pa');
save(Y_file, 'co_Y_knn', 'co_Y_pa');

rate_file = sprintf('otl/%d-rate', data_file);
%save(rate_file, 'rate_svm', 'rate_tsvm', 'rate_knn', 'rate_pa');
save(rate_file, 'rate_knn', 'rate_pa');

