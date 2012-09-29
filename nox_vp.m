function bob = nox_vp(T_Kelvin, nox_prop)
% Nitrous oxide vapour pressure, Bar 
    p = [1.0, 1.5, 2.5, 5.0];
    b = [-6.71893, 1.35966, -1.3779, -4.051];
    
    pCrit = nox_prop(1);
    tCrit = nox_prop(3);

    Tr = T_Kelvin / tCrit;
    rab = 1.0 - Tr;
    shona = 0.0;
    for dd = 1:4
        shona = shona + b(dd) * rab ^ p(dd);
    end
    bob = pCrit * exp(shona / Tr);
end
