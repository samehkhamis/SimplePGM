function [w] = cuttingplane(X, Y, w0, C, modelfunc, phifunc, inferfunc, varargin)
n = numel(X);
w = w0;
eta = 0;

% QP variables
H = diag([ones(numel(w), 1); 0]);
f = [zeros(numel(w), 1); C];
A = [zeros(1, numel(w)), -1];
b = [0];

while true
    avgphi = zeros(size(w));
    avgloss = 0;

    for i = 1:n
        fg = modelfunc(X{i}, w, Y{i});

        maxlossy = get_labels(inferfunc(fg, varargin{:}));
        maxlossphi = phifunc(X{i}, maxlossy);
        truephi = phifunc(X{i}, Y{i});
        avgphi = avgphi + maxlossphi - truephi;
        avgloss = avgloss + sum(maxlossy ~= Y{i});
    end

    avgphi = avgphi / n;
    avgloss = avgloss / n;

    error = avgloss - w * avgphi' - eta;
    if error < 1e-6
        break;
    end

    % Add the constraint and solve the QP
    A = [A; -avgphi, -1];
    b = [b; -avgloss];
    opt = optimset('LargeScale', 'off', 'Display', 'off');
    w = quadprog(H, f, A, b, [], [], [], [], [w, eta], opt);
    eta = w(end);
    w = w(1:end - 1)';
end
