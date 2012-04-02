function [phi] = test_mlexpectedphi(x, fg, muf)
phi = zeros(1, 4 * 2 + 2);
for f = 1:numel(fg)
    i = fg(f).Member(1);
    if numel(fg(f).Member) == 1
        phi(1:8) = phi(1:8) + reshape([x(i, :), 1]' * muf{f}', 1, []);
    else
        phi(end - 1:end) = phi(end - 1:end) + [sum(muf{f}([1, 4])), sum(muf{f}([2, 3]))];
    end
end
