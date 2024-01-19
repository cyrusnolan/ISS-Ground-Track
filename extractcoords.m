function [utc,lla] = extractcoords(split_data,groundtrace_double)
% extractcoords(data) returns utc and lla data to be plotted from the
% "data" character array

% find the rows of the data to plot
keepstart = find_keepstart(split_data);
keepend = find_keepend(split_data,groundtrace_double);

% split the data at whitespaces
eph = split(split_data(keepstart:keepend));
[rows,~] = size(eph);

% isolate out the time
utc_raw = eph(:,1);

% create time array for coordinate conversion
utc = split(utc_raw,{'-','T',':'});
utc = str2double(utc);

% Create position array for coordinate conversion
position = double.empty;
iatdiff = double.empty;
ut1diff = double.empty;
for n = 1:rows
    position(n,1:3) = eph(n,2:4);
    iatdiff(n,1) = 37;
    ut1diff(n,1) = .04;
end
position = position * 1e3; %convert to meters

% CONVERT FROM ECI REFERENCE FRAME TO GEODETIC LLA COORDINATES
% eci2lla info:
% defaults to WGS84 model of earth
% position as [x1 y1 z1;x2 y2 z2;...;xn yn zn]
% utc as [y1 mo1 d1 h1 min1 s1;y2 mo2 d2 h2 min2 s2;...;yn mon dn hn minn
% sn]
lla = eci2lla(position,utc,'IAU-2000/2006',iatdiff,ut1diff);

end