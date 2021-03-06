function [nodes, parameters] = readInput(filename, solarSystem)
    data = load(filename);
    
    input = data.input;
    N = height(input);
    
    % Returns array of mixed Nodes
    % [FirstNode ... Node ... PlanetNode ... Node ... LastNode]
    nodes = Node.empty(0, N);
    
    % First
    nodes(1) = FirstNode;
    nodes(1) = nodes(1).setPlanet(solarSystem(input.node(1), :));
    nodes(1).eff = input.eff(1);
    
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
        
        % Add efficiency property for deltaV computation
        nodes(i).eff = input.eff(i);
    end
    
    % Last
    nodes(N) = LastNode;
    nodes(N) = nodes(N).setPlanet(solarSystem(input.node(N), :));
    nodes(N).eff = input.eff(N);
    
    % Returns matrix of parameters [rx ry rz t]
    % [rx ry rz] will be NaN for PlanetNodes
    parameters = table2array(input(:, 1:2));
end
