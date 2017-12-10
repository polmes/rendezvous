function [v1, v2] = lambert(node1, node2)
    % Constants
    global GM;
    mu = GM;
    %lw = 0; % Type I (short-way)
    mr = 0; % number of revolutions (will NOT work if ~= 0)
    lp = 0; % short-period multi-revolution
    tol = 1e-6; % iteration tolerance
    
    % Variables
    r1 = node1.r;
    r2 = node2.r;
    tof = node2.t - node1.t;
    
    % Call the algorithm
    [v1_lw, v2_lw] = util.Lambert_Izzo_2015_X_HH_RT(r1, r2, tof, mu, 1, mr, lp, tol); % [v1, v2, flag, i, dbg] if we want debug info
    
    % Call the algorithm
    [v1_sw, v2_sw] = util.Lambert_Izzo_2015_X_HH_RT(r1, r2, tof, mu, 0, mr, lp, tol); % [v1, v2, flag, i, dbg] if we want debug info

    if(xor((norm(v1_lw - node1.vi) < norm(v1_sw - node1.vi)),~node1.eff))
        v1 = v1_lw; 
        v2 = v2_lw;
    else
        v1 = v1_sw; 
        v2 = v2_sw;
    end

end
