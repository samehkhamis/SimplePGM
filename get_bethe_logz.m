function [logz] = get_bethe_logz(fg, vars, muv, muf)
logz = 0;
for v = 1:numel(vars)
    logz = logz + (numel(vars(v).Factor) - 1) * sum(muv{v} .* log(muv{v} + 1e-8));
end
for f = 1:numel(fg)
    logz = logz + sum(muf{f}(:) .* (log(fg(f).P(:) + 1e-8) - log(muf{f}(:) + 1e-8)));
end
