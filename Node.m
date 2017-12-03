classdef Node < matlab.mixin.Heterogeneous % to allow arrays of mixed classes
    properties
        r;
        t;
        vi;
        vo;
    end
    
    methods
        function obj = setPositionAndTime(obj, parameters)
            % [rx ry rz t]
            obj.r = parameters(1:3);
            obj.t = parameters(4);
        end
        
        function dv = computeDeltaV(obj)
            dv = norm(obj.vo - obj.vi);
        end
    end
end
