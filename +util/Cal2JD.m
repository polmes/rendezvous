function [ JD ] = Cal2JD ( year, month, day, hour, minute, second, REF, CAL )
%CAL2JD Calendar date to Julian date
%   Compute the Julian Date JD using the algorithm from the University of
%   Texas [1]
%
%   This algorithm does not follow the NASA [2] or the US Naval
%   Observatory [3] conventions
%
%   All years in the BC era must be converted to astronomical years, so
%   that 1 BC is year 0, 2 BC is year -1, etc. Convert to a negative
%   number, then increment toward zero.
%
% Inputs:
%   Calendar: year, month, day, hour, minute, second
%   REF: JD reference ('JD','J2000','RJD','MJD','TJD','DJD'). Default JD
%   CAL: Calendar input ('Gregorian','Julian'). Default Gregorian
%
% Outputs:
%   JD: Julian Day [days]
%
% Example:
%   [ JD ] = Cal2JD ( 2000, 1, 1, 12, 0, 0, 'J2000' ); % J2000
%
% References:
%   [1] http://www.cs.utsa.edu/~cs1063/projects/Spring2011/Project1/
%       jdn-explanation.html
%   [2] HORIZONS System 2013
%   [3] Julian Date Converter
%       http://aa.usno.navy.mil/data/docs/JulianDate.php
%       http://aa.usno.navy.mil/faq/docs/JD_Formula.php
%
% See also:
%   JD2Cal
%
%David de la Torre Sangra
%August 2014

% Get default inputs
if ~exist('REF','var') || isempty(REF), REF = 'JD'; end
if ~exist('CAL','var') || isempty(CAL), CAL = 'Gregorian'; end

% Compute number of years (y) and months (m) since March 1 -4800 (March 1,
% 4801 BC)
a = floor((14-month)/12);
y = year + 4800 - a;
m = month + 12*a - 3;

% Compute Julian Day Number
switch CAL
    case 'Gregorian'
        JDN = day + floor((153*m + 2)/5) + 365*y + floor(y/4) ...
            - floor(y/100) + floor(y/400) - 32045;
    case 'Julian'
        JDN = day + floor((153*m + 2)/5) + 365*y + floor(y/4) - 32083;
    otherwise
        error('Calendar not implemented');
end

% Find Julian Date
JD = JDN + (hour - 12)/24 + minute/1440 + second/86400;

% Adjust for optional reference frame
if exist('REF','var') && ~isempty(REF) && ischar(REF)
    switch REF
        case 'JD' % JD
            % Do nothing
        case 'J2000' % J2000
            JD = JD - 2451545.0;
        case 'RJD' % Reduced JD
            JD = JD - 2400000.0;
        case 'MJD' % Modified JD, introduced by SAO in 1957
            JD = JD - 2400000.5;
        case 'TJD' % Truncated JD, introduced by NASA in 1979
            JD = JD - 2440000.5;
        case 'DJD' % Dublin JD, introduced by the IAU in 1955
            JD = JD - 2415020.0;
        otherwise % Reference not implemented
            warning(['Reference "',REF,'" not implemented. ',...
                'Options are: JD J2000 RJD MJD TJD DJD. ',...
                'Now returning Julian Day JD']);
    end
end

end
