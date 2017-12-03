%% INIT

global GM;
G = 6.67408e-11; % Universal Gravitational Constant [m^3 / (kg * s^2)]
M = 1.98855e+30; % Solar Mass [kg]
GM = G * M;

global options;
options = optimset('Display', 'off'); % hide output from fsolve

%% INPUT

dataDir = 'data/';

database = 'solarSystem.mat';
solarSystem = util.readDatabase([dataDir database]);

filename = 'input.mat';
[nodes, parameters] = util.readInput([dataDir filename], solarSystem);

%% OPTIMIZE DELTA V TOTAL

initial = parameters; % store initial guesses
[dV, ~] = computeDeltaV(nodes, parameters); % [dV, nodes] to get updated array

%% OUTPUT

% something something 3D viewer
