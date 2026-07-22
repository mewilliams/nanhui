% 22 july 2026
% m williams
% plot atmospheric condions from Shanghai PVG airport
% Will use atmospheric pressure for correction at Nanhui wetland. 

clear
close all

% data created with function: downloadWunderground.m
% see get_shanghai_weather_wunderground.m
dat = readtable('../external_data/ZSPD_9_CN_20260401_to_20260601.csv');

dat.tempC = (dat.temp - 32)*5/9; % F to C
dat.pressurePa = dat.pressure*3386.39; % inches of mercury to pascals
dat.wspd_ms = dat.wspd*0.44704; % mph to meters per second (wind)
%%
figure
subplot(4,1,1)
plot(dat.time,dat.pressurePa,'k')
ylabel('P_{atm} [Pa]')
title('Atmospheric conditions, Shanghai PVG airport')

subplot(4,1,2)
plot(dat.time,dat.tempC,'k')
ylabel('T_{air} [C]')


subplot(4,1,3)
plot(dat.time,dat.wspd_ms,'k.'), hold all
plot(dat.time,movmean(dat.wspd_ms,4,'omitnan'),'b')
ylabel('Wind Speed [m/s]')
legend('raw','4-sample moving mean')


subplot(4,1,4)
plot(dat.time,dat.wdir,'k.')
ylabel('Wind Dir. [^o]')
ylim([0 360])



%%
figure
subplot(5,1,1)
plot(dat.time,dat.pressurePa,'k')
ylabel('P_{atm} [Pa]')
title('Atmospheric conditions, Shanghai PVG airport')

subplot(5,1,2)
plot(dat.time,dat.tempC,'k')
ylabel('T_{air} [C]')


subplot(5,1,3)
plot(dat.time,dat.rh,'k')
ylabel('RH [%]')
ylim([0 100])


subplot(5,1,4)
plot(dat.time,dat.wspd_ms,'k.'), hold all
plot(dat.time,movmean(dat.wspd_ms,4,'omitnan'),'b')
ylabel('Wind Speed [m/s]')
legend('raw','4-sample moving mean')


subplot(5,1,5)
plot(dat.time,dat.wdir,'k.')
ylabel('Wind Dir. [^o]')
ylim([0 360])


% saveas(gcf,'~/Research/notes/images/202607/atm_cond_pvg_airport_aprilmay2026.png')
% saveas(gcf,'../images/atm_cond_pvg_airport_aprilmay2026.png')
