function [keepstart] = find_keepstart(split_data)
% find_keepstart(split_data) returns keepstart, the row in split_data of
% the first data point to plot

% isolate rows that match current time to the hour into their own array
rows = length(split_data);
t = datetime;
[y,mon,d] = ymd(t);
h = t.Hour;
if mon < 10
    mon = "0" + mon;
end
if d < 10
    d = "0" + d;
end
if h < 10
    h = "0" + h;
end
current_time = y + "-" + mon + "-" + d + "T" + h;
matches = strfind(split_data,current_time);
for n = 1 : rows - 1
    if isempty(matches{n,1}) == 1  && isempty(matches{n + 1,1}) == 0
        first = n + 1;
    elseif isempty(matches{n,1}) == 0  && isempty(matches{n + 1,1}) == 1
        last = n;
    end
end
bundle = split_data(first:last);
bundle = split(bundle);
utc_raw = bundle(:,1);
utc = split(utc_raw,{'-','T',':'});
utc = str2double(utc);
[~,min,s] = hms(t);

% find the index in the bundle of the largest value in utc(:,5) <= min
for n = 1:length(utc_raw)
    if utc(n,5) > min
        bundle_index = n - 1;
        break
    end
end

% set bundle_index for the case where current_minute > all data_minutes, so
% utc(n,5) > min never occurs
if min > utc(end,5)
    bundle_index = length(utc_raw);
end

% if utc(bundle_index,5) = min and utc(bundle_index,6) > s, store the index
% of the previous row in bundle
if utc(bundle_index,5) == min && utc(bundle_index,6) > s
    bundle_index = bundle_index - 1;
end

% find index of the data point in split_data matching utc(bundle_index)
keepstart = first + bundle_index - 1;

end