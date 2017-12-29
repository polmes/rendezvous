function [dV, nodes, dv, parameters] = optimize(nodes, parameters, optimizer)
    if strcmp(optimizer, 'none')
        [dV, nodes, dv] = computeDeltaV(nodes, parameters);
    elseif strcmp(optimizer, 'original')
        [dV, nodes, dv, parameters] = optimize.originalOptimizer(nodes, parameters);
    elseif strcmp(optimizer, 'scout')
        [dV, nodes, dv, parameters] = optimize.scoutOptimizer(nodes, parameters);
    elseif strcmp(optimizer, 'ran')
        [dV, nodes, dv, parameters] = optimize.scoutRanOptimizer(nodes, parameters);
    else
        throw(MException('optimize:optimizer', ...
            'Unknown optimizer type'));
    end
end
