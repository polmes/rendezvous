classdef PlanetNode < Node
    properties
        orbit;
        mu;
        radius;
    end
    
    methods
        function obj = setPositionAndTime(obj, parameters)
            % Compute position using orbit methods
            obj.t = parameters;
            obj.r = obj.orbit.toIJK(obj.t);
        end
        
        function dv = computeDeltaV(obj)
            % Powered Gravity Assist
            
            % init
            global options;
            
            % variables
            vi_rel = vi - v_planet;
            vo_rel = vo - v_planet;
            ai = obj.mu/vi_rel^2;
            ao = obj.mu/vo_rel^2;
            delta = acos(dot(vi_rel, vo_rel) / (norm(vi_rel) * norm(vo_rel)));
            
            % periapsis
            f = @(r_pi) asin(ai/(r_pi+ai)) + asin((ao/(r_pi+ao))) - delta;
            r_pi = fsolve(f, 2*obj.radius, options);
            
            % deltaV
            vi_pi = sqrt(vi_rel^2 + 2*obj.mu/r_pi);
            vo_pi = sqrt(vo_rel^2 + 2*obj.mu/r_pi);
            dv = abs(vo_pi - vi_pi);
        end
    end
end
