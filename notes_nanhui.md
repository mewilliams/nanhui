##### 21 July 2026

###### Raw data

Quickly look at data from Nanhui wetland. There are 12 sensors, recording pressure, temperature, and conductivity at the locations:

![](Sampling_Data_of_Nanhui_Tidal_Flat/2026.3.23%20UAV%20Aerial%20Survey%20Point%20Distribution%20Map-1.png)

Script `quick_read_plot_nanhui.m`

Image: 

![](images/raw_data_wells_nanhui.png)

***

Are the data corrected for atmospheric pressure? Low-water suggests no, this variability looks like atmospheric pressure variability. Will need to correct. Ideally with the data from the met stations in the wetland, but look for public data for now.

![](images/low_water_variability_sensor5.png)


***

###### Atmospheric conditions (pressure, wind, air temperature)

We need atmospheric data to correct pressure sensors at Nanhui, look for airport data.

Script to download data: `downloadWunderground.m`

```matlab
T = downloadWunderground('ZSPD:9:CN', ...
datetime(2026,4,1), ...
datetime(2026,6,1), ...
apiKey);


% site: PVG: ZSPD:9:CN
```

###### Tides

Tide data? There are oceanic data via the National Marine Data Center: https://mds.nmdis.org.cn

Tidal predictions close to the wetland at the site: https://mds.nmdis.org.cn/pages/tidalCurrent.html 

Select predictions for: 芦潮港(南汇嘴)

Script to download the tidal predictions: `downloadNMDISTides.m`

```matlab
 T = downloadNMDISTides( ...
     'T067', ...
     datetime(2026,4,1), ...
     datetime(2026,6,1));
```

Script to download, and plot: `download_plot_tide_predictions_nanhui.m`

Tide predictions for April and May:
![](images/tideprediction_nanhui.png)

***

Use the tide data to verify the timezone of the raw data. Shanghai local time is UTC+8. Comparing water level and tide predictions (with known timezone) shows that the raw data are in local time.

![](images/timezone_check_data_nanhui.png)


##### 22 July 2026

Atmospheric data from Shanghai PVG data: uses `downloadWunderground.m` to download airport (historic) data from https://www.wunderground.com/weather/ZSPD, saves as csv in external data folder. 

Script to plot: `plot_pvg_weather.m`

Data during April - May 2026 are:

![](images/atm_cond_pvg_airport_aprilmay2026.png)


Converting wind speed and direction to U and V (looking because there is a water level anomaly on 4 May):

![](images/wind_velocityUV_speed_2to9may2026_pvg.png)


***

Steps for atmospheric correction of pressure sensor data:

1. Match timezone (use UTC).
2. Correct units (conversion: 9.80638 mm h2o@4C= 1 Pa; Atmospheric pressure standard 101325 Pa). 
3. Subtract atmospheric pressure from wetland sensors. 
4. Optional: convert to water level, but this needs some density considerations. E.g. use T and C to calculate rho, and use that value to get water level H. 

Steps 1-3 currently in `quick_read_plot_nanhui.m` (though not saving yet).

For sensor 5, the correction looks like this:

![](images/correct_atmospheric_pressure_example_sensor5.png)

Applying the atmospheric correction to all the sensors, want to check water level offset.. The sensors should all be the same when they are out of the water. They are not (quite): 

![](images/indivual_sensor_offset_start.png)
![](images/indivual_sensor_offset_end.png)

Questions: 

-  How does the sensor zero the pressure? I assumed/guessed standard atmosphere, but it might take a reading at the moment of start and zero from there. 


***

##### 23 July 2026

###### Convert conductivity and temperature to salinity and density

Use Gibbs Seawater Toolbox (https://teos-10.org/pubs/gsw/html/gsw_contents.html) to convert to absolute salinity (g/kg) and rho (kg/m3).

Script: `scripts/convert_sensor_T_C_to_rho_S.m`

Data from 11 sensors. Conductivity on the sensor at site 3 is bad, the temperature at that site also looks weird, have omitted it here:

![](images/S_T_rho_11sites_aprmay2026.png)

We can look at the S-T diagram to see if there are identifiable water masses. Not sure it tells us much. 

![](images/salinity_temperature_diagram.png)

Some observations on the salinity data. Salinity is obviously tidally variable at three sites:

![](images/salinity_tidally_variability_3sites.png)

And, at four (or five) sites, there was a clear salinity peak near 14 May.

![](images/salinity_peak_14may2026.png). 

Looking at the other variables for that range - there is a transition in temperature from smooth (non-tidal) to perhaps tidal that occurs with this event.

![](images/site7_S_T_rho_11_21may2026.png)..



