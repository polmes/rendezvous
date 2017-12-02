function [ r_ijk, v_ijk ] = KEP2ICF ( sma, ecc, inc, nu, argp, raan, mu )
%KEP2ICF_O Keplerian elements to state vector
%   Converts a set of orbital elements to state vector (position and
%   velocity) in Inertial Coordinate Frame ICF (ijk)
%
%   Coordinates arround Earth will be given in ICF/ECI frame, coordinates
%   arround the Sun/SSB will be given in ICF/ICRF frame.
%
%   OPTIMIZED CODE
%
% Inputs:
%   sma: semi-major axis [m], or semi-latus rectum (p) [m] if parabola
%   ecc: eccentricity [#]
%   inc: inclination [rad]
%   nu: true anomaly [rad]
%   agp: argument of periapsis [rad]
%   raan: right ascension of ascending node [rad]
%   mu: standard gravitational parameter of the central body [m^3 s^-2]
%
% Outputs:
%   r_ijk: position [x,y,z] in ICF coordinates (ijk)
%   v_ijk: velocity [vx,vy,vz] in ICF coordinates (ijk)
%
% Example:
%   [ r_ijk, v_ijk ] = KEP2ICF_O ( 1.5E8, 0.001, 0, 0, 0, 0, 1.32E11 );
%
% References:
%   [1] Curtis, Howard D.
%       Orbital mechanics for Engineering Students, Chapter 4.6
%       Butterworth-Heinemann, Elsevier, Oxford, 2010
%
% See also:
%	KEP2LCF, LCF2ICF
%
%David de la Torre Sangra
%August 2014

% Check singularities
if(ecc > 1 && sma > 0)
    error('Incompatibility found: positive sma with negative ecc')
end
if(ecc == 1)
    warning('Ecc singualrity (1): substracting Matlab eps value')
    ecc = ecc - 1e-10; %smallest acceptable number
end
if(ecc == 0)
    warning('Ecc singualrity (0): adding Matlab eps value')
    ecc = ecc + 1e-10; %smallest acceptable number
end
if(mod(inc,pi) == 0)
    warning('Inclination is equal to 0: using Matlab eps value instead')
    inc = inc + 1e-10; %smallest acceptable number
end

% Calculate p parameter (semi-latus rectum)
p = sma * (1 - ecc*ecc); % Ellipse, Hyperbola

% Calculate position (norm)
r = p / (1 + ecc * cos(nu));

% Calculate virtual velocity (norm)
v = sqrt(mu / p);

% Position vector in Local Coordinate Frame LCF (pqw) [1] Eq. 4.45
r_pqw = r * [cos(nu); sin(nu); 0];

% Velocity vector in Local Coordinate Frame LCF (pqw) [1] Eq. 4.46
v_pqw = v * [-sin(nu); ecc + cos(nu); 0];

% Common terms for the rotation matrix LCF -> ICF
cos_raan = cos(raan);
sin_raan = sin(raan);
cos_argp = cos(argp);
sin_argp = sin(argp);
cos_inc = cos(inc);
sin_inc = sin(inc);

% Components of the rotation matrix LCF -> ICF [1] Eq. 4.48
Px = + cos_raan * cos_argp - sin_raan * cos_inc * sin_argp;
Py = + sin_raan * cos_argp + cos_raan * cos_inc * sin_argp;
Pz = + sin_inc  * sin_argp;
Qx = - cos_raan * sin_argp - sin_raan * cos_inc * cos_argp;
Qy = - sin_raan * sin_argp + cos_raan * cos_inc * cos_argp;
Qz = + sin_inc  * cos_argp;
Wx = + sin_raan * sin_inc;
Wy = - cos_raan * sin_inc;
Wz = + cos_inc;

% Rotation matrix LCF -> ICF [1] Eq. 4.48
M = zeros(3,3);
M(1,1) = Px;
M(2,1) = Py;
M(3,1) = Pz;
M(1,2) = Qx;
M(2,2) = Qy;
M(3,2) = Qz;
M(1,3) = Wx;
M(2,3) = Wy;
M(3,3) = Wz;

% Rotate vectors to ICF (xyz) [1] Eq. 4.50
r_ijk = M * r_pqw(:);
v_ijk = M * v_pqw(:);

% Force row-wise output
v_ijk = v_ijk(:)';
r_ijk = r_ijk(:)';

end
