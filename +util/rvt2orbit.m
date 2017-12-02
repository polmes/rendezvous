function [sma, ecc, inc, arg, lan, mna] = rvt2orbit(r, v, t)
    % init
    global GM;
    mu = GM;
   
    % position and velocity norms
    r_mag = norm(r);
    v_mag = norm(v);
    
    % angular momentum
    h_vec = cross(r, v);
    h = norm(h_vec);

    % eccenticity
    ecc_vec = cross(v, h_vec)/mu - r/r_mag;
    ecc = norm(ecc_vec);
    
    % semi-major axis
    sma = 1/(2/r_mag - v_mag^2/mu);

    % nodal axis
    n_vec = cross([0;0;1], h_vec);
    n = norm(n_vec);

    % right angle of inc
    inc = acos(h_vec(3) / norm(h_vec));
    
    % singularities
    [sma, ecc, inc] = util.checkSingularities(sma, ecc, inc);

    % argument of periapsis
    if n_vec(3) > 0
        arg = acos(dot(n_vec, ecc_vec) / (n*ecc));
    else
        arg = 2*pi - acos(dot(n_vec, ecc_vec) / (n*ecc));
    end

    % true anomaly, aka: nu, theta
    if dot(r, v) > 0
        tea = acos(dot(ecc_vec, r) / (ecc*r_mag));
    else 
        tea = 2*pi - acos(dot(ecc_vec, r) / (ecc*r_mag));
    end

    % right angle of ascending node
    if n_vec(2) > 0
        lan = acos(n_vec(1)/n);
    else
        lan = 2*pi - acos(n_vec(1)/n);    
    end

    % mean anomaly at epoch J2000
    if ecc < 1
        E = 2 * atan(sqrt((1 - ecc) / (1 + ecc)) * tan(tea / 2)); % eccentric anomaly
        M = E - ecc * sin(E); % at t
        mna = M - (mu^2 / h^3) * (1 - ecc^2)^(3/2) * t; % at J2000
    elseif ecc > 1
        F = 2 * atanh(sqrt((ecc - 1) / (ecc + 1)) * tan(tea / 2)); % eccentric anomaly
        M = ecc * sinh(F) - F; % at t
        mna = M - (mu^2 / h^3) * (ecc^2 - 1)^(3/2) * t; % at J2000
    end
end
