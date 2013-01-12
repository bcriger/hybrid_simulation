function bob = nox_vp(T_Kelvin, nox_prop)
% Nitrous oxide vapour pressure, Bar 
% Direct Copypasta from aspirespace.org.uk,
% under Technical Papers::Modelling the nitrous run tank emptying
% Author: Rick Newlands. Updated 03/01/12. Top of page 8. 

    p = [1.0, 1.5, 2.5, 5.0]; %Equation of state parameters; imperical
    b = [-6.71893, 1.35966, -1.3779, -4.051]; %Equation of state parameters; imperical
    
    critical_Pressure = nox_prop(1);
    critical_Temperature = nox_prop(3);

    scaled_Temperature = T_Kelvin / critical_Temperature;
    rab = 1.0 - scaled_Temperature;
    shona = 0.0;

    for dd = 1:4
        shona = shona + b(dd) * rab ^ p(dd);
    end
    
    bob = critical_Pressure * exp(shona / scaled_Temperature);

end
