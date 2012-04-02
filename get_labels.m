function [y] = get_labels(muv)
[dummy, y] = cellfun(@max, muv);
