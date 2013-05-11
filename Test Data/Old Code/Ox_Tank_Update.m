function N2O_Tank = Ox_Tank_Update(N2O_Tank, Comb_Chamber, N2O_Valve, ...
                                    nox_prop, dt)
%This function looks at the amount of liquid and vapour Nitorus Oxide in 
%the oxidizer tank and selects which update function to use
%ranges of function validity
tank_liquid_mass = N2O_Tank(3);
first_vapour_it = N2O_Tank(15);
tank_pressure = N2O_Tank(7);
mdot_tank_outflow = N2O_Tank(11);
   
    if (tank_liquid_mass < .0001) || (first_vapour_it == 0)
        %if tank has almost no liquid left, use the vapour routines
         N2O_Tank = tank_no_liquid(N2O_Tank, Comb_Chamber, N2O_Valve, ...
                                    nox_prop, dt);
    else
        %otherwise, use the liquid/vaopur mix routines
        N2O_Tank = tank_with_liquid(N2O_Tank, Comb_Chamber, N2O_Valve, ...
                                    nox_prop, dt);
    end
end