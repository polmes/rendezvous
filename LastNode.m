classdef LastNode < PlanetNode
    methods
        function dv = getDeltaV(obj)
            % tmp lambert
            node_orbit = obj;
            node_orbit = node_orbit.setPositionAndTime(obj.t + 3600);
            [v_orbit, ~] = lambert(obj, node_orbit);
            
            dv = norm(v_orbit - obj.vi);
        end
    end
end
