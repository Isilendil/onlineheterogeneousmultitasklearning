
m_old = 100;
m_new = 500;

load('../../../TextImage/data/ID');

ID_old = randperm(m_old);
ID_new = ID + m_old;

save('ID_hom', 'ID_old', 'ID_new');
