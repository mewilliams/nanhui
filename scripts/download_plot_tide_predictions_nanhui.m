clear
close all


 T = downloadNMDISTides( ...
     'T067', ...
     datetime(2026,4,1), ...
     datetime(2026,6,1));

%%

dat = readtable('../external_data/T067_20260401_to_20260601_tides.csv');

figure
plot(dat.time_UTC,dat.tide_cm)
xlabel('time, UTC')
ylabel('Tide [cm]')
title('Tide predictions, Nanhui T067 芦潮港(南汇嘴)')

% saveas(gcf,'../images/tideprediction_nanhui.png')
