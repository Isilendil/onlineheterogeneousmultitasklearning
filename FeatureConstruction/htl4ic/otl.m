fprintf(1, 'Too dangerous! \n');

%{
for iter = 1 : 4

load(sprintf('../../otl/original/%d', iter));

A = X_target;

B1 = co_X_target;
B2 = co_X_source;

C = X_source;

NB1 = sum(abs(B1),2);
B1 = B1 ./ repmat(NB1,[1 size(B1,2)]);
i = find(isnan(B1));
B1(i) = zeros(size(i));

i = find(isnan(B2));
B2(i) = zeros(size(i));

B21 = B1.' * B2;
i = find(isnan(B21));
B21(i) = zeros(size(i));

i = find(isnan(C));
C(i) = zeros(size(i));

rc_pairs = [1 2;3 2;4 2]; % 1: image 2: tag 3: doc 4:img feature

params = glmparams(3, 4, rc_pairs, {'gaussian', 'gaussian', 'gaussian'});
params.maxiter = 30;
params.k = 20;

ImageTag = sparse(B2);
DocTag = sparse(C);
FeatureTag = sparse(1000*B21);

Xs = {50*ImageTag 50*DocTag 50*FeatureTag};
Ws = {spones(ImageTag) spones(DocTag) 100*spones(FeatureTag)};


params.alphas = [0.25 0.25 0.5];
model = glm(Xs,Ws,params);

U = model{4};
simU = A*U;

X_target_HTLIC = simU;


%save(sprintf('%s-1', data_file), 'X_target', 'image_gnd', 'X_source', 'text_gnd', 'co_X_target', 'co_X_source', 'X_target_1');

save(sprintf('../../otl/feature_HTLIC/%d', iter), 'X_target_HTLIC');

end
%}
