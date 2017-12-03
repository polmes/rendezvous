function [v1, v2] = lambert(node1, node2)
    % Constants
    mu = 1;
    lw = 0; % Type I (short-way)
    mr = 0; % number of revolutions (will NOT work if ~= 0)
    lp = 0; % short-period multi-revolution
    tol = 1e-6; % iteration tolerance
    
    % Variables
    r1 = node1.r;
    r2 = node2.r;
    tof = node2.t - node1.t;
    
    % Call the algorithm
    [v1, v2] = util.Lambert_Izzo_2015_X_HH_RT(r1, r2, tof, mu, lw, mr, lp, tol); % [v1, v2, flag, i, dbg] if we want debug info
end
