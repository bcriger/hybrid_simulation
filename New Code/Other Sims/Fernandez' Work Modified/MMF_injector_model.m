function mass_flowrate = MMF_injector_model(N2O_Tank, P2)
%calculate injector pressure drop (Bar) and mass flowrate (kg/sec)
%kg/sec 
    all_nox_prop = nox_prop;
    all_rocket_prop = Rocket_Prop;
    %Tank Volume in m^3
    tank_volume = all_rocket_prop(1); 
   
    MolMass = all_nox_prop(6);
    Inj_Loss_Coeff = all_rocket_prop(11);
    
    tank_fluid_temperature_K    = N2O_Tank(2);
    tank_liquid_mass            = N2O_Tank(3);
    %Mass of Fluid that is vapour in kg
    tank_vapour_mass            = N2O_Tank(4);
    tank_liquid_density         = N2O_Tank(9);
    tank_vapour_density         = N2O_Tank(10);
    P1                          = N2O_Tank(7);
   
    pressure_drop = (P1 - P2)*100000; %Pa
    %reality check
    if (pressure_drop < 0.00001)
        pressure_drop = 0.00001;
    end    
    %Calculate fluid flowrate through the injector, based on the 
    %total-pressure loss factor between the tank and combustion chamber 
    %(injector_loss_coefficient includes K coefficient and orifice
    %cross-sectional areas) 
    
%     mass_flowrate = -Cd*Ainj*sqrt(2*(pressure_drop)*fluid_density);
    if tank_liquid_mass > 0.00000001
        Fluid_density = (nox_Lrho(tank_fluid_temperature_K, 'kg_m3'))/MolMass;
    else
        %set tank vapour density if it is not zero
        if tank_vapour_density == 0 
            tank_vapour_density = tank_vapour_mass/tank_volume;
        end
        Fluid_density = tank_vapour_density/MolMass;
    end
    
    mass_flowrate = Inj_Loss_Coeff*sqrt(2/MolMass)*sqrt((pressure_drop)*Fluid_density);
    mass_flowrate = mass_flowrate*MolMass;
    %mass_flowrate = ...
    %    sqrt((2.0 * fluid_density * pressure_drop / inj_loss_coeff));
end    