function [phi] = test_phi(x, y)
phi = zeros(1, 4 * 2 + 2);
n = size(x, 1);
for i = 1:n
    wi = y(i) * 4 - 3;
    phi(wi:wi + 3) = phi(wi:wi + 3) + [x(i, :), 1];
    if i < n
        wi = (y(i) == y(i + 1));
        phi(end - wi) = phi(end - wi) + 1;
    end
end
