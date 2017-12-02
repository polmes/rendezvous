function [ sma, ecc, inc, nu, argp, raan, E, M ] = ICF2KEP (r_ijk, v_ijk, mu)
%ICF2KEP State vector to Keplerian elements
%   Converts from state vector (position and velocity) in Inertial 
%   Coordinate Frame ICF (ijk) to Keplerian elements.
%
%   Coordinates arround Earth will be given in ICF/ECI frame, coordinates
%   arround the Sun/SSB will be given in ICF/ICRF frame.
%
% OPTIMIZED CODE
%
% Inputs:
%   r_ijk: position [x,y,z] in ICF coordinates (ijk)
%   v_ijk: velocity [vx,vy,vz] in ICF coordinates (ijk)
%
% Outputs:
%   sma: semi-major axis [m]
%   ecc: eccentricity [#]
%   inc: inclination [rad]
%   nu: true anomaly [rad]
%   agp: argument of periapsis [rad]
%   raan: right ascension of ascending node [rad]
%   mu: standard gravitational parameter of the central body [m^3 s^-2]
%

% Position and velocity norm
r = norm(r_ijk);
v = norm(v_ijk);

% Calculate angular moment h
h_vec = cross(r_ijk,v_ijk);

% Calculate eccenticity
ecc_vec = cross(v_ijk,h_vec)/mu - r_ijk/r;
ecc = norm(ecc_vec);
if(ecc == 1)
    warning('Ecc singualrity (1): substracting Matlab eps value')
    ecc = ecc - 1e-10; %smallest acceptable number
end
if(ecc == 0)
    warning('Ecc singualrity (0): adding Matlab eps value')
    ecc = ecc + 1e-10; %smallest acceptable number
end
% Calculate Semi-major axis
sma = 1/(2/r - v^2/mu);

% Calculate nodal axis
n_vec = cross([0;0;1],h_vec);
n = norm(n_vec);

% Calculate the right angle of inc
inc = acos(h_vec(3)/norm(h_vec));
if(mod(inc,pi) == 0)
    warning('Inclination is equal to 0: using Matlab eps value instead')
    inc = inc + 1e-10; %smallest acceptable number
end

% Calculate the right angle of agp
if (n_vec(3)>0)
    argp = acos(dot(n_vec,ecc_vec)/(n*ecc));
else
    argp = 2*pi - acos(dot(n_vec,ecc_vec)/(n*ecc));
end

% Calculate the right angle of nu
if (dot(r_ijk,v_ijk)>0)
    nu = acos(dot(ecc_vec,r_ijk)/(ecc*r));
else 
    nu = 2*pi - acos(dot(ecc_vec,r_ijk)/(ecc*r));
end

% Calculate the right angle of raan
if (n_vec(2)>0)
    raan = acos(n_vec(1)/n);
else
    raan = 2*pi - acos(n_vec(1)/n);    
end

%Extra parameters usualy not required    
E = 2*atan(tan(nu/2)/sqrt((1+ecc)/(1-ecc))); % Excentric anomaly
M = E - ecc*sin(E); % Mean anomaly

end
