function [nodes, parameters] = readInput(filename, solarSystem)
    data = load(filename);
    
    input = data.input;
    N = height(input);
    
    % Returns array of Nodes
    % Will mix [Node ... PlanetNode ... Node]
    nodes = Node.empty(0, N);
    
    % First
    nodes(1) = FirstNode;
    nodes(1) = nodes(1).setPlanet(solarSystem(input.node(1), :));
    
    % Mid
    for i = 2:N-1
        if input.node(i) == 0
            nodes(i) = Node;
        else
            nodes(i) = PlanetNode;
            
            % Populate planetary data
            planet = solarSystem(input.node(i), :);
            nodes(i) = nodes(i).setPlanet(planet);
        end
    end
    
    % Last
    nodes(N) = LastNode;
    nodes(N) = nodes(N).setPlanet(solarSystem(input.node(N), :));
    
    % Returns matrix of parameters [rx ry rz t]
    % [rx ry rz] will be Nan for PlanetNodes
    parameters = table2array(input(:, 1:2));
end
