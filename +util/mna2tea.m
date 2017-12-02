% Mean Anomaly to True Anomaly 
% EPOCH J2000

function tea = mna2tea(mna, ecc)
    global options;
    if ecc < 1 % elliptic
        f = @(E) E - ecc * sin(E) - mna;
        E = fsolve(f, pi, options);
        tea = 2 * atan(sqrt((1 + ecc) / (1 - ecc)) * tan(E / 2));
    elseif ecc > 1 % hyperbolic
        f = @(F) ecc * sinh(F) - F - mna;
        F = fsolve(f, pi, options);
        tea = 2 * atan(sqrt((ecc + 1) / (ecc - 1)) * tanh(F / 2));
    end
end
