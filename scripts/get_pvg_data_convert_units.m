% to get airport data, e.g. from https://api.weather.com/v1/location/ZSPD:9:CN/observations/historical.json?apiKey=e1f10a1e78da46f5b10a1e78da96f525&units=e&startDate=20260205


clear
close all

% site: PVG airport: ZSPD:9:CN
apiKey =  'e1f10a1e78da46f5b10a1e78da96f525';

T = downloadWunderground('ZSPD:9:CN', ...
datetime(2026,4,1), ...
datetime(2026,6,1), ...
apiKey);

%%
clear

dat = readtable('ZSPD_9_CN_20260401_to_20260601.csv');

dat.tempC = (dat.temp - 32)*5/9; % F to C
dat.pressurePa = dat.pressure*3386.39; % inches of mercury to pascals
dat.wspd_ms = dat.wspd*0.44704; % mph to meters per second (wind)

% looks like there isn't any precipitation data.