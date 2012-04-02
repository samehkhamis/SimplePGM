function [belprod] = belief_prod(bel)
if numel(bel) == 0
    belprod = 1;
elseif numel(bel) == 1
    belprod = reshape(bel{1}, [], 1);
else
    belgrid = cell(1, numel(bel));
    [belgrid{:}] = ndgrid(bel{:});
    belprod = prod(cat(3, belgrid{:}), 3);
end
