function bob = nox_Lrho(T_Kelvin, nox_prop)
    %Nitrous oxide saturated liquid density, kg/m3
    tCrit = nox_prop(3);
    rhoCrit = nox_prop(2);
    b = [1.72328, -0.8395, 0.5106, -0.10412];   
    Tr = T_Kelvin / tCrit;
    rab = 1.0 - Tr;
    shona = 0.0;
    for dd = 1:4
        shona = shona + b(dd) * rab^(dd / 3.0);
    end
    bob = rhoCrit * exp(shona);
end