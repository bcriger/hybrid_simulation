function enthalpy = nox_enthV(T_Kelvin, units)
% Nitrous liquid Enthalpy (Latent heat) of vaporisation, J/kg or J/kmol 
all_nox_prop = nox_prop;
tCrit = all_nox_prop(3);

if 1 == strcmp(units, 'J_kg')
    % Direct Copypasta from aspirespace.org.uk,
    % under Technical Papers::Modelling the nitrous run tank emptying
    % Author: Rick Newlands. Updated 03/01/12. Top of page 8.
    %Imperical Parameters
    bL = [-200.0, 116.043, -917.225, 794.779, -589.587];
    bV = [-200.0, 440.055, -459.701, 434.081, -485.338];
    scaled_Temperature = T_Kelvin / tCrit;
    rab = 1.0 - scaled_Temperature;
    shonaL = bL(1);
    shonaV = bV(1);

    for dd = 2:5
        shonaL = shonaL+ bL(dd) * rab^((dd-1) / 3.0); % saturated liquid enthalpy
        shonaV = shonaV+ bV(dd) * rab^((dd-1) / 3.0); % saturated vapour enthalpy
    end
    enthalpy = (shonaV - shonaL) * 1000.0; %net during change from liquid to vapour 

elseif 1 == strcmp(units, 'J_kmol')
    % Perry's Chemical Engineers' Handbook Property Equations
    % Copied from MMF Thesis
    J1 = 2.3215e7;      % heat of vapourization of N2O [J/kmol] coefficients
    J2 = 0.384;         % valid for Temp range [182.3K - 309.57 K]
    J3 = 0;
    J4 = 0;
    % heat of vapourization of N2O [J/kmol]
    enthalpy = J1*(1 - T_Kelvin) ^ (J2 + J3*T_Kelvin + J4*T_Kelvin^2);    
end