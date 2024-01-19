function [smoothlat,smoothlong] = smoothdata_2d(lla)
% smoothdata_2d(lla) interpolate 2D data to smooth the ground trace and add
% NaNs where the data wraps so Matlab doesn't connect these points across
% the map with the ground trace.

% determine points where location on 2d map transitions from right to left
[rows,~] = size(lla);
wraps = double.empty;
wraps_pos = 1;
for n = 1:rows-1
    if lla(n,2) > lla(n+1,2)
        wraps(wraps_pos) = n;
        wraps_pos = wraps_pos + 1;
    end
end

num_wraps = length(wraps); % number of times the ground trace jumps from the right side of the map to the left
[rows,~] = size(lla); % number of latitude/longitude pairs

% initialize smoothlat and smoothlong vectors that will comprise of
% measured & interpolated data points, number of interpolated data points
% scales with samplingRateIncrease
samplingRateIncrease = 10;
smoothrow = rows * samplingRateIncrease + num_wraps;
smoothlong = zeros(smoothrow,1);
smoothlat = zeros(smoothrow,1);

% handle the data before the first wrap around
size_ib = wraps(1) * samplingRateIncrease; % number of data points in this bundle
currentrows = 1:wraps(1); % relevant rows in lla vector
currentrows_sm = 1:size_ib; % relevant rows in smooth lla vectors
smoothlong(currentrows_sm) = linspace(lla(currentrows(1),2), 180, size_ib);
smoothlat(currentrows_sm) = spline(lla(currentrows,2), lla(currentrows,1), smoothlong(currentrows_sm));

% handle the middle data
for n = 1 : num_wraps - 1
    size_b = (wraps(n+1) - wraps(n)) * samplingRateIncrease; % number of data points in smoothed middle bundles
    currentrows = wraps(n) + 1 : wraps(n+1);
    currentrows_sm = wraps(n) * samplingRateIncrease + n : wraps(n+1) * samplingRateIncrease + n;
    smoothlong(currentrows_sm(1)) = NaN;
    smoothlong(currentrows_sm(2:end)) = linspace(-180, 180, size_b);
    smoothlat(currentrows_sm(1)) = NaN;
    smoothlat(currentrows_sm(2:end)) = spline(lla(currentrows,2), lla(currentrows,1), smoothlong(currentrows_sm(2:end)));
end
 
% handle the data after the last wrap around
size_fb = (rows - wraps(end)) * samplingRateIncrease; % number of data points in smoothed final bundle
currentrows = wraps(end) + 1 : rows;
currentrows_sm = wraps(end) * samplingRateIncrease + num_wraps : rows * samplingRateIncrease + num_wraps;
smoothlong(currentrows_sm(1)) = NaN;
smoothlong(currentrows_sm(2:end)) = linspace(-180, lla(currentrows(end),2), size_fb);
smoothlat(currentrows_sm(1)) = NaN;
smoothlat(currentrows_sm(2:end)) = spline(lla(currentrows,2), lla(currentrows,1), smoothlong(currentrows_sm(2:end)));