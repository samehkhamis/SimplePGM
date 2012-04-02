function [en] = get_energy(fg, y)
en = 0;
for f = 1:numel(fg)
    index = num2cell(y(fg(f).Member));
    en = en - log(fg(f).P(index{:}) + 1e-8);
end
