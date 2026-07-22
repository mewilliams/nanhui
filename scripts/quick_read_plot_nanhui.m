% 21 july 2026
% m williams
% read data collected/sent by Zhi Li (Tongji University)

clear
close all

conv_mmh2o_Pa = 9.80638;

dPVG = readtable('ZSPD_9_CN_20260401_to_20260601.csv');

dPVG.tempC = (dPVG.temp - 32)*5/9; % F to C
dPVG.pressurePa = dPVG.pressure*3386.39; % inches of mercury to pascals
dPVG.wspd_ms = dPVG.wspd*0.44704; % mph to meters per second (wind)



d = readtable('~/Research/nanhui/Sampling_Data_of_Nanhui_Tidal_Flat/20260419-20260529-12.csv');
d = readtable('~/Research/nanhui/Sampling_Data_of_Nanhui_Tidal_Flat/20260419-20260529-1.csv');

for ix = 1:12
    fn = ['~/Research/nanhui/Sampling_Data_of_Nanhui_Tidal_Flat/20260419-20260529-',num2str(ix),'.csv'];

    d = readtable(fn);
    d.Pres_Pa = d.Pressure_WaterLevel_mmH_O_4_C_*conv_mmh2o_Pa; % conversion mm h2o to pascals

    ax(1) = subplot(3,1,1);
    plot(d.Time,d.Pressure_WaterLevel_mmH_O_4_C_), hold all
    ylabel('P [mm H_2O @ 4^oC]')

    ax(2) = subplot(3,1,2);
    plot(d.Time,d.Temperature__C_), hold all
    ylabel('T [^oC]')
    ax(3) = subplot(3,1,3);
    plot(d.Time,d.Conductivity__S_cm_), hold all
    ylabel('C [S/cm]')

    legentry{ix} = ['site ',num2str(ix)];
end

legend(legentry)

subplot(3,1,2)
ylim([15 23])

linkaxes(ax,'x')

return;
%%
clear ax
close all
for ix = [3 4 5 7 9 10]
    fn = ['~/Research/nanhui/Sampling_Data_of_Nanhui_Tidal_Flat/20260419-20260529-',num2str(ix),'.csv'];
    d = readtable(fn);

    d.Pres_Pa = d.Pressure_WaterLevel_mmH_O_4_C_*conv_mmh2o_Pa; % conversion mm h2o to pascals
    d.Pres_Pa_abs =d.Pres_Pa + 101325; % put atmospheric pressure back (const.

    figure(10)
    ax(1) = subplot(2,1,1)
    plot(d.Time,d.Pres_Pa), hold all
    ax(2) = subplot(2,1,2)
    plot(dPVG.time,dPVG.pressurePa,'k'), hold all

figure(33)
subplot(2,1,1)
plot(d.Time,d.Pres_Pa_abs), hold all
plot(dPVG.time,dPVG.pressurePa,'k')

ts_PVG = datenum(dPVG.time);
ts_Nanhui = datenum(d.Time);

d.PresAtm_PVG_Pa = interp1(ts_PVG,dPVG.pressurePa,ts_Nanhui);


 subplot(2,1,2)
plot(d.Time,d.Pres_Pa_abs-d.PresAtm_PVG_Pa+101325), hold all

end
linkaxes(ax,'x')


% Need to compare to  芦潮港(南汇嘴)

