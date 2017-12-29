% INIT
global GM options;
GM = 6.67408e-11 * 1.98855e+30;
options = optimset('Display', 'off'); % hide output from fsolve

% INPUT
dataDir = 'data/';
database = 'solarSystem.mat';
solarSystem = util.readDatabase([dataDir database]);

% PLOT
figure;
hold('on');
grid('on');
util.showPlanets(solarSystem);
