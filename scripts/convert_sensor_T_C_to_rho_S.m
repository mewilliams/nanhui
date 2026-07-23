%
%
% 23 july 2026
% m williams
%
%
% use GSW toolbox to convert temperature and conductivity to salinity and
% density.
%
clear
close all

% local path to Gibbs Seawater toolbox
addpath(genpath('~/Research/general_scripts/matlabfunctions/gsw/'));

ixl = 1;
for ix = [8]
    fn = ['~/Research/nanhui/Sampling_Data_of_Nanhui_Tidal_Flat/20260419-20260529-',num2str(ix),'.csv'];
    d = readtable(fn);

    % measurements are in uS/cm (matlab doesnt interpret the \mu correctly
    % in the table header)

    % units needed for gsw, convert uS/cm to mS/cm
    C_mScm = d.Conductivity__S_cm_/1000;
    % T = d.Temperature__C_;


    % practical salinity, units C: mS/cm, T: degC, P: rel pres. in dbar
    % can ignore pressure in intertidal flats
    % SP = gsw_SP_from_C(C,t,p) [unitless]
    SP = gsw_SP_from_C(C_mScm,d.Temperature__C_,1);

    % Absolute salinity (g/kg)
    % [SA, in_ocean] = gsw_SA_from_SP(SP,p,long,lat)
    [SA, ~] = gsw_SA_from_SP(SP,1,121.931449,30.859721);

    % Conservative temperature:
    % CT = gsw_CT_from_t(SA,t,p)
    %  t   =  in-situ temperature (ITS-90)    [deg C]
    CT = gsw_CT_from_t(SA,d.Temperature__C_,1);

    % water density:
    % rho = gsw_rho(SA,CT,p)
    rho = gsw_rho(SA,CT,1);

    figure(ix)
    plot(d.Time,SA), ylabel('Salinity [g/kg]'), title(['site ',num2str(ix)])

    figure(ix+20)
    plot(SA,d.Temperature__C_), xlabel('Salinity [g/kg]'), ylabel('Temperature [C]')
    title(['site ',num2str(ix)])

    figure(100)
    plot(d.Time,SA), hold all,  ylabel('Salinity [g/kg]')
    legentry{ixl} = ['site ', num2str(ix)];
    ixl = ixl+1;

    figure(101)
    plot(d.Time,d.Temperature__C_), ylabel('Temperature [C]'), hold all

    figure(102)
    plot(d.Time,rho), ylabel('Water Density [kg/m^3]'), hold all

    figure(103)
    plot(SA,d.Temperature__C_,'.'), hold all
    xlabel('Salinity [g/kg]'), ylabel('Temperature [C]')

    figure(104)
    subplot(3,1,1)
    plot(d.Time,SA), hold all,  ylabel('Salinity [g/kg]')
    subplot(3,1,2)
    plot(d.Time,d.Temperature__C_), ylabel('Temperature [C]'), hold all
    subplot(3,1,3)
    plot(d.Time,rho), ylabel('Water Density [kg/m^3]'), hold all

end

figure(100), legend(legentry)
figure(101), legend(legentry)
figure(102), legend(legentry)
figure(103), legend(legentry)
figure(104), legend(legentry)