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
        function obj = Orbit(varargin)
            % MATLAB is dumb
            if nargin == 1 % (node)
                node = varargin{1};
                obj.sma = node.r;
                % call rv2orbit with node.r and node.vi
            elseif nargin == 6 % (sma, ecc, inc, arg, lan, mna)
                obj.sma = varargin{1};
                obj.ecc = varargin{2};
                obj.inc = varargin{3};
                obj.arg = varargin{4};
                obj.lan = varargin{5};
                obj.mna = varargin{6};
            else
                % Access error stack via MException.last
                throw(MException('Orbit:Constructor:WrongNargin', ...
                    'Invalid number of arguments when using Orbit constructor'));
            end
        end
        
        % Return position at a given time
        function r = getPosition(t)
            r = t;
        end
        
        % Return velocity at a given time
        function v = getVelocity(t)
            v = t;
        end
    end
end
