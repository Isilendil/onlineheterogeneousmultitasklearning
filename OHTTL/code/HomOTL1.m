function [classifier, err_count, run_time, mistakes, mistakes_idx, SVs, TMs] = HomOTL1(Y, K1, K2, options, id_list,classifier)
% HomOTL1: HomOTL-I
%--------------------------------------------------------------------------
% Input:
%        Y:    the vector of lables
%        K:    precomputed kernel for all the example, i.e., K_{ij}=K(x_i,x_j)
%  id_list:    a randomized ID list
%  options:    a struct containing rho, sigma, C, n_label and n_tick;
% Output:
%   err_count:  total number of training errors
%    run_time:  time consumed by this algorithm once
%    mistakes:  a vector of mistake rate
% mistake_idx:  a vector of number, in which every number corresponds to a
%               mistake rate in the vector above
%         SVs:  a vector records the number of support vectors
%     size_SV:  the size of final support set
%--------------------------------------------------------------------------

%% initialize parameters
eta = 1/2;
n_source = options.n_source;
C = options.C; % 1 by default
T_TICK = options.t_tick;
alpha1 = classifier.alpha;
SV1 = classifier.SV;
alpha2 = [];
SV2 = [];
ID = id_list;
err_count = 0;
mistakes = [];
mistakes_idx = [];
SVs = [];
TMs=[];
w_1t=1/2;
w_2t=1/2;

t_tick = T_TICK; %10;

%% loop
tic
for t = 1:length(ID),
    id = ID(t) + n_source;
    if (isempty(alpha1)), % init stage
        f1_t = 0;
    else
        k1_t = K1(id,SV1(:))';
        f1_t = alpha1*k1_t;            % decision function
    end
    
		id_target = ID(t);
    if (isempty(alpha2)),
        f2_t=0;
    else
        k2_t=K2(id_target,SV2(:))';
        f2_t=alpha2*k2_t;
    end
    
    hat_f1=max(0,min(1,(f1_t+1)/2));
    hat_f2=max(0,min(1,(f2_t+1)/2));
    f_t=w_1t*hat_f1+w_2t*hat_f2-1/2;
    
    hat_y_t = sign(f_t);        % prediction
    if (hat_y_t==0)
        hat_y_t=1;
    end
    % count accumulative mistakes
		y_t = Y(id_target);
    if (hat_y_t~=y_t),
        err_count = err_count + 1;
    end
    
    ell_1=(hat_f1-(y_t+1)/2)^2;
    ell_2=(hat_f2-(y_t+1)/2)^2;
    w_1t=w_1t*exp(-eta*ell_1);
    w_2t=w_2t*exp(-eta*ell_2);
    sum_w=w_1t+w_2t;
    w_1t=w_1t/sum_w;
    w_2t=w_2t/sum_w;
    
    l2_t = max(0,1-y_t*f2_t);   % hinge loss
    if (l2_t>0)
        % update
        s2_t=K2(id_target,id_target);
        gamma_t = min(C,l2_t/s2_t);
        alpha2 = [alpha2 y_t*gamma_t;];
        SV2 = [SV2 id_target];
    end
    run_time=toc;
    
    if t<T_TICK
        if (t==t_tick)
            mistakes = [mistakes err_count/t];
            mistakes_idx = [mistakes_idx t];
            SVs = [SVs length(SV1)+length(SV2)];
            TMs=[TMs run_time];
            
            t_tick=2*t_tick;
            if t_tick>=T_TICK,
                t_tick = T_TICK;
            end
            
        end
    else
        if (mod(t,t_tick)==0)
            mistakes = [mistakes err_count/t];
            mistakes_idx = [mistakes_idx t];
            SVs = [SVs length(SV1)+length(SV2)];
            TMs=[TMs run_time];
        end
    end
    
    
end
classifier.SV1 = SV1;
classifier.SV2 = SV2;
classifier.alpha1 = alpha1;
classifier.alpha1 = alpha2;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
