classdef EllipticOrbit < Orbit % ecc < 1
    methods
        % Constructor
        function obj = EllipticOrbit(sma, ecc, inc, arg, lan, mna)
            obj = obj@Orbit(sma, ecc, inc, arg, lan, mna);
        end
        
        % Return position and velocity at any given time
        function [r, v] = toIJK(obj, t)
            % init
            global GM options;
            mu = GM;
            
            % orbit2mna
            p = obj.sma * (1 - obj.ecc^2);
            h = sqrt(mu * p);
            M = obj.mna + (mu^2 / h^3) * (1 - obj.ecc^2)^(3/2) * t;
            
            % mna2tea
            f = @(E) E - obj.ecc * sin(E) - M;
            E = fsolve(f, pi, options);
            tea = 2 * atan(sqrt((1 + obj.ecc) / (1 - obj.ecc)) * tan(E / 2)); % aka: theta, nu
                        
            [r, v] = toIJK@Orbit(obj, p, tea, mu);
        end
    end
end
