function [classifier, err_count, run_time, mistakes] = PA1_fea(Y, Kernel, c_1_1, options, id_list)
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
m = options.m;
alpha = [];
SV = [];
ID = id_list;
err_count = 0;
mistakes = [];

t_tick = T_TICK; %10;
%% loop
tic
for t = 1:length(ID),
    id = ID(t);

    [temp, index] = max(c_1_1(id,:));
		index = index + m;
    
    if (isempty(alpha)), % init stage
        f_t = 0;
    else
        k_t = Kernel(index,SV(:))';
        f_t = alpha*k_t;            % decision function
    end
    l_t = max(0,1-Y(id)*f_t);   % hinge loss
    hat_y_t = sign(f_t);        % prediction
    if (hat_y_t==0)
        hat_y_t=1;
    end
    % count accumulative mistakes
    if (hat_y_t~=Y(id)),
        err_count = err_count + 1;
    end
    
    if (l_t>0)
        % update
        s_t=Kernel(index,index);
        tau_t = min(C,l_t/s_t);
        %tau_t = l_t/(s_t+1/(2*C));
        alpha = [alpha Y(id)*tau_t;];
        SV = [SV index];
    end
    run_time=toc;
    
    if t<T_TICK
        if (t==t_tick)
            mistakes = [mistakes err_count/t];
            
            t_tick=2*t_tick;
            if t_tick>=T_TICK,
                t_tick = T_TICK;
            end
        end
    else
        if (mod(t,t_tick)==0)
            mistakes = [mistakes err_count/t];
        end
    end
    
end
classifier.SV = SV;
classifier.alpha = alpha;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
