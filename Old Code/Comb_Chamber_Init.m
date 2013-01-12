function Comb_Chamber = Comb_Chamber_Init;

%Initial Fuel Grain Dimensions
Comb_Press = 1;
FGr_m = 0.0175; %m
m_fuel_dot_m2 = 0;
%RCoeff1 = a*(2*n+1)*(m_ox_dot_i/(pi*Nports))^n;

Comb_Chamber = [FGr_m, ...
                Comb_Press, ...
                m_fuel_dot_m2 ...
                0,0,0];
end