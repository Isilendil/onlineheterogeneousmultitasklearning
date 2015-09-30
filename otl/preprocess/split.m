
select = 1;

switch select
	case 1
    file_name = 'books_dvd';
	case 2
    file_name = 'dvd_books';
	case 3
    file_name = 'kit_ele';
	case 4
    file_name = 'ele_kit';
end

load(sprintf('../original/%s', file_name));

Y = data(:,1);
X = data(:,2:end);

[n, d] = size(X);
d_source = round(d / 2);


load('ID_original');

X_target = X(ID_target, d_source+1:end);
X_source = X(ID_source, 1:d_source);
X_codata = X(ID_codata, :);

co_X_target = X_codata(:, d_source+1:end);
co_X_source = X_codata(:, 1:d_source);

Y_target = Y(ID_target);
Y_source = Y(ID_source);
Y_codata = Y(ID_codata);

switch select
	case 1
    save('../original/1', 'X_target', 'X_source', 'X_codata', 'Y_target', 'Y_source', 'Y_codata', 'co_X_target', 'co_X_source');
	case 2
    save('../original/2', 'X_target', 'X_source', 'X_codata', 'Y_target', 'Y_source', 'Y_codata', 'co_X_target', 'co_X_source');
	case 3
    save('../original/3', 'X_target', 'X_source', 'X_codata', 'Y_target', 'Y_source', 'Y_codata', 'co_X_target', 'co_X_source');
	case 4
    save('../original/4', 'X_target', 'X_source', 'X_codata', 'Y_target', 'Y_source', 'Y_codata', 'co_X_target', 'co_X_source');
end
