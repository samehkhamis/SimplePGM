function [vars] = get_vars(fg)
n = max(unique([fg.Member]));
vars = struct('Arity', cell(1, n), 'Factor', cell(1, n), 'Index', cell(1, n));
for i = 1:n
    % Variable factors
    [f, j] = arrayfun(@(f) find(f.Member == i, 1), fg, 'UniformOutput', false);
    vars(i).Factor = find(cellfun(@(x) ~isempty(x), f));
    vars(i).Index = [j{:}];
    
    % Variable arity
    fac = fg(vars(i).Factor(1));
    [dummy, j] = find(fac.Member == i, 1);
    vars(i).Arity = size(fac.P, j);
end
