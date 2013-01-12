function enthalpy = nox_enthV(T_Kelvin)
% Nitrous liquid Enthalpy (Latent heat) of vaporisation, J/kg
% Direct Copypasta from aspirespace.org.uk,
% under Technical Papers::Modelling the nitrous run tank emptying
% Author: Rick Newlands. Updated 03/01/12. Top of page 8. 

%Imperical Parameters
bL = [-200.0, 116.043, -917.225, 794.779, -589.587];
bV = [-200.0, 440.055, -459.701, 434.081, -485.338];

scaled_Temperature = T_Kelvin / tCrit;
rab = 1.0 - scaled_Temperature;

shonaL = bL[0];
shonaV = bV[0];

for dd = 1:5
    shonaL = shonaL+ bL(dd) * rab^(dd / 3.0); % saturated liquid enthalpy
    shonaV = shonaV+ bV(dd) * rab^(dd / 3.0); % saturated vapour enthalpy
end

enthalpy = (shonaV - shonaL) * 1000.0; %net during change from liquid to vapour 
end