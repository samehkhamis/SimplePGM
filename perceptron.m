function [w] = perceptron(X, Y, w0, tmax, modelfunc, phifunc, inferfunc, varargin)
n = numel(X);
w = w0;

for t = 1:tmax
    i = ceil(rand() * n);
    fg = modelfunc(X{i}, w);
    
    maxy = get_labels(inferfunc(fg, varargin{:}));
    if any(maxy ~= Y{i})
        maxphi = phifunc(X{i}, maxy);
        truephi = phifunc(X{i}, Y{i});
        w = w + (maxphi - truephi);
    end
end
