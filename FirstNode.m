classdef FirstNode < PlanetNode % it's a special case
    properties
        altitude;
    end
    
    methods
        function dv = getDeltaV(obj)
            [~, v_planet] = obj.orbit.toIJK(obj.t);
            vo_rel = obj.vo - v_planet;
            r_pi = obj.radius + obj.altitude;
            v_pi = sqrt((2 * obj.mu / r_pi) + vo_rel^2);
            v_orbital = sqrt(obj.mu / r_pi);
            
            dv = abs(v_pi - v_orbital);
        end
    end
end
