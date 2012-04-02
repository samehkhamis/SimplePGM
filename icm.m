function [y] = icm(fg, y0, tmax)
vars = get_vars(fg);
n = numel(vars);
m = numel(fg);
if ~exist('y0', 'var'), y0 = ceil(rand(1, n) .* [vars.Arity]); end
if ~exist('tmax', 'var'), tmax = 100; end

y = y0;
for t = 1:tmax
    v = ceil(rand() * n);
    phi = ones(1, vars(v).Arity);
    
    for j = 1:numel(vars(v).Factor)
        f = vars(v).Factor(j);
        i = vars(v).Index(j);

        index = num2cell(y(fg(f).Member));
        index{i} = ':';
        phi = phi .* reshape(squeeze(fg(f).P(index{:})), 1, []);
    end
    
    [dummy, index] = max(phi);
    y(v) = index;
end
