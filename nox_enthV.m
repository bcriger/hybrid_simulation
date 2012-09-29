function bob = nox_enthV(T_Kelvin, nox_prop)
%Nitrous liquid Enthalpy (Latent heat) of vaporisation, J/kg

tCrit = nox_prop(3);

    bL = [-200.0, 116.043, -917.225, 794.779, -589.587];
    bV = [-200.0, 440.055, -459.701, 434.081, -485.338];

    Tr = T_Kelvin / tCrit;
    rab = 1.0 - Tr;
    shonaL = bL(1);
    shonaV = bV(1);
    for dd = 2:5
        %saturated liquid enthalpy
        shonaL = shonaL + bL(dd) * rab^((dd-1) / 3.0);  
        %saturated vapour enthalpy
        shonaV = shonaV + bV(dd) * rab^((dd-1) / 3.0); 
    end
    %net during change from liquid to vapour
    bob = (shonaV - shonaL) * 1000.0;
end