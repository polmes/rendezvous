function dV = computeDeltaV(nodes, parameters)
    N = length(nodes);
    
    for i = 1:N
       nodes(i).setPositionAndTime(parameters(i));
    end

    for i = 1:N-1
        [nodes(i).vo, nodes(i+1).vi] = lambert(nodes(i), nodes(i+1));
    end

    dv = zeros(1, N-1);
    for i = 1:N
        dv(i) = nodes(i).computeDeltaV();
    end

    dV = sum(dv);
end
