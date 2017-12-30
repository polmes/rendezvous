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

filename = 'input_short.mat';
[nodes, parameters] = util.readInput([dataDir filename], solarSystem);

%% OPTIMIZE DELTA V TOTAL

initial = parameters; % store initial guesses
[dV, nodes, dv, parameters] = debugOptimizer(nodes, parameters);

%% OUTPUT

% resultsDir = 'results/';
% name = util.getName([dataDir filename]);

disp(['deltaV = ' num2str(dV / 1000) ' km/s']);
% util.showOrbits(nodes);
% util.showPlanets(solarSystem);
% util.showBudget(dv);

% input = util.writeInput([dataDir filename], parameters);
% save([resultsDir 'all_' name '_' optimizer '.mat']); % all variables
% save([resultsDir 'input_' name '_' optimizer '.mat'], 'input'); % final parameters in input format
