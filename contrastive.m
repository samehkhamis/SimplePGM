function [w] = contrastive(X, Y, w0, tmax, lambda, eta, modelfunc, phifunc, samplefunc)
n = numel(X);
w = w0;
if ~exist('samplefunc', 'var'), samplefunc = @gibbs; end

for t = 1:tmax
    i = ceil(rand() * n);
    fg = modelfunc(X{i}, w);
    vars = get_vars(fg);
    
    cdy = Y{i};
    v = ceil(rand() * numel(cdy));
    cdy(v) = samplefunc(fg, vars, cdy, v, 1);
    
    cdphi = phifunc(X{i}, cdy);
    truephi = phifunc(X{i}, Y{i});
    g = lambda * w + (cdphi - truephi);
    w = w + eta * g;
end
