
addpath('./tools/cmf');

load('../co_id');
load('../source_id');

for num_co_iter = 1 : 6
	switch num_co_iter 
		case 1
		  number_co = 200;
		case 2
		  number_co = 400;
		case 3
		  number_co = 600;
		case 4
		  number_co = 800;
		case 5
		  number_co = 1000;
		case 6
		  number_co = 1600;
	end


for iter = 1 : 45

load(sprintf('../../TextImage/data/original/%d', iter));

A = image_fea;

B1 = co_image_fea(co_id_1600(1:number_co),:);
B2 = co_text_fea(co_id_1600(1:number_co),:);

%for num_source_iter = 1 : 6
for num_source_iter = 1 : 2
	switch num_source_iter 
		case 1
		  number_source = 100;
		case 2
		  number_source = 200;
		%{
		case 3
		  number_source = 300;
		case 4
		  number_source = 400;
		case 5
		  number_source = 600;
		case 6
		  number_source = 1200;
		%}
	end

C = text_fea(source_id_1200(1:number_source),:);

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


for loop = 1 : 2

model = glm(Xs,Ws,params);

U = model{4};
simU = A*U;

image_fea_HTLIC(loop,:,:) = simU;

end


%save(sprintf('%s-1', data_file), 'image_fea', 'image_gnd', 'text_fea', 'text_gnd', 'co_image_fea', 'co_text_fea', 'image_fea_1');

save(sprintf('../../TextImage/data/feature_HTLIC/%d/%d/%d', number_co, number_source, iter), 'image_fea_HTLIC');

end

end

end
