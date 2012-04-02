function [muv, muf, logz] = lbp_sp(fg, tmax, tol)
vars = get_vars(fg);
n = numel(vars);
m = numel(fg);
if ~exist('tmax', 'var'), tmax = 100; end
if ~exist('tol', 'var'), tol = 1e-6; end

rfunc = @(x) logsumexp(x);
qfunc = @(x) logsumexp(x);

% Factor-to-variable messages
r = cell(1, n);
for i = 1:n
    r{i} = cell(1, numel(vars(i).Factor));
    [r{i}{:}] = deal(zeros(1, vars(i).Arity));
end

% Variable-to-factor messages
q = cell(1, m);
for i = 1:m
    q{i} = cell(1, numel(fg(i).Member));
    for j = 1:numel(q{i})
        q{i}{j} = zeros(1, vars(fg(i).Member(j)).Arity);
    end
end

muv = arrayfun(@(x) zeros(1, x), [vars.Arity], 'UniformOutput', false);
for t = 1:tmax
    % Factor-to-variable messages
    for v = 1:n
        for j = 1:numel(vars(v).Factor)
            f = vars(v).Factor(j);
            i = vars(v).Index(j);
            
            % Sum of factor members beliefs, except me
            belsum = belief_sum(q{f}([1:i - 1, i + 1:end]));
            
            for y = 1:vars(v).Arity
                index = cell(1, vars(v).Arity);
                [index{:}] = deal(':');
                index{i} = y;
                logphi = log(squeeze(fg(f).P(index{:})) + 1e-8);
                
                r{v}{j}(y) = rfunc(logphi(:) + belsum(:));
            end
        end
    end
    
    % Variable-to-factor messages
    for v = 1:n
        for j = 1:numel(vars(v).Factor)
            f = vars(v).Factor(j);
            i = vars(v).Index(j);
            
            rv = r{v}([1:j - 1, j + 1:end]);
            rv = sum(cat(1, rv{:}), 1);
            q{f}{i} = rv - qfunc(rv);
        end
    end
    
    % Variable beliefs
    muvnew = cell(1, n);
    for v = 1:n
        muvnew{v} = normalize(exp(sum(cat(1, r{v}{:}), 1)));
    end
    
    % Convergence test
    delta = max([muvnew{:}] - [muv{:}]);
    muv = muvnew;
    if delta <= tol, break; end
end

% Factor beliefs
if nargout >= 2
    muf = cell(1, m);
    for f = 1:m
        belsum = belief_sum(q{f});
        logphi = log(fg(f).P + 1e-8);
        qf = logphi + belsum;

        muf{f} = normalize(exp(qf));
    end
end

% Log partition function
if nargout >= 3
    logz = get_bethe_logz(fg, vars, muv, muf);
end
