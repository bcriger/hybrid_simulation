function mass_flowrate = valve_model(N2O_Tank, Comb_Chmaber, ...
                                     N2O_Valve, P1, P2)
tank_liquid_density = N2O_Tank(9);
tank_liquid_mass = N2O_Tank(3);
tank_vapour_density = N2O_Tank(10);

Valve_Dia = 0.5 * 25.4;  %valve diameter in mm
Valve_Total_Area = pi * (Valve_Dia/2)^2 /1000^2;  %Area in m^2
Valve_Angle = 0*pi/2;
Valve_Open_Area = (0.25700 * Valve_Angle^2 ...
                - 1.0883 * Valve_Angle ...
                + 1.0346) * Valve_Total_Area;  %Open Area m^2
Full_Flow_Coeff = 0.862 * (0.3004 * Valve_Dia ^ 2 - 5.8828 * Valve_Dia ...
                + 53.341);
   
if tank_liquid_mass > 0.001 
    fluid_density = tank_liquid_density;
else
    fluid_density = tank_vapour_density;
end

pressure_drop = P1 - P2; %Bar 
%reality check
if (pressure_drop < 0.0000001)
    pressure_drop = 0.0000001;
end
press_drop_kPa = pressure_drop * 100;
Area_Ratio = Valve_Open_Area / Valve_Total_Area;
SG_N2O = fluid_density/1000;

V_flowrate_h = Full_Flow_Coeff*Area_Ratio*sqrt(press_drop_kPa/SG_N2O);
V_flowrate_s = V_flowrate_h / 3600;
mass_flowrate = V_flowrate_s * fluid_density;
end
