function [nodes, parameters] = readInput(filename, solarSystem)
    data = load(filename);
    
    input = data.input;
    N = height(input);
    
    % Returns array of Nodes
    % Will mix [Node ... PlanetNode ... Node]
    nodes = Node.empty(0, N);
    for i = 1:N
        if input.node(i) == 0
            nodes(i) = Node;
        else
            nodes(i) = PlanetNode;
            
            % Populate planetary data
            planet = solarSystem(input.node(i), :);
            nodes(i).orbit = planet.orbit;
            nodes(i).mu = planet.mu;
            nodes(i).radius = planet.radius;
        end
    end
    
    % Returns matrix of parameters [rx ry rz t]
    % [rx ry rz] will be Nan for PlanetNodes
    parameters = table2array(input(:, 1:2));
end
