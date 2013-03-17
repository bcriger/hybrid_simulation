function vapour_pressure = nox_vp(T_Kelvin, units)
% Can Return Nitrous oxide vapour pressure in: Bar, Pa, 
% or it can return the derivative of vapour pressure wrt Temperature: dPa_dT
        % Perry's Chemical Engineers' Handbook Property Equations
        G1 = 96.512;        % vapour pressure of N2O [Pa] coefficients
        G2 = -4045;         % valid for Temp range [182.3 K - 309.57 K]
        G3 = -12.277;      
        G4 = 2.886e-5;
        G5 = 2;    
    if 1 == strcmp(units, 'Bar')
        % Direct Copypasta from aspirespace.org.uk,
        % under Technical Papers::Modelling the nitrous run tank emptying
        % Author: Rick Newlands. Updated 03/01/12. Top of page 8.
        p = [1.0, 1.5, 2.5, 5.0]; %Equation of state parameters; imperical
        b = [-6.71893, 1.35966, -1.3779, -4.051]; %Equation of state parameters; imperical
        all_nox_prop = nox_prop;
        critical_Pressure = all_nox_prop(1);
        critical_Temperature = all_nox_prop(3);
        scaled_Temperature = T_Kelvin / critical_Temperature;
        rab = 1.0 - scaled_Temperature;
        shona = 0.0;
        for dd = 1:4
            shona = shona + b(dd) * rab ^ p(dd);
        end
            vapour_pressure = critical_Pressure * exp(shona / scaled_Temperature);  
    elseif 1==strcmp(units,'Pa')
        % Copy from MMF Thesis
        vapour_pressure = exp(G1 + G2/T_Kelvin + G3*log(T_Kelvin) + G4*T_Kelvin^G5);
    elseif 1 == strcmp(units,'dPa_dT')
        %derivative of vapour pressure with respect to temperature
        %also copied from MMF Thesis
        vapour_pressure = (-G2/(T_Kelvin^2) + G3/T_Kelvin + G4*G5*T_Kelvin^(G5-1)) ...
            * exp(G1 + G2/T_Kelvin + G3*log(T_Kelvin) + G4*T_Kelvin^G5);
    end
        
end
