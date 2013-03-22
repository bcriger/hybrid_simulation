function Cp = nox_CpL(T_Kelvin, units)
%Nitrous saturated liquid isobaric heat capacity, J/kg K
all_nox_prop = nox_prop;
tCrit = all_nox_prop(3);

if 1 == strcmp(units, 'J_kgK')
    p = [0, -1, 1, 2, 3];
    b = [2.49973, 0.023454, -3.80136, 13.0945, -14.518];
    
    Tr = T_Kelvin / tCrit;
    rab = 1.0 - Tr;
    shona = 1.0;
    for dd = 2:5
        shona = shona + b(dd) * rab^(p(dd));
    end
    Cp = b(1) * shona * 1000.0; %convert from KJ to J
elseif 1 == strcmp(units, 'J_kmolK')
    if T_Kelvin > 200
        disp('In nox_CpL, Temperature is higher than valid range')
    elseif T_Kelvin < 182.3
        disp('In nox_CpL, Temperature is lower than valid range')
    end 
    % Perry's Chemical Engineers' Handbook Property Equations
    E1 = 6.7556e4;      % heat capacity of N2O liquid at constant pressure [J/(kmol*K)] coefficients
    E2 = 5.4373e1;      % valid for Temp range [182.3 K - 200K]
    E3 = 0;
    E4 = 0;
    E5 = 0;
    Cp = E1 + E2*T_Kelvin + E3*T_Kelvin^2 + E4*T_Kelvin^3 + E5*T_Kelvin^4;
        %specific heat of N2O liquid at constant volume, approx. same as at
        %constant pressure [J/(kmol*K)]
end    
end