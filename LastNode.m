classdef LastNode < PlanetNode
    methods
        function dv = getDeltaV(obj)
            % orbital speed
            [~, v_orbit] = obj.orbit.toIJK(obj.t);
            dv = norm(v_orbit - obj.vi);
        end
    end
end
