
for iter = 1 : 4

    data = load(sprintf('../original/%d', iter));
    X_target = data.X_target;
    X_source = data.X_source;
    co_X_target = data.co_X_target;
    co_X_source = data.co_X_source;

    source_num = size(X_source,1);
    target_num = size(X_target,1);
    co_target_num = size(co_X_target,1);
    ctt_sim = zeros( co_target_num,target_num );
    co_source_num = size(co_X_source,1);
    css_sim = zeros( co_source_num,source_num );

    sigma = 0.2;
    %source to source
    disp('Calculating source to source transition matrix...');
     
    P_ss = zeros(source_num, source_num);
    for idx1=1:(source_num-1)
        for idx2=(idx1+1):source_num
            fea1 = X_source( idx1, : );
            fea2 = X_source( idx2, : );
						x = fea1-mean(fea1);
						y = fea2-mean(fea2);
						sim = (x*y') / (sum(x.^2)*sum(y.^2));
            P_ss(idx1,idx2) = sim;
        end
    end
    %symmetric matrix
    P_ss=P_ss+P_ss';
    % diagonal line elements
    for idx1=1:source_num
        fea1 = X_source( idx1, : );
        fea2 = X_source( idx1, : );
				x = fea1-mean(fea1);
				y = fea2-mean(fea2);
				sim = (x*y') / (sum(x.^2)*sum(y.^2));
        P_ss(idx1,idx1) = sim;
    end

    %  target to target
     disp('Calculating target to target transition matrix...');
    P_tt = zeros(target_num, target_num);
    for idx1=1:(target_num-1)
        for idx2=(idx1+1):target_num
            fea1 = X_target( idx1, : );
            fea2 = X_target( idx2, : );
				    x = fea1-mean(fea1);
				    y = fea2-mean(fea2);
				    sim = (x*y') / (sum(x.^2)*sum(y.^2));
            P_tt(idx1,idx2) = sim;
        end
    end
    % symmetric matrix
    P_tt=P_tt+P_tt';
    % diagonal line elements
    for idx1=1:target_num
        fea1 = X_target( idx1, : );
        fea2 = X_target( idx1, : );
				x = fea1-mean(fea1);
				y = fea2-mean(fea2);
				sim = (x*y') / (sum(x.^2)*sum(y.^2));
        P_tt(idx1,idx1) = sim;
    end

    %  co-target to target
    disp('Calculating target to source transition matrix...');
    for idx1=1:co_target_num
        for idx2=1:target_num
            fea1 = co_X_target( idx1, : );
            fea2 = X_target( idx2, : );
				    x = fea1-mean(fea1);
				    y = fea2-mean(fea2);
				    sim = (x*y') / (sum(x.^2)*sum(y.^2));
            ctt_sim(idx1,idx2) = sim;
        end
    end
    for idx1=1:co_source_num
        for idx2=1:source_num
            fea1 = co_X_source( idx1, : );
            fea2 = X_source( idx2, : );
				    x = fea1-mean(fea1);
				    y = fea2-mean(fea2);
				    sim = (x*y') / (sum(x.^2)*sum(y.^2));
            css_sim(idx1,idx2) = sim;
        end
    end
    % source to target
    %P_st = X_source*co_X_source'*ctt_sim;
		%why not use gaussian kernel function?
    P_st = css_sim'*ctt_sim;
    css = css_sim;
    ctt = ctt_sim;
    save(sprintf('../similarity/%d', iter), 'P_ss', 'P_tt', 'P_st', 'css', 'ctt');

end
