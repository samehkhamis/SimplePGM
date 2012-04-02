function [belsum] = belief_sum(bel)
if numel(bel) == 0
    belsum = 0;
elseif numel(bel) == 1
    belsum = reshape(bel{1}, [], 1);
else
    belgrid = cell(1, numel(bel));
    [belgrid{:}] = ndgrid(bel{:});
    belsum = sum(cat(3, belgrid{:}), 3);
end
