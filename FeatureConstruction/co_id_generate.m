
lengths = [200, 400, 600, 800, 1000, 1600];

co_id_200 = randperm(200);
co_id_400 = randperm(400);
co_id_600 = randperm(600);
co_id_800 = randperm(800);
co_id_1000 = randperm(1000);
co_id_1600 = randperm(1600);

save('co_id', 'co_id_200', 'co_id_400', 'co_id_600', 'co_id_800', 'co_id_1000', 'co_id_1600');
