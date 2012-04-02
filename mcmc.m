function [muv, muf, logz] = mcmc(fg, samplefunc, y0, count, burn, interval, temp)
vars = get_vars(fg);
n = numel(vars);
m = numel(fg);
if ~exist('samplefunc', 'var'), samplefunc = @gibbs; end
if ~exist('y0', 'var'), y0 = ceil(rand(1, n) .* [vars.Arity]); end
if ~exist('count', 'var'), count = 100; end
if ~exist('burn', 'var'), burn = 1000; end
if ~exist('interval', 'var'), interval = 10; end
if ~exist('temp', 'var'), temp = 1; end

muv = arrayfun(@(x) zeros(1, x), [vars.Arity], 'UniformOutput', false);
if nargout >= 2
    muf = cellfun(@(x) zeros(size(x)), {fg.P}, 'UniformOutput', false);
    if nargout >= 3
        samples = zeros(count, n);
    end
end

y = y0;
for k = 1:burn
    % Randomly sample one variable
    v = ceil(rand() * n);
    y(v) = samplefunc(fg, vars, y, v, temp);
end

total = count * interval;
for k = 1:total
    % Randomly sample one variable
    v = ceil(rand() * n);
    y(v) = samplefunc(fg, vars, y, v, temp);
    
    % Increment belief for current sample every interval
    if mod(k, interval) == 0
        for v = 1:n
            index = y(v);
            muv{v}(index) = muv{v}(index) + 1;
        end
        if nargout >= 2
            for f = 1:m
                index = num2cell(y(fg(f).Member));
                muf{f}(index{:}) = muf{f}(index{:}) + 1;
            end
            if nargout >= 3
                samples(fix(k / interval), :) = y;
            end
        end
    end
end

for v = 1:n
    muv{v} = normalize(muv{v});
end

if nargout >= 2
    for f = 1:m
        muf{f} = normalize(muf{f});
    end
end

if nargout >= 3
    samples = unique(samples, 'rows');
    logz = 0;
    for k = 1:size(samples, 1)
        logz = logz + exp(-get_energy(fg, samples(k, :)));
    end
    logz = log(logz);
end
