function [classifier_1, err_count_1, mistakes_1, classifier_2, err_count_2, mistakes_2, run_time] = PA1_extra(Kernel_1, Y_1, c_1_1, Kernel_2, Y_2, c_2_2, options, id_list)
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
K = options.K;
ID = id_list;
eta = options.eta;

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
		y_t_1 = Y_1(id);
		if (isempty(alpha_1))
			f_t_1 = 0;
		else
			k_t_1 = Kernel_1(id, SV_1(:))';
			f_t_1 = alpha_1 * k_t_1;
		end

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
				s_t_1 = Kernel_1(id, id);
				%tau_t_1 = min(C, l_t_1/s_t_1);
				tau_t_1 = l_t_1/(s_t_1+1/(2*C));
		    alpha_1 = [alpha_1 y_t_1*tau_t_1;];
		    SV_1 = [SV_1 id];
    end

		%=================================
    
		% task 2
		y_t_2 = Y_2(id);
		if (isempty(alpha_2))
			f_t_2 = 0;
		else
			k_t_2 = Kernel_2(id, SV_2(:))';
			f_t_2 = alpha_2 * k_t_2;
		end

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
				s_t_2 = Kernel_2(id, id);
				%tau_t_2 = min(C, l_t_2/s_t_2);
				tau_t_2 = l_t_2/(s_t_2+1/(2*C));
		    alpha_2 = [alpha_2 y_t_2*tau_t_2];
				SV_2 = [SV_2 id];
    end

    %=================================

    e_t_1 = err_count_1 / t;
		e_t_2 = err_count_2 / t;
		if (e_t_1 + e_t_2 ~= 0)
		  tau_t_1_2 = eta * (1 - e_t_1/(e_t_1+e_t_2));
		  tau_t_2_1 = eta * (1 - e_t_2/(e_t_1+e_t_2));
		else
			tau_t_1_2 = eta;
			tau_t_2_1 = eta;
		end

		sim_vec_1 = c_1_1(id,:);
    sim = zeros(1, K);
    index = zeros(1, K);
		for i = 1 : K
		  [sim(i), index(i)] = max(sim_vec_1);
			sim_vec_1(index(i)) = 0;
		  index(i) = index(i) + m;
		end
		%sim = sim / sum(sim);
		for i = 1 : K
		  if (isempty(alpha_2))
		    f_t_1_2 = 0;
		  else
		    k_t_1_2 = Kernel_2(index(i), SV_2(:))';
        f_t_1_2 = alpha_2 * k_t_1_2;
		  end
		  l_t_1_2 = max(0, 1 - y_t_1*f_t_1_2);
		  l_t_1_2 = min(l_t_1_2, 1);
		  if (l_t_1_2 > 0)
			  s_t_1_2 = Kernel_2(index(i), index(i));
			  %tau_t_1_2 = 0.5 * min(C, l_t_1_2/s_t_1_2);
			  %tau_t_1_2 = sim(i) * l_t_1_2/(s_t_1_2+1/(2*C));
			  %tau_t_1_2 = sim(i);
			  alpha_2 = [alpha_2 y_t_1*tau_t_1_2];
			  SV_2 = [SV_2 index(i)];
		  end
		end

		sim_vec_2 = c_2_2(id,:);
    sim = zeros(1, K);
    index = zeros(1, K);
		for i = 1 : K
		  [sim(i), index(i)] = max(sim_vec_2);
			sim_vec_2(index(i)) = 0;
		  index(i) = index(i) + m;
		end
		%sim = sim / sum(sim);
		for i = 1 : K
      if (isempty(alpha_1))
			  f_t_2_1 = 0;
		  else
			  k_t_2_1 = Kernel_1(index(i), SV_1(:))';
			  f_t_2_1 = alpha_1 * k_t_2_1;
		  end
		  l_t_2_1 = max(0, 1-y_t_2*f_t_2_1);
		  l_t_2_1 = min(l_t_2_1, 1);
		  if (l_t_2_1 > 0)
			  s_t_2_1 = Kernel_1(index(i), index(i));
			  %tau_t_2_1 = 0.5 * min(C, l_t_2_1/s_t_2_1);
			  %tau_t_2_1 = sim(i) * l_t_2_1/(s_t_2_1+1/(2*C));
				%tau_t_2_1 = sim(i);
			  alpha_1 = [alpha_1 y_t_2*tau_t_2_1];
			  SV_1 = [SV_1 index(i)];
      end
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
classifier_1.alpha_1 = alpha_1;
classifier_1.SV_1 = SV_1;
classifier_2.alpha_2 = alpha_2;
classifier_2.SV_2 = SV_2;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
