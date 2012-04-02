function [y] = sample(dist)
y = find(rand() < cumsum(dist), 1);
