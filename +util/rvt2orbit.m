function [sma, ecc, inc, arg, lan, mna] = rvt2orbit(r_ijk, v_ijk, t)
    % init
    global GM;
    mu = GM;
   
    [sma, ecc, inc, nu, arg, lan] = util.ICF2KEP (r_ijk, v_ijk, mu);
    
    % Mean anomaly at epoch J2000
    % Calculate angular moment h
    h_vec = cross(r_ijk,v_ijk);
    h = norm(h_vec);
    if ecc < 1
        E = 2 * atan(sqrt((1 - ecc) / (1 + ecc)) * tan(nu / 2)); % eccentric anomaly
        M = E - ecc * sin(E); % at t
        mna = M - (mu^2 / h^3) * (1 - ecc^2)^(3/2) * t; % at J2000
    elseif ecc > 1
        F = 2 * atanh(sqrt((ecc - 1) / (ecc + 1)) * tan(nu / 2)); % eccentric anomaly
        M = ecc * sinh(F) - F; % at t
        mna = M - (mu^2 / h^3) * (ecc^2 - 1)^(3/2) * t; % at J2000
    end
end
