function [y] = annealing(fg, samplefunc, y0, count, temp)
vars = get_vars(fg);
n = numel(vars);
m = numel(fg);
if ~exist('samplefunc', 'var'), samplefunc = @gibbs; end
if ~exist('y0', 'var'), y0 = ceil(rand(1, n) .* [vars.Arity]); end
if ~exist('count', 'var'), count = 100; end
if ~exist('temp', 'var'), temp = 1; end

y = y0;
besty = y;
besten = get_energy(fg, y);

for k = 1:count
    % Randomly sample one variable
    v = ceil(rand() * n);
    y(v) = samplefunc(fg, vars, y, v, temp);
    en = get_energy(fg, y);
    
    if en < besten
        besten = en;
        besty = y;
    end
end

y = besty;
