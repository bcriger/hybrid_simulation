function N2O_Tank = WRT_tank_with_liquid(N2O_Tank, Pe, dt)
%Equilibrium (instantaneous boiling) tank blowdown model
%Empty tank of liquid nitrous
%blowdown simulation using nitrous oxide property calcs subroutines

%update last-times values, O = 'old'
tank_volume                         = N2O_Tank(1);
tank_fluid_temperature_K            = N2O_Tank(2);
tank_liquid_mass                    = N2O_Tank(3);
tank_vapour_mass                    = N2O_Tank(4);
mdot_tank_mass_returned_previous    = N2O_Tank(5);
tank_vapourized_mass_old            = N2O_Tank(6);
tank_pressure_bar                   = N2O_Tank(7);
tank_propellant_contents_mass       = N2O_Tank(8);
mdot_tank_outflow                   = N2O_Tank(11);

all_nox_prop = nox_prop;
MolMass = all_nox_prop(6);
% Get enthalpy (latent heat) of vaporisation
Enth_of_vap = nox_enthV(tank_fluid_temperature_K, 'J_kg');
% Get specific heat capacity of the liquid nitrous
Spec_heat_cap = nox_CpL(tank_fluid_temperature_K, 'J_kgK');
% Calculate the heat removed from the liquid nitrous during its
% vaporisation
deltaQ = tank_vapourized_mass_old * Enth_of_vap;
%temperature drop of the remaining liquid nitrous due to losing this heat
deltaTemp = -(deltaQ / (tank_liquid_mass * Spec_heat_cap));
%update fluid temperature
tank_fluid_temperature_K = tank_fluid_temperature_K + deltaTemp;
%reality checks
if (tank_fluid_temperature_K < (-90.0 + 273.15))
    disp('Setting fluid temperature to -90 C, in tank_with_liquid')
    tank_fluid_temperature_K = (-90.0 + 273.15);  %lower limit
elseif (tank_fluid_temperature_K > (36.0 + 273.15))
    disp('Setting fluid temperature to 36 C, in tank_with_liquid')
    tank_fluid_temperature_K = (36.0 + 273.15);   % upper limit
else
    N2O_Tank(2) = tank_fluid_temperature_K;
end
% get current nitrous properties
tank_liquid_density = nox_Lrho(tank_fluid_temperature_K, 'kg_m3');
tank_vapour_density = nox_Vrho(tank_fluid_temperature_K);
tank_pressure_bar = nox_vp(tank_fluid_temperature_K, 'Bar');

if tank_liquid_mass > tank_vapour_mass*1.1
    mdot_tank_outflow = N2O_Flow_Rate(N2O_Tank, Pe);
elseif tank_liquid_mass <= 0
    mdot_tank_outflow = 0;
else
    mdot_tank_outflow = N2O_Tank(11);
end    

%if mdot_tank_outflow2 < .01
%    mdot_tank_outflow_returned = mdot_tank_mass_returned_previous;
%elseif mdot_tank_outflow2 > mdot_tank_outflow * 1.1
%    mdot_tank_outflow_returned = mdot_tank_mass_returned_previous;
%else
%    mdot_tank_outflow_returned = mdot_tank_outflow2;
%end

tank_propellant_contents_mass  = ...
    tank_propellant_contents_mass - mdot_tank_outflow * dt;
tank_liquid_mass_old = tank_liquid_mass - mdot_tank_outflow * dt;

%The following equation is applicable to the nitrous tank, containing
%saturated nitrous:
%tank_volume = liquid_nox_mass/liquid_nox_density ...
%    + gaseous_nox_mass/gaseous_nox_density;
%Rearrage this equation to calculate current liquid_nox_mass
%lost_liquid_volume = mdot_tank_outflow * dt / tank_liquid_density;
%tank_vapourized_mass_old = lost_liquid_volume * tank_vapour_density;

bob = (1.0 / tank_liquid_density) - (1.0 / tank_vapour_density);
tank_liquid_mass = (tank_volume - ...
    (tank_propellant_contents_mass / tank_vapour_density)) / bob;
tank_vapour_mass = tank_propellant_contents_mass - tank_liquid_mass;

%if (tank_vapour_mass < N2O_Tank(4))&&(N2O_Tank(4) < 0.01*MolMass)
%    tank_vapour_mass = N2O_Tank(4);
%end

%update for next iteration
tank_vapourized_mass_old2 = tank_liquid_mass_old - tank_liquid_mass;
if tank_vapourized_mass_old2 < 0.0
    tank_vapourized_mass_old2 = 0;
end

if 100*mdot_tank_outflow*dt > tank_liquid_mass_old
    
    N2O_Tank(2) = N2O_Tank(2);
    N2O_Tank(3) = 0;
    N2O_Tank(4) = N2O_Tank(4);
%    N2O_Tank(5) = 0;
    N2O_Tank(6) = 0;
    N2O_Tank(7) = N2O_Tank(7);
    N2O_Tank(8) = N2O_Tank(8);
    N2O_Tank(9) = N2O_Tank(9);
    N2O_Tank(10) = N2O_Tank(10);
%    N2O_Tank(11) = mdot_tank_outflow;
    N2O_Tank(12) = 0;
    N2O_Tank(13) = N2O_Tank(13);
else
    %update tank contents for next iteration
    N2O_Tank(2) = tank_fluid_temperature_K;
    N2O_Tank(3) = tank_liquid_mass;
    N2O_Tank(4) = tank_vapour_mass;
%    N2O_Tank(5) = mdot_tank_outflow_returned;
    N2O_Tank(6) = tank_vapourized_mass_old2;
    N2O_Tank(7) = tank_pressure_bar;
    N2O_Tank(8) = tank_propellant_contents_mass;
    N2O_Tank(9) = tank_liquid_density;
    N2O_Tank(10) = tank_vapour_density;
    N2O_Tank(11) = mdot_tank_outflow;
    N2O_Tank(12) = tank_liquid_mass/MolMass;
    N2O_Tank(13) = tank_vapour_mass/MolMass;
    N2O_Tank(14) = 0;
end