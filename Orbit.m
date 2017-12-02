classdef Orbit < matlab.mixin.Heterogeneous % to allow arrays of mixed classes
    properties
        sma; % semi-major axis [m]
        ecc; % eccentricity
        inc; % inclination [rad]
        arg; % argument of periapsis [rad]
        lan; % longitude of ascending node [rad]
        mna; % mean anomaly at epoch J2000 [rad]
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
        
        function [r, v] = toIJK(obj, p, tea, mu)
            % norm
            r_mag = p / (1 + obj.ecc * cos(tea));
            v_mag = sqrt(mu / p);
            
            % local
            r_loc = r_mag * [cos(tea); sin(tea); 0];
            v_loc = v_mag * [-sin(tea); obj.ecc + cos(tea); 0];
            
            % rotation
            R1 = [cos(-obj.lan) sin(-obj.lan) 0; -sin(-obj.lan) cos(-obj.lan) 0; 0 0 1];
            R2 = [1 0 0; 0 cos(-obj.inc) sin(-obj.inc); 0 -sin(-obj.inc) cos(-obj.inc)];
            R3 = [cos(-obj.arg) sin(-obj.arg) 0; -sin(-obj.arg) cos(-obj.arg) 0; 0 0 1];
            R = R1 * R2 * R3;
            
            % global
            r = R * r_loc;
            v = R * v_loc;
        end
    end
end
