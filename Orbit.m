classdef Orbit < matlab.mixin.Heterogeneous % to allow arrays of mixed classes
    properties
        sma;
        ecc;
        inc;
        arg;
        lan;
        mna;
    end
    
    methods
        % Constructor
        function obj = Orbit(sma, ecc, inc, arg, lan, mna)
            obj.sma = sma;
            obj.ecc = ecc;
            obj.inc = inc;
            obj.arg = arg;
            obj.lan = lan;
            obj.mna = mna;
        end
    end
end
