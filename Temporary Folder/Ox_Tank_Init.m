function N2O_Tank = Ox_Tank_Init(nox_prop)
%Subroutine to initialise main program variables */
%Gets called only once, prior to firing */

tank_volume = 4.5/1000; %Volume in m^3.    
initial_ullage = 1.0;  %(Value is a percentage)
mdot_tank_outflow = 0.0; 

%set either initial (tank) pressure (Bar)
%OR initial nitrous temperature (deg Kelvin) 
initial_tank_pressure = -10;  %set to negative if unknown (DEPRECATED; ALWAYS SET NEGATIVE)
tank_fluid_temperature_K = 15+273.15; %set to negative if unknown

if (initial_tank_pressure > 0)
        tank_fluid_temperature_K = ...
            nox_on_press(initial_tank_pressure, nox_prop); 
elseif (tank_fluid_temperature_K > 0)
        tank_initial_pressure = ...
            nox_vp(tank_fluid_temperature_K, nox_prop);
end
%reality check 
if (tank_fluid_temperature_K > (36.0 + 273.15))
    tank_fluid_temperature_K = 36.0 + 273.15;
end
tank_pressure_bar = tank_initial_pressure;
% get initial nitrous properties
tank_liquid_density = nox_Lrho(tank_fluid_temperature_K, nox_prop);
tank_vapour_density = nox_Vrho(tank_fluid_temperature_K, nox_prop);
% base the nitrous vapour volume on the tank percentage ullage 
%(gas head-space) 
tank_vapour_volume = (initial_ullage/100.0)*tank_volume;
tank_liquid_volume = tank_volume - tank_vapour_volume;
tank_liquid_mass = tank_liquid_density * tank_liquid_volume;
tank_vapour_mass = tank_vapour_density * tank_vapour_volume;
% total mass within tank
tank_propellant_contents_mass = tank_liquid_mass + tank_vapour_mass; 
%guessed initial value of amount of nitrous vaporised per iteration
%in the nitrous tank blowdown model (actual value is not important)
tank_liquid_mass_old = tank_liquid_mass;
mdot_tank_outflow_returned = 0.000;
first_vapour_it = 1;

    N2O_Tank = [tank_volume, ...
            tank_fluid_temperature_K, ...
            tank_liquid_mass, ...
            tank_vapour_mass, ...     
            tank_liquid_mass_old, ...
            mdot_tank_outflow_returned, ...
            tank_pressure_bar, ...
            tank_propellant_contents_mass, ...
            tank_liquid_density, ...
            tank_vapour_density, ...
            mdot_tank_outflow, ...
            0, ...
            0, ...
            0, ...
            first_vapour_it, ...
            0,0,0,0,0, ...
            0];
end