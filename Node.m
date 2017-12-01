classdef Node < matlab.mixin.Heterogeneous % to allow arrays of mixed classes
    properties
        r;
        t;
        vi;
        vo;
    end
    
    methods
        function obj = setPositionAndTime(obj, parameters)
            obj.r = parameters(1);
            obj.t = parameters(2);
        end
        
        function dv = computeDeltaV(obj)
            dv = obj.vo - obj.vi;
        end
    end
end
