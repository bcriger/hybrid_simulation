function mass_flowrate = MMF_injector_model(N2O_Tank, P2)
%calculate injector pressure drop (Bar) and mass flowrate (kg/sec)
%kg/sec 
    all_nox_prop = nox_prop;
    MolMass = all_nox_prop(6);
    Cd = 0.425;                     % discharge coefficient: Test 1
    % Cd = 0.365;                   % Test 2 and 3
    % Cd = 0.09;                    % Test 4
    Ainj = 0.0001219352;            % injector area [m^2]
    
    tank_fluid_temperature_K    = N2O_Tank(2);
    tank_liquid_mass            = N2O_Tank(3);
    tank_liquid_density         = N2O_Tank(9);
    tank_vapour_density         = N2O_Tank(10);
    P1 = N2O_Tank(7);
        
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
    Lmol_density = (nox_Lrho(tank_fluid_temperature_K, 'kg_m3'))/MolMass;
    mass_flowrate = Cd*Ainj*sqrt(2/MolMass)*sqrt((pressure_drop)*Lmol_density);
    mass_flowrate = mass_flowrate*MolMass;
    %mass_flowrate = ...
    %    sqrt((2.0 * fluid_density * pressure_drop / inj_loss_coeff));
end    