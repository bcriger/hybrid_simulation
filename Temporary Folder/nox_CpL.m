function bob = nox_CpL(T_Kelvin, nox_prop)
%Nitrous saturated liquid isobaric heat capacity, J/kg K

tCrit = nox_prop(3);

p = [0, -1, 1, 2, 3];
b = [2.49973, 0.023454, -3.80136, 13.0945, -14.518];
    
    Tr = T_Kelvin / tCrit;
    rab = 1.0 - Tr;
    shona = 1.0;
    for dd = 2:5
        shona = shona + b(dd) * rab^(p(dd));
    end
    bob = b(1) * shona * 1000.0; %convert from KJ to J
end