function Y = predict_PA(K, h)

n_text = 1200 + 1600;
m_text = 1600;

Y = zeros(m_text, 1);

for i = 1 : m_text

	id = i + n_text - m_text;

  k_i = K(id, h.SV(:))';
	f_i = h.alpha * k_i;
	hat_y_i = sign(f_i);
	if (hat_y_i == 0)
		hat_y_i = 1;
	end
	
	Y(i) = hat_y_i;

end


