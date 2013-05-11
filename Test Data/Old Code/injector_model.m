function mass_flowrate = injector_model(N2O_Tank, Comb_Chamber, ...
                                        N2O_Valve, P1, P2)

%calculate injector pressure drop (Bar) and mass flowrate (kg/sec)
%kg/sec    
    tank_liquid_mass = N2O_Tank(3);
    tank_liquid_density = N2O_Tank(9);
    tank_vapour_density = N2O_Tank(10);

    orifice_diameter =  0.0015; % 0.25*0.0254/1; %
    %individual injector orifice total loss coefficent K2
    orifice_k2_coeff = 2;   
    orifice_number = 6;
    bob = pi * ((orifice_diameter/2.0))^2; 
    inj_loss_coeff = (orifice_k2_coeff/((orifice_number*bob)^2))/100000;
    
    if tank_liquid_mass > 0.0001 
        fluid_density = tank_liquid_density;
    else
        fluid_density = tank_vapour_density;
    end
    
    pressure_drop = P1 - P2; %Bar 
    %reality check
    if (pressure_drop < 0.00001)
        pressure_drop = 0.00001;
    end    
    %Calculate fluid flowrate through the injector, based on the 
    %total-pressure loss factor between the tank and combustion chamber 
    %(injector_loss_coefficient includes K coefficient and orifice
    %cross-sectional areas) 
    mass_flowrate = ...
        sqrt((2.0 * fluid_density * pressure_drop / inj_loss_coeff));
end    