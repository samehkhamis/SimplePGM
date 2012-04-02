function [fg] = test_model(x, w, y)
n = size(x, 1);
lossaug = exist('y', 'var');
nclass = (numel(w) - 2) / 4;

fg = struct('Member', cell(1, 2 * n - 1), 'P', cell(1, 2 * n - 1));

for f = 1:n
    loss = zeros(nclass, 1);
    if lossaug
        loss(y(f)) = 1;
    end
    fg(f).Member = [f];
    fg(f).P = exp(-(reshape(w(1:end - 2), 4, [])' * [x(f, :), 1]' + loss));
end

for f = n + 1:2 * n - 1
    fg(f).Member = [f - n, f - n + 1];
    fg(f).P = exp(-[w(end - 1), w(end); w(end), w(end - 1)]);
end
