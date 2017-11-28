function [nodes, parameters] = readInput(filename)
    data = load(filename);
    
    % nodes = Node.empty(0, N);
    nodes(1) = Node;
    nodes(2) = Node;
    nodes(3) = PlanetNode;
    nodes(4) = Node;
    
    % parameters = {};
    % Need to define format of node parameters cell array
    parameters = data;
end
