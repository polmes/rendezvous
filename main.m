%% INIT

global GM;
G = 6.67408e-11; % Universal Gravitational Constant [m^3 / (kg * s^2)]
M = 1.98855e+30; % Solar Mass [kg]
GM = G * M;

global options;
options = optimset('Display', 'off'); % hide output from fsolve

%% INPUT

filename = 'input.mat';
[nodes, parameters] = util.readInput(filename);

database = 'solarsystem.mat';
solarSystem = util.readDatabase(database);

%% OPTIMIZE DELTA V TOTAL

initial = parameters; % store initial guesses
dV = computeDeltaV(nodes, parameters);

%% OUTPUT

% something something 3D viewer
