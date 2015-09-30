
function [v,ok] = normalize_vec(x)
    v = x;
    s = sum(v);
    if s > 0
        v = v./s;
        ok = true;
    else
        ok = false;
    end
