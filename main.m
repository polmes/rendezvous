%% INPUT

filename = 'input.mat';
[nodes, parameters] = util.readInput(filename);

database = 'solarsystem.mat';
solarSystem = util.readDatabase(database);

%% OPTIMIZE DELTA V TOTAL

initial = parameters; % keep initial guesses
dV = computeDeltaV(nodes, parameters);

%% OUTPUT

% something something 3D viewer
