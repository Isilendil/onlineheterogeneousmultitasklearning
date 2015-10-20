function Y = predict_PA(similarity, text_gnd, options)

n_text = 1200 + 1600;
m_text = 1600;

Y = zeros(m_text, 1);

K = options.K;

for i = 1 : m_text

  gnd = zeros(1, K);
	sim = zeros(1, K);

  for iter = 1 : K
	  [value, index] = max(similarity(i,:));
		gnd(iter) = text_gnd(index);
		sim(iter) = value;
		similarity(index) = 0;
	end
  
	sim = sim / sum(sim);
	f_i = gnd * sim';
	hat_y_i = sign(f_i);
	if (hat_y_i == 0)
		hat_y_i = 1;
	end

	Y(i) = hat_y_i;

end


