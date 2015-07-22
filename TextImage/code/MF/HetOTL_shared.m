function [classifier_1, err_count_1, mistakes_1, classifier_2, err_count_2, mistakes_2, run_time] = HetOTL_shared(Kernel_1, Y_1, c_1_1, Kernel_2, Y_2, c_2_2, options, id_list)
% HetOTL: HetOTL
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
gamma1 = options.gamma1;
gamma2 = options.gamma2;
C = options.C; % 1 by default
m = options.m;
T_TICK = options.t_tick;
alpha1 = [];
SV1 = [];
err_count_1 = 0;
mistakes_1 = [];
alpha2 = [];
SV2 = [];
mistakes_2 = [];
err_count_2 = 0;
ID = id_list;

t_tick = 10;
%% loop
tic
for t = 1:length(ID),
    id = ID(t);

		% task 1
    if (isempty(alpha1)), % init stage
        f1_t = 0;
    else
        k1_t = Kernel_1(id,SV1(:))';
        f1_t = alpha1*k1_t;            % decision function
    end
		[temp, index] = max(c_1_1(id,:));
		id2 = index + m;
    if (isempty(alpha2)), % init stage
        f2_t = 0;
    else
        k2_t = Kernel_2(id2,SV2(:))';
        f2_t = alpha2*k2_t;            % decision function
    end
    f_t=(f1_t+f2_t)/2;
    l_t = max(0,1-Y_1(id)*f_t);   % hinge loss
    hat_y_t = sign(f_t);        % prediction
    if (hat_y_t==0)
        hat_y_t=1;
    end
    % count accumulative mistakes
    if (hat_y_t~=Y_1(id)),
        err_count_1 = err_count_1 + 1;
    end
    
    if (l_t>0)
        % update
        s1_t=Kernel_1(id,id);
        s2_t=Kernel_2(id2,id2);
        tau_t=min(C, 4*gamma1*gamma2*l_t/(s1_t*gamma2+s2_t*gamma1));
        
        gamma1_t =tau_t/(2*gamma1);
        alpha1 = [alpha1 Y_1(id)*gamma1_t];
        SV1 = [SV1 id];
        
        gamma2_t = tau_t/(2*gamma2);
        alpha2 = [alpha2 Y_1(id)*gamma2_t];
        SV2 = [SV2 id2];
    end

		% task 2
    if (isempty(alpha2)), % init stage
        f2_t = 0;
    else
        k2_t = Kernel_2(id,SV2(:))';
        f2_t = alpha2*k2_t;            % decision function
    end
		[temp, index] = max(c_2_2(id,:));
		id1 = index + m;
    if (isempty(alpha1)), % init stage
        f1_t = 0;
    else
        k1_t = Kernel_1(id1,SV1(:))';
        f1_t = alpha1*k1_t;            % decision function
    end
    f_t=(f1_t+f2_t)/2;
    l_t = max(0,1-Y_2(id)*f_t);   % hinge loss
    hat_y_t = sign(f_t);        % prediction
    if (hat_y_t==0)
        hat_y_t=1;
    end
    % count accumulative mistakes
    if (hat_y_t~=Y_2(id)),
        err_count_2 = err_count_2 + 1;
    end
    
    if (l_t>0)
        % update
        s2_t=Kernel_2(id,id);
        s1_t=Kernel_1(id1,id1);
        tau_t=min(C, 4*gamma1*gamma2*l_t/(s1_t*gamma2+s2_t*gamma1));
        
        gamma1_t =tau_t/(2*gamma1);
        alpha1 = [alpha1 Y_2(id)*gamma1_t];
        SV1 = [SV1 id1];
        
        gamma2_t = tau_t/(2*gamma2);
        alpha2 = [alpha2 Y_2(id)*gamma2_t];
        SV2 = [SV2 id];
    end

    run_time=toc;
    if t<T_TICK
        if (mod(t,t_tick)==0)
            mistakes_1 = [mistakes_1 err_count_1/t];
            mistakes_2 = [mistakes_2 err_count_2/t];
            
            t_tick=2*t_tick;
            if t_tick>=T_TICK,
                t_tick = T_TICK;
            end
        end
    else
        if (mod(t,t_tick)==0)
            mistakes_1 = [mistakes_1 err_count_1/t];
            mistakes_2 = [mistakes_2 err_count_2/t];
        end
    end
end
classifier_1.SV1 = SV1;
classifier_2.SV2 = SV2;
classifier_1.alpha1 = alpha1;
classifier_2.alpha2 = alpha2;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
