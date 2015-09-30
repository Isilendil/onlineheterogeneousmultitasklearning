function [err, svar] = dosvm(instance, label, ntrain)
% instance, n by m matrix, n # of instances, m # of features
% lable, n by 1 matrix, n labels
% ntrain, # of training samples randomly sampled

num = 200;

errs = zeros(num,1);

for i=1:num,
    
    n = size(instance,1);
    p = randperm(n);
    %p = 1:n;
    p1 = p(1:ntrain);
    p2 = p(ntrain+1:end);


    A = instance(p1,:);
    Alabel = label(p1);
    B = instance(p2,:);
    Blabel = label(p2);



    % Split Data
    train_data = A; %full(A);
    train_label = Alabel;
    test_data = B; %full(B);
    test_label = Blabel;

    % Linear Kernel
    model_linear = svmtrain(train_label, train_data, '-t 0');
    [predict_label_L, accuracy_L, dec_values_L] = svmpredict(test_label, test_data, model_linear);

    err = accuracy_L(1);
    errs(i) = err;

end

err = mean(errs);
svar = sqrt(var(errs));
%err = errs / num;
