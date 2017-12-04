classdef Node < matlab.mixin.Heterogeneous % to allow arrays of mixed classes
    properties
        r;
        t;
        vi;
        vo;
    end
    
    methods
        function obj = setPositionAndTime(obj, parameters)
            % [t rx ry rz]
            obj.t = parameters(1); % [t]
            obj.r = parameters(2:4).'; % [rx; ry; rx]
        end
        
        function dv = getDeltaV(obj)
            dv = norm(obj.vo - obj.vi);
        end
    end
end
