function [classifier_1, err_count_1, mistakes_1, classifier_2, err_count_2, mistakes_2, run_time] = PA1_shared(Y_1, Kernel_1, Y_2, Kernel_2, options, id_list)
% PA1: online passive-aggressive algorithm
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
%               mistake rate in the vector above
%--------------------------------------------------------------------------

%% initialize parameters
C = options.C; % 1 by default
T_TICK = options.t_tick;
ID = id_list;

alpha_1 = [];
SV_1 = [];
err_count_1 = 0;
mistakes_1 = [];

alpha_2 = [];
SV_2 = [];
err_count_2 = 0;
mistakes_2 = [];

t_tick = T_TICK; %10;
%% loop
tic
for t = 1:length(ID),
    id = ID(t);
    
		% task 1
    if (isempty(alpha_1)), % init stage
        f_t_1 = 0;
    else
        k_t_1 = Kernel_1(id,SV_1(:))';
        f_t_1 = alpha_1*k_t_1;            % decision function
    end
    l_t_1 = max(0,1-Y_1(id)*f_t_1);   % hinge loss
    hat_y_t_1 = sign(f_t_1);        % prediction
    if (hat_y_t_1==0)
        hat_y_t_1=1;
    end
    % count accumulative mistakes
    if (hat_y_t_1~=Y_1(id)),
        err_count_1 = err_count_1 + 1;
    end
    
		% task 2
    if (isempty(alpha_2)), % init stage
        f_t_2 = 0;
    else
        k_t_2 = Kernel_2(id,SV_2(:))';
        f_t_2 = alpha_2*k_t_2;            % decision function
    end
    l_t_2 = max(0,1-Y_2(id)*f_t_2);   % hinge loss
    hat_y_t_2 = sign(f_t_2);        % prediction
    if (hat_y_t_2==0)
        hat_y_t_2=1;
    end
    % count accumulative mistakes
    if (hat_y_t_2~=Y_2(id)),
        err_count_2 = err_count_2 + 1;
    end
		%=================================

    
		theta = (sqrt(2) * max(l_t_1, l_t_2)) / C;
    if (l_t_1>0)
        % update
        s_t_1=Kernel_1(id,id);
        tau_t_1 = l_t_1/(s_t_1 + theta);
        alpha_1 = [alpha_1 Y_1(id)*tau_t_1;];
        SV_1 = [SV_1 id];
    end
    if (l_t_2>0)
        % update
        s_t_2=Kernel_2(id,id);
        tau_t_2 = l_t_2/(s_t_2 + theta);
        alpha_2 = [alpha_2 Y_2(id)*tau_t_2;];
        SV_2 = [SV_2 id];
    end

    run_time=toc;
    
    if t<T_TICK
        if (t==t_tick)
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
classifier_1.SV = SV_1;
classifier_1.alpha = alpha_1;
classifier_2.SV = SV_2;
classifier_2.alpha = alpha_2;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
