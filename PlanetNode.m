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
            obj.r = obj.orbit.toIJK(t);
        end
        
        function dv = computeDeltaV(obj)
            % Gravity assist
            dv = obj.vo - obj.vi + 1;
        end
    end
end
