function enthalpy = nox_CpG(T_Kelvin, units)
%Nitrous Oxide Gas isobaric heat capacity, J/kmol K
all_nox_prop = nox_prop;
tCrit = all_nox_prop(3);
R = all_nox_prop(7);    
if 1 == strcmp(units, 'J_kmolK')
    % Perry's Chemical Engineers' Handbook Property Equations
    D1 = 0.2934e5;      % heat capacity of N2O gas at constant pressure [J/(kmol*K)] coefficients
    D2 = 0.3236e5;      % valid for Temp range [100 K - 200 K]
    D3 = 1.1238e3;      
    D4 = 0.2177e5;
    D5 = 479.4;
    enthalpy = D1 + D2*((D3/T_Kelvin)/sinh(D3/T_Kelvin))^2 + D4*((D5/T_Kelvin)/cosh(D5/T_Kelvin))^2 - R;
end
    
end