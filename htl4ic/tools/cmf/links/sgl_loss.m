function value = sgl_loss(scale,margin,X,W,AB,f)

NewParams = scale .* (margin + AB);
value = logloss(X,W,NewParams,f);
