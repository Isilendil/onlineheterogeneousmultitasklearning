function [ ] = check_dims(M, r, c, msg)

  sz = size(M);
  assert(all(sz == [r c]), '%s: expected %d x %d, got %d x %d', ...
         msg, r, c, sz(1), sz(2));

