function bob = nox_KL(T_Kelvin)
%liquid nitrous thermal conductivity, W/m K
tCrit = nox_prop(3);

b = [72.35, 1.5, -3.5, 4.5];
    %max. 10 deg C 
    if (T_Kelvin > 283.15)
        Tr = 283.15 / tCrit;
    else
        Tr = T_Kelvin / tCrit;
    end    
    rab = 1.0 - Tr;
    shona = 1.0 + b(4) * rab;
    for dd = 2:3
        shona = shona + b(dd) * rab^((dd - 1) / 3.0);
    end
    %convert from mW to W
    bob = b(1) * shona / 1000; 
end