function [vy] = gibbs(fg, vars, y, v, temp)
newphi = ones(1, vars(v).Arity) / temp;

for j = 1:numel(vars(v).Factor)
    f = vars(v).Factor(j);
    i = vars(v).Index(j);

    index = num2cell(y(fg(f).Member));
    index{i} = ':';
    newphi = newphi .* reshape(squeeze(fg(f).P(index{:})), 1, []);
end

vy = sample(normalize(newphi));
