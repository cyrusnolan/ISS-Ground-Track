function [split_data] = readdata()
% readdata() returns split_data, an nx1 string array containing the ISS ephemeris
% data and relevant information

data = webread('https://nasa-public-data.s3.amazonaws.com/iss-coords/current/ISS_OEM/ISS.OEM_J2K_EPH.txt');
data = cast(data,'char'); % uint8 array to char array
data = convertCharsToStrings(data); % char array to 1x1 string
split_data = splitlines(data); % 1x1 string to nx1 string, split at newlines

end