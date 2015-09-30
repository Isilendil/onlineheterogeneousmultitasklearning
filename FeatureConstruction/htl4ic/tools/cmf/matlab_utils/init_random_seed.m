function init_random_seed( )

fprintf(1, 'Initalizing random number generator (rand)...\n');
rand('state', sum(100*clock));
