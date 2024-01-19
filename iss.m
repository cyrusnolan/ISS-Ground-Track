clc
clear
close all

groundtrace_double = 3; % number of hours into the future to plot
split_data = readdata();
[utc,lla] = extractcoords(split_data,groundtrace_double);
[smoothlat,smoothlong] = smoothdata_2d(lla);

% plot ground trace
im = imread("world.200408.3x5400x2700.png");
im = flip(im);
image(-180:180,-90:90,im);
axis equal
axis off
axis xy
hold on
plot(smoothlong,smoothlat,'LineWidth',1,'Color','yellow');
plot(smoothlong(1),smoothlat(1),"o",'LineWidth',2)