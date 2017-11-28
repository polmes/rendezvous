function [ v1, v2, flag, i, dbg ] = Lambert_Izzo_2015_X_HH_RT ( ...
    r1, r2, tof, mu, lw, mr, lp, tol )
%LAMBERT_IZZO_2015_X_HH_RT Solves the Lambert problem
%   Algorithm: Dario Izzo (Lancaster-Blanchard) [1]
%   Parameter: universal variable x
%   Solver: House-Holder [1], with improvements from [2]
%   Velocity: Radial, transversal components [1]
%
%   The free parameter x has the following range:
%   - 1 < x < 1: elliptic orbits
%   x = 0: minimum energy orbit
%   x = 1: parabolic orbit
%   1 < x < INF: hyperbolic orbits
%
% Inputs:
%   r1: position vector of departure point
%   r2: position vector of arrival point
%   tof: time of flight
%   mu: standard gravitational parameter of the central body
%   lw: transfer type
%       0: type I (short-way) transfer
%       1: type II (long-way) transfer
%   mr: number of revolutions [0,Inf]
%   lp: multi-revolution orbit type
%       0: short-period orbit
%       1: long-period orbit
%   tol: iteration tolerance: tol = abs(t-tof)
%
% Outputs:
%   v1: final velocity at departure point (after the manoeuvre)
%   v2: initial velocity at arrival point (before the manoeuvre)
%   flag: function status: 0=OK, 1=BAD_IN, 2=NO_SOL, 3=MAX_IT, 4=PI_FG
%   i: number of iterations
%   dbg: debugging data
%
% Example:
%   [v1,v2] = Lambert_Izzo_2015_X_HH_RT([1,0,0],[0,2,0],pi,1,0,2,0,1E-6);
%
% References:
%	[1] D. Izzo
%       Revisiting Lambert's problem
%       Celest. Mech. Dyn. Astron., vol. 121, no. 1, pp. 1�15, Jan. 2015
%   [2] https://github.com/esa/pykep
%   
%David de la Torre Sangra
%August 2015

%% Preprocess

% Internal parameters
flag = 0; % Status
i = 0; % Iterations
ni = 15; % Maximum number of iterations (Householder iterator)
v1 = NaN*[0,0,0]; % Preallocate v1
v2 = NaN*[0,0,0]; % Preallocate v1
if nargout >= 5, dbg.flag = -1; end % Debug

% Auxiliary magnitudes
r1n = norm(r1); % Norm of r1
r2n = norm(r2); % Norm of r2
lws = -(2 * lw - 1); % Long-way sign (lw=-1, ~lw=1)

% Check if transfer can be computed
if tof <= 0 || mu <= 0 || r1n == 0 || r2n == 0
    flag = 1; % Status: bad inputs
    if nargout >= 5, dbg.flag = flag; end
    return;
end

% Compute geometrical parameters
h = cross(r1,r2); % Orbit normal vector
c = norm(r2 - r1); % Length of chord P1_P2
s = 0.5 * (r1n + r2n + c); % Semiperimeter of triangle P1_P2_F
lam2 = 1 - c/s; % Battin's Lambda parameter, squared, [1]
lam = lws * sqrt(lam2); % Lambda parameter, [1]
lam3 = lam2 * lam; % Powers of Lambda
lam5 = lam3 * lam2; % Powers of Lambda
t = sqrt(2 * mu / (s*s*s)) * tof; % Non dimensional time-of-flight, [1]

% Account for pi transfers
phi = acos(dot(r1,r2)/(r1n*r2n)); % Transfer angle
if mod(phi,pi)==0, h = [0,0,1]; end % Arbitrary plane on pi transfers

%% Initial guess

% Parameters
mmax = floor(t/pi);
t00 = acos(lam) + lam * sqrt(1 - lam2); % [1] Eq. 19
t0m = t00 + mmax * pi; % [1] Eq. 19
t1 = 2/3 * (1 - lam3); % TOF for a parablolic orbit (x=1, y=1)

% Find Tmin for multi-rev case via Halley root solver
if mr > 0

    % Find Tmin for the current mr value
    [ ~, Tmin, ~ ] = Lambert_Izzo_2015_X_Tmin( r1, r2, mu, lw, mr );
    Tmin = Tmin * sqrt(2 * mu / (s*s*s)); %  Normalize magnitude

    % Check if mr transfer is possible
    if Tmin > t % tof is too low for the required Tmin
        flag = 2; % No solution exists
        if nargin>5, dbg.flag = flag; end
        return;
    end
    
end

% Compute starter
if mr == 0 % Single-revolution starter
    if t >= t0m, x0 = -(t - t00) / (t - t00 + 4); % [2]
    elseif t <= t1, x0 = 2.5 * (t1 * (t1 - t)) / (t * (1 - lam5)) + 1; % [1] Eq. 30
    else, x0 = (t / t00)^(log(2) / log(t1 / t00)) - 1; % [2]
    end
else % Multi-revolution starter, from inverting [1] Eq. 29
    if ~lp % Left branch (short-period)
        term = ((mr * pi + pi)/(8 * t))^(2/3);
        x0 = (term - 1) / (term + 1);
    else % Right branch (long-period)
        term = ((8 * t) / (mr * pi))^(2/3);
        x0 = (term - 1) / (term + 1);
    end
end

% Assign starter value to iterator variable
x = x0;

% Save debugging data if required
if nargout >= 5
    dbg.x0 = x0;
end

%% Solver

% Householder iterator
for i=1:ni

    % Compute time of flight from x
    ti = x2tof ( x, mr, lam, lam2 );

    % Compute derivatives
    [ dt, d2t, d3t ] = dtdx ( x, ti, lam2, lam3, lam5 );

    % Save debugging data if required
    if nargout >= 5
        dbg.i(i) = i;
        dbg.x(i) = x;
        dbg.t(i) = ti / sqrt(2 * mu / (s*s*s));
        dbg.dt(i) = dt / sqrt(2 * mu / (s*s*s));
    end

    % Householder method
    d = ti - t;
    d2 = d * d;
    dt2 = dt * dt;
    term = d * (dt2-d*d2t/2) / (dt*(dt2-d*d2t) + d3t*d2/6);
    x = x - term; % [1] Pag. 10

    % Check convergence
    if abs(term) <= tol, break; end

end

% Save debugging data if required
if nargout >= 5
    dbg.i(i+1) = i+1;
    dbg.x(i+1) = x;
    dbg.t(i+1) = x2tof ( x, mr, lam, lam2 ) / sqrt(2 * mu / (s*s*s));
    dbg.dt(i) = dt / sqrt(2 * mu / (s*s*s));
end

%% Compute velocity vectors for each solution

% Transverse and radial unit vectors
r1u = r1/r1n; % Radial, r1
r2u = r2/r2n; % Radial, r2
hxr1 = lws * cross(h,r1); hxr1u = hxr1/norm(hxr1); % Transversal 1
hxr2 = lws * cross(h,r2); hxr2u = hxr2/norm(hxr2); % Transversal 2

% Recover un-transformed parameters
gamma = sqrt(mu * s / 2);
rho = (r1n - r2n) / c;
sigma = sqrt(1 - rho^2);

% Parameters
omx2 = 1 - x^2;
y = sqrt(1 - lam2 * omx2);

% Compute radial velocity components
term1 = lam*y - x;
term2 = rho*(lam*y + x);
vr1n = + gamma*(term1 - term2) / r1n; % v1
vr2n = - gamma*(term1 + term2) / r2n; % v2

% Compute transverse velocity components
vt = gamma * sigma * (y + lam * x);
vt1n = vt / r1n; % v1
vt2n = vt / r2n; % v2

% Compute velocity vectors
v1 = vr1n * r1u + vt1n * hxr1u;
v2 = vr2n * r2u + vt2n * hxr2u;

% Save debugging data if required
if nargout >= 5
    dbg.flag = 0; % Status ok
    dbg.vr1n = vr1n;
    dbg.vt1n = vt1n;
    dbg.vr2n = vr2n;
    dbg.vt2n = vt2n;
    dbg.sma0 = 1 / (1 - x*x);
    [sma,ecc,~,nu1] = ICF2KEP(r1,v1,mu);
    [sma2,ecc2,~,nu2] = ICF2KEP(r2,v2,mu);
    dbg.sma = sma;
    dbg.ecc = ecc;
    dbg.nu1 = nu1;
    dbg.sma2 = sma2;
    dbg.ecc2 = ecc2;
    dbg.nu2 = nu2;
end

end

% Compute 1st-3rd derivatives for the Householder iterations
function [ dt, d2t, d3t ] = dtdx ( x, t, lam2, lam3, lam5 )

% Pre-compute values
omx2 = 1 - x * x;
omx2inv = 1 / omx2;
y = sqrt(1 - lam2 * omx2); % [1] p. 6
y2 = y * y;
y3 = y2 * y;
y5 = y3 * y2;

% Compute derivatives, from [1] Eq. 22
if x==0, dt = -2; % Min energy ellipse
elseif x==1, dt = 0.4 * (lam5 - 1); % Parabola, [1] Eq. 23
else, dt = omx2inv * (3*t*x - 2 + 2*lam3*x/y); % Other cases
end
d2t = omx2inv * (3*t + 5*x*dt + 2*(1-lam2)*lam3/y3);
d3t = omx2inv * (7*x*d2t + 8*dt - 6*(1-lam2)*lam5*x/y5);

end

% Compute time of flight from x
function t = x2tof ( x, n, lam, lam2 )

% Distance from x=1 to trigger Battin / Lancaster expressions
battin = 0.01;
lagrange = 0.2;
dist = abs(x - 1);

% Select optimal expression to compute TOF
if dist < lagrange && dist > battin % Use Lagrange TOF expression

    % Semi-major axis
    a = 1 / (1 - x*x);

    % Compute TOF
    if a > 0 % Ellipse
        alpha = 2 * acos(x); % [1] Eq. 10
        beta = 2 * asin(sqrt(lam2 / a)); % [1] Eq. 11
        if lam < 0, beta = -beta; end
        t = (a*sqrt(a) * ((alpha - sin(alpha)) ...
            - (beta - sin(beta)) + 2*pi*n))/2; % [1] Eq. 9
    else % Hyperbola
        alpha = 2 * acosh(x); % [1] Eq. 10
        beta = 2 * asinh(sqrt(-lam2/a)); % [1] Eq. 11
        if lam < 0, beta = -beta; end
        t = -a*sqrt(-a) * ((beta - sinh(beta)) ...
            - (alpha - sinh(alpha)))/2; % [1] Eqn. 9
    end

else % Use Battin's / Lancaster TOF expressions

    % Compute universal variable z
    e = x*x - 1;
    rho = abs(e);
    z = sqrt(1 + lam2 * e);

    % Compute TOF
    if dist < battin % Use Battin TOF expression, [1] Eq. 20
        eta = z - lam * x;
        s1 = (1 - lam - x * eta) / 2;
        q = 4/3 * hypergeo2F1(s1);
        t = (eta^3 * q + 4 * lam * eta) / 2 + n*pi / (rho*sqrt(rho));
    else % Use Lancaster TOF expresion
        y = sqrt(rho);
        g = x * z - lam * e;
        if e < 0
            l = acos(g);
            d = n*pi + l;
        else
            f = y * (z - lam * x);
            d = log(f + g);
        end
        t = (x - lam * z - d / y) / e;
    end

end

end

% Compute hypergeometric series 2F1(3,1,5/2,x);
function f = hypergeo2F1 ( x )

% Parameters
tol = 1E-9;
kmax = 1E3;

% Initialize
f = 1;
term = 1;

% Compute series
for k = 0:kmax
    term = term * (3+k) * (1+k) / (2.5+k) * x / (k+1); % New term
    f = f + term; % Add new term to the series
    if abs(term) <= tol, break; end % Series has converged
end

end

