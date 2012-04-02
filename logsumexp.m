function [v] = logsumexp(x)
[dummy, i] = max(abs(x));
v = log(sum(exp(x - x(i)))) + x(i);
