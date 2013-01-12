function bob = nox_Vrho(T_Kelvin, nox_prop)
%Nitrous oxide saturated vapour density, kg/m3
    rhoCrit = nox_prop(2);
    tCrit = nox_prop(3);
    
    b = [-1.009, -6.28792, 7.50332, -7.90463, 0.629427];
    Tr = T_Kelvin / tCrit;
    rab = (1.0 / Tr) - 1.0;
    shona = 0.0;
    for dd = 1:5
        shona = shona+ b(dd) * rab^((dd) / 3.0);
    end
    bob = rhoCrit * exp(shona);
end