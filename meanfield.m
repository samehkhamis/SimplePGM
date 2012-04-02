function [muv, muf, logz] = meanfield(fg, tmax, tol)
vars = get_vars(fg);
n = numel(vars);
m = numel(fg);
if ~exist('tmax', 'var'), tmax = 100; end
if ~exist('tol', 'var'), tol = 1e-6; end

muv = arrayfun(@(x) zeros(1, x), [vars.Arity], 'UniformOutput', false);
for t = 1:tmax
    muvnew = cell(1, n);
    for v = 1:n
        % Belief update
        belsum = ones(1, vars(v).Arity);
        for j = 1:numel(vars(v).Factor)
            f = vars(v).Factor(j);
            i = vars(v).Index(j);
            
            % Product of factor members beliefs, except me
            belprod = belief_prod(muv(fg(f).Member([1:i - 1, i + 1:end])));
            
            for y = 1:vars(v).Arity
                index = cell(1, vars(v).Arity);
                [index{:}] = deal(':');
                index{i} = y;
                logphi = log(squeeze(fg(f).P(index{:})) + 1e-8);
                belsum(y) = belsum(y) + sum(belprod(:) .* logphi(:));
            end
        end
        
        muvnew{v} = normalize(exp(belsum));
    end
    
    % Convergence test
    delta = max([muvnew{:}] - [muv{:}]);
    muv = muvnew;
    if delta <= tol, break; end
end

% Approximate factor beliefs
if nargout >= 2
    muf = cell(1, m);
    for f = 1:m
        muf{f} = belief_prod(muv(fg(f).Member));
    end
end

if nargout >= 3
    logz = get_gibbs_logz(fg, vars, muv, muf);
end
