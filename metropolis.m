function [vy] = metropolis(fg, vars, y, v, temp)
newphi = 1 / temp;
oldphi = 1 / temp;
vys = [1:y(v) - 1, y(v) + 1:vars(v).Arity];
vy = vys(ceil(rand() * (vars(v).Arity - 1)));

for j = 1:numel(vars(v).Factor)
    f = vars(v).Factor(j);
    i = vars(v).Index(j);

    index = num2cell(y(fg(f).Member));
    oldphi = oldphi .* fg(f).P(index{:});
    index{i} = vy;
    newphi = newphi .* fg(f).P(index{:});
end

if rand() > min(1, newphi / oldphi)
    vy = y(v);
end
