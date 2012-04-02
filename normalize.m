function [x] = normalize(x)
x = x ./ sum(x(:));
% normalize(exp(x)) === exp(x - log(sum(exp(x(:)))))
