function [dV, nodes] = computeDeltaV(nodes, parameters)
    N = length(nodes);
    
    for i = 1:N
       nodes(i) = nodes(i).setPositionAndTime(parameters(i, :));
    end
    
    [~, v_planet] = nodes(1).orbit.toIJK(nodes(1).t);
    nodes(1).vi = v_planet;
    for i = 1:N-1
        [nodes(i).vo, nodes(i+1).vi] = lambert(nodes(i), nodes(i+1));   
    end

    dv = zeros(1, N-1);
    for i = 1:N
        dv(i) = nodes(i).getDeltaV();
    end

    dV = sum(dv);
end
