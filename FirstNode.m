classdef FirstNode < PlanetNode
   methods
        function dv = getDeltaV(obj)
            [~, v_planet] = obj.orbit.toIJK(obj.t);
            vo_rel = obj.vo - v_planet;
            
            % Most efficient periapsis (no atmosphere)
            r_pi = max([obj.radius, 2 * obj.mu / norm(vo_rel)^2]);
            
            v_pi = sqrt((2 * obj.mu / r_pi) + norm(vo_rel)^2);
            v_orbit = sqrt(obj.mu / r_pi);
            
            dv = abs(v_pi - v_orbit);
        end
    end
end
