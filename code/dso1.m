function [classifier_1, err_count_1, mistakes_1, classifier_2, err_count_2, mistakes_2, run_time] = dso1(X_1, Y_1, c_1_1, co_1, X_2, Y_2, c_2_2, co_2, options, id_list)
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

gamma_1_1 = options.gamma_1_1;
gamma_2_1 = options.gamma_2_1;
alpha_1_1 = options.alpha_1_1;
alpha_2_1 = options.alpha_2_1;
err_count_1 = 0;
mistakes_1 = [];
v_1 = zeros(1, size(X_1,2));

gamma_1_2 = options.gamma_1_2;
gamma_2_2 = options.gamma_2_2;
alpha_1_2 = options.alpha_1_2;
alpha_2_2 = options.alpha_2_2;
err_count_2 = 0;
mistakes_2 = [];
v_2 = zeros(1, size(X_2,2));

t_tick = T_TICK; %10;
%% loop
tic
for t = 1:length(ID),
    id = ID(t);

		% task 1
		x_t_1 = X_1(id,:);
		y_t_1 = Y_1(id);
		[temp, index] = max(c_1_1(id,:));
		x_t_1_2 = co_2(index,:);
		f_t_1 = alpha_1_1 * v_1*x_t_1' + alpha_2_1 * v_2*x_t_1_2';

    l_t_1 = max(0,1-y_t_1*f_t_1);   % hinge loss
    hat_y_t_1 = sign(f_t_1);        % prediction
    if (hat_y_t_1==0)
        hat_y_t_1=1;
    end
    % count accumulative mistakes
    if (hat_y_t_1~=y_t_1),
        err_count_1 = err_count_1 + 1;
    end

    if (l_t_1>0)
        % update
				tau_t_1 = min(C, (gamma_1_1*gamma_2_1*l_t_1)/(gamma_2_1*(alpha_1_1^2)*(x_t_1*x_t_1') + gamma_1_1*(alpha_2_1^2)*(x_t_1_2*x_t_1_2')));
				v_1 = v_1 + (alpha_1_1/gamma_1_1) * tau_t_1 * y_t_1 * x_t_1;
				v_2 = v_2 + (alpha_2_1/gamma_2_1) * tau_t_1 * y_t_1 * x_t_1_2;
    end
		%=================================
    
		% task 2
		x_t_2 = X_2(id,:);
		y_t_2 = Y_2(id);
		[temp, index] = max(c_2_2(id,:));
		x_t_2_1 = co_1(index,:);
		f_t_2 = alpha_1_2 * v_1*x_t_2_1' + alpha_2_2 * v_2*x_t_2';

    l_t_2 = max(0,1-y_t_2*f_t_2);   % hinge loss
    hat_y_t_2 = sign(f_t_2);        % prediction
    if (hat_y_t_2==0)
        hat_y_t_2=1;
    end
    % count accumulative mistakes
    if (hat_y_t_2~=y_t_2),
        err_count_2 = err_count_2 + 1;
    end
    
    if (l_t_2>0)
        % update
				tau_t_2 = min(C, (gamma_1_2*gamma_2_2*l_t_2)/(gamma_2_2*(alpha_1_2^2)*(x_t_2_1*x_t_2_1') + gamma_1_2*(alpha_2_2^2)*(x_t_2*x_t_2')));
				v_1 = v_1 + (alpha_1_2/gamma_1_2) * tau_t_2 * y_t_2 * x_t_2_1;
				v_2 = v_2 + (alpha_2_2/gamma_2_2) * tau_t_2 * y_t_2 * x_t_2;
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
classifier_1.v = v_1;
classifier_2.v = v_2;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
