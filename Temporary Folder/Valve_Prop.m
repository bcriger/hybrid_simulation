function mass_flowrate = valve_model(N2O_Tank, Comb_Chmaber, N2O_Valve, P1, P2)

tank_pressure = N2O_Tank(7);
tank_liquid_density = N2O_Tank(9);
tank_liquid_mass = N2O_Tank(3);
tank_vapour_density = N2O_Tank(10);

Valve_Dia = 0.25/25.4;  %valve diameter in mm
Valve_Total_Area = pi*(Valve_Dia/2)^2;
Full_Flow_Coeff = 0.3004 * Valve_Dia ^ 2 ...
                - 5.8828 * Valve_Dia ...
                + 53.341;
Valve_Angle = N2O_Valve(1);
Valve_Open_Area = (0.25700 * Valve_Angle^2 ...
                - 1.0883 * Valve_Angle ...
                + 1.0346) * pi() * (Valve_Dia/2)^2;
Valve_Constant = Full_Flow_Coeff * Valve_Open_Area / Valve_Total_Area;
   
if tank_liquid_mass > 0.001 
    fluid_density = tank_liquid_density;
else
    fluid_density = tank_vapour_density;
end
    
pressure_drop = tank_pressure_bar - chamber_press_bar; %Bar 
%reality check
if (pressure_drop < 0.00001)
    pressure_drop = 0.00001;
end
volume_flowrate = ...
    Valve_Constant*Valve_Open_Area/1000^2*((P1 - P2)/fluid_density)^(0.5);
mass_flowrate = volume_flowrate * fluid_density;
end
