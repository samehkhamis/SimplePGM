function [w] = maxlikelihood(X, Y, w0, C, modelfunc, phifunc, expectedphifunc, inferfunc, varargin)
opt = optimset('GradObj', 'on', 'LargeScale', 'off', 'Display', 'off');
w = fminunc(@(x) nll(x, C, X, Y, modelfunc, phifunc, expectedphifunc, inferfunc), w0, opt);

function [v, dv] = nll(w, lambda, X, Y, modelfunc, phifunc, expectedphifunc, inferfunc, varargin)
n = numel(X);
v = lambda * sum(w.^2);
if nargout >= 2
    dv = 2 * lambda * w;
end

for i = 1:n
    fg = modelfunc(X{i}, w);
    
    [muv, muf, logz] = inferfunc(fg, varargin{:});
    truephi = phifunc(X{i}, Y{i});
    v = v + w * truephi' + logz;
    
    if nargout >= 2
        expphi = expectedphifunc(X{i}, fg, muf);
        dv = dv + truephi - expphi;
    end
end
