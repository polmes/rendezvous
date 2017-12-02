% INIT
global GM options;
GM = 6.67408e-11 * 1.98855e+30;
options = optimset('Display', 'off'); % hide output from fsolve

% DATA
solarSystem = util.readDatabase('data/solarSystem.mat');

% INPUT
time = linspace(0, 365*86400, 100);
orbit = solarSystem.orbit('Earth');

% PLOT
figure;
hold('on');
for i = 1:length(time)
    r = orbit.toIJK(time(i));
    scatter3(r(1), r(2), r(3), 'filled');
    % pause(0.01);
end
grid('on');
axis('equal');
