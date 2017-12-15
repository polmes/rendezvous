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
% [dV, nodes, dv] = computeDeltaV(nodes, parameters);
[dV, nodes, dv, minParameters] = optimize(nodes, parameters); % [dV, nodes, parameters, grad, it] to debug

%% OUTPUT

disp(['deltaV = ' num2str(dV / 1000) ' km/s']);
util.showOrbits(nodes);
util.showBudget(dv);
