function [keepend] = find_keepend(split_data,groundtrace_double)
% find_keepend(split_data,groundtrace_duration) returns keepend, the row in
% split_data of the last data point to plot

% isolate rows that match end time to the hour into their own array
rows = length(split_data);
t = datetime;
groundtrace_duration = duration(groundtrace_double,0,0);
end_datetime = t + groundtrace_duration;
[y,mon,d] = ymd(end_datetime);
h = end_datetime.Hour;
if mon < 10
    mon = "0" + mon;
end
if d < 10
    d = "0" + d;
end
if h < 10
    h = "0" + h;
end
end_string = y + "-" + mon + "-" + d + "T" + h;
matches = strfind(split_data,end_string);
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
keepend = first + bundle_index - 1;

end