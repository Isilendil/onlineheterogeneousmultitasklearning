
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

		P1_ss = X_source * X_source';
		P2_ss = sqrt(diag(P1_ss));
		P3_ss = P2_ss * P2_ss';
		P_ss = P1_ss ./ P3_ss;
     
    %  target to target
     disp('Calculating target to target transition matrix...');

		P1_tt = X_target * X_target';
		P2_tt = sqrt(diag(P1_tt));
		P3_tt = P2_tt * P2_tt';
		P_tt = P1_tt ./ P3_tt;
     

    %  co-target to target
    disp('Calculating target to source transition matrix...');
		c1_tt = co_X_target * X_target';
		n1_tt = sqrt(diag(co_X_target * co_X_target'));
		n2_tt = P2_tt;
		c3_tt = n1_tt * n2_tt';
		ctt = c1_tt ./ c3_tt;
     
    %  co-source to source
		c1_ss = co_X_source * X_source';
		n1_ss = sqrt(diag(co_X_source * co_X_source'));
		n2_ss = P2_ss;
		c3_ss = n1_ss * n2_ss';
		css = c1_ss ./ c3_ss;
    % source to target
    %P_st = X_source*co_X_source'*ctt_sim;
		%why not use gaussian kernel function?
    P_st = css'*ctt;
    save(sprintf('../similarity/cosin/%d', iter), 'P_ss', 'P_tt', 'P_st', 'css', 'ctt');

end
