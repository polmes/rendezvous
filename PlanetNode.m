classdef PlanetNode < Node
    properties
        orbit;
    end
    
    methods
        function obj = setPositionAndTime(obj, t)
            % Compute position using orbit methods
            obj.t = t;
            obj.r = obj.orbit.getPosition(t);
        end
        
        function dv = computeDeltaV(obj)
            % Gravity assist
            dv = obj.vo - obj.vi + 1;
        end
    end
end
