function Comb_Chamber = Comb_Chamber_Init

%Initial Fuel Grain Dimensions
all_rocket_prop = Rocket_Prop;
FG_Len_m = all_rocket_prop(12);
FG_ID_m = all_rocket_prop(13);
FG_OD_m = all_rocket_prop(18);
FG_Den = all_rocket_prop(15);

V = pi*(FG_ID_m^2)*FG_Len_m;
fuel_mass = pi*(FG_OD_m^2 - FG_ID_m^2)*FG_Len_m*FG_Den;
Comb_Press = 1;
FGr_m = all_rocket_prop(13)/2; %m
m_fuel_dot_m2 = 0;
rho = 4.3; %nox_Vrho(300);
%RCoeff1 = a*(2*n+1)*(m_ox_dot_i/(pi*Nports))^n;

Comb_Chamber = [FGr_m, ...
                Comb_Press, ...
                m_fuel_dot_m2 ...
                0,0,0,0,...
                fuel_mass,...
                V,...
                rho];
end