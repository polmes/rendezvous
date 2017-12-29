function showPlanets(solarSystem)
    N = 4; % Inner Solar System (Mercury Venus Earth Mars)
    NN = 100;
    
    au = 149597870700; % 1 [AU] in [m]
    
    global GM;
    mu = GM;
    
    % Get previous legend contents
    h = legend();
    prev = h.String;
    
    % Planets
    for i = 1:N
        orbit = solarSystem.orbit(i);
        a = orbit.sma;
        T = 2 * pi * sqrt(a^3 / mu);
        
        rs = zeros(3, NN);
        ts = linspace(0, T, NN);
        for j = 1:NN
            rs(:, j) = orbit.toIJK(ts(j));
        end
        
        rs = rs / au;
        plot3(rs(1, :), rs(2, :), rs(3, :), 'k:');
    end
    
    % Oumuamua
    orbit = solarSystem.orbit(end);
    rs = zeros(3, NN);
    ts = linspace(...
        util.Cal2JD(2017, 6, 1, 0, 0, 0, 'J2000'), ...
        util.Cal2JD(2017, 12, 1, 0, 0, 0, 'J2000'), ...
        NN) * 86400;
    for j = 1:NN
        rs(:, j) = orbit.toIJK(ts(j));
    end
    rs = rs / au;
    plot3(rs(1, :), rs(2, :), rs(3, :), 'k:');
    
    % Update legend
%     next = solarSystem.Properties.RowNames(1:N).';
%     legend([prev next]);
    legend(prev);
end
