classdef Node < matlab.mixin.Heterogeneous % to allow arrays of mixed classes
    properties
        r;
        t;
        vi;
        vo;
    end
    
    methods
        function obj = setPositionAndTime(obj, r, t)
            obj.r = r;
            obj.t = t;
        end
        
        function dv = computeDeltaV(obj)
            dv = obj.vo - obj.vi;
        end
    end
end
