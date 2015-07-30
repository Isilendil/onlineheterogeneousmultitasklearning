function [classifier_1, err_count_1, run_time, mistakes_1, mistakes_idx, SVs, TMs] = dso(Kernel_1, Y_1, c_1_1, Kernel_2, Y_2, c_2_2, options, id_list)
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
m = options.m;

gamma_1_1 = options.gamma_1_1;
gamma_2_1 = options.gamma_2_1;
alpha_1_1 = options.alpha_1_1;
alpha_2_1 = options.alpha_2_1;
err_count_1 = 0;
mistakes_1 = [];
alpha_1 = [];
SV_1 = [];

mistakes_idx = [];
SVs = [];
TMs = [];


gamma_1_2 = options.gamma_1_2;
gamma_2_2 = options.gamma_2_2;
alpha_1_2 = options.alpha_1_2;
alpha_2_2 = options.alpha_2_2;
err_count_2 = 0;
mistakes_2 = [];
alpha_2 = [];
SV_2 = [];

t_tick = T_TICK; %10;

index = 0;
%% loop
tic
for t = 1:length(ID),
    id = ID(t);

		% task 1
    if (isempty(alpha_1))
			f_t_1_1 = 0;
		else
			k_t_1_1 = Kernel_1(id, SV_1(:))';
			f_t_1_1 = alpha_1 * k_t_1_1;
		end
		[temp, index] = max(c_1_1(id,:));
		index = index + m;
		if (isempty(alpha_2))
			f_t_1_2 = 0;
		else
			k_t_1_2 = Kernel_2(index,SV_2(:))';
			f_t_1_2 = alpha_2 * k_t_1_2;
    end
		f_t_1 = alpha_1_1 * f_t_1_1 + alpha_2_1 * f_t_1_2;

		y_t_1 = Y_1(id);

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
				s_t_1_2 = Kernel_2(index, index);
				tau_t_1 = min(C, (gamma_1_1*gamma_2_1*l_t_1)/(gamma_2_1*(alpha_1_1^2)*s_t_1 + gamma_1_1*(alpha_2_1^2)*s_t_1_2));
				alpha_1 = [alpha_1 (alpha_1_1/gamma_1_1)*tau_t_1*y_t_1];
				SV_1 = [SV_1 id];
				alpha_2 = [alpha_2 (alpha_2_1/gamma_2_1)*tau_t_1*y_t_1];
				SV_2 = [SV_2 index];
    end
		%=================================
    
		% task 2
		if (isempty(alpha_2))
			f_t_2_2 = 0;
		else
      k_t_2_2 = Kernel_2(id, SV_2(:))';
			f_t_2_2 = alpha_2 * k_t_2_2;
		end
		[temp, index] = max(c_2_2(id,:));
		index = index + m;
		if (isempty(alpha_1))
			f_t_2_1 = 0;
		else
      k_t_2_1 = Kernel_1(index,SV_1(:))';
			f_t_2_1 = alpha_1 * k_t_2_1;
		end

		f_t_2 = alpha_1_2 * f_t_2_1 + alpha_2_2 * f_t_2_2;

		y_t_2 = Y_2(id);

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
				s_t_2_1 = Kernel_1(index, index);
				tau_t_2 = min(C, (gamma_1_2*gamma_2_2*l_t_2)/(gamma_2_2*(alpha_1_2^2)*s_t_2_1 + gamma_1_2*(alpha_2_2^2)*s_t_2));
				alpha_1 = [alpha_1 (alpha_1_2/gamma_1_2)*tau_t_2*y_t_2];
				SV_1 = [SV_1 index];
				alpha_2 = [alpha_2 (alpha_2_2/gamma_2_2)*tau_t_2*y_t_2];
				SV_2 = [SV_2 id];
    end

    run_time=toc;
    
    if t<T_TICK
        if (t==t_tick)
            mistakes_1 = [mistakes_1 err_count_1/t];
            mistakes_2 = [mistakes_2 err_count_2/t];
            

						mistakes_idx = [mistakes_idx t];
						SVs = [SVs length(SV_1)];
						TMs = [TMs run_time];
            
            t_tick=2*t_tick;
            if t_tick>=T_TICK,
                t_tick = T_TICK;
            end
        end
    else
        if (mod(t,t_tick)==0)
            mistakes_1 = [mistakes_1 err_count_1/t];
            mistakes_2 = [mistakes_2 err_count_2/t];

						mistakes_idx = [mistakes_idx t];
						SVs = [SVs length(SV_1)];
						TMs = [TMs run_time];
            
        end
    end
    
end
classifier_1.alpha_1 = alpha_1;
classifier_1.SV_1 = SV_1;
classifier_1.alpha_2 = alpha_2;
classifier_1.SV_2 = SV_2;

classifier_2.alpha_2 = alpha_2;
classifier_2.SV = SV_2;
%fprintf(1,'The number of mistakes = %d\n', err_count);
run_time = toc;
