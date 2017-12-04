classdef PlanetNode < Node
    properties
        orbit;
        mu;
        radius;
    end
    
    methods
        function obj = setPositionAndTime(obj, parameters)
            % Compute position using orbit methods
            obj.t = parameters(1);
            obj.r = obj.orbit.toIJK(obj.t);
        end
        
        function obj = setPlanet(obj, planet)
            obj.orbit = planet.orbit;
            obj.mu = planet.mu;
            obj.radius = planet.radius;
        end
        
        function dv = getDeltaV(obj)
            % Powered Gravity Assist
            
            % init
            global options;
            
            % variables
            [~, v_planet] = obj.orbit.toIJK(obj.t);
            vi_rel = obj.vi - v_planet;
            vo_rel = obj.vo - v_planet;
            ai = obj.mu/norm(vi_rel)^2;
            ao = obj.mu/norm(vo_rel)^2;
            delta = acos(dot(vi_rel, vo_rel) / (norm(vi_rel) * norm(vo_rel)));
            
            % periapsis
            f = @(r_pi) asin(ai/(r_pi+ai)) + asin((ao/(r_pi+ao))) - delta;
            r_pi = fsolve(f, 2*obj.radius, options);
            
            % deltaV
            vi_pi = sqrt(norm(vi_rel)^2 + 2*obj.mu/r_pi);
            vo_pi = sqrt(norm(vo_rel)^2 + 2*obj.mu/r_pi);
            dv = abs(vo_pi - vi_pi);
            
            % we should not intersect the planeet
            if r_pi < obj.radius
                dv = dv * 100;
            end
        end
    end
end
