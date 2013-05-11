function bob = nox_Lrho(T_Kelvin, nox_prop)
% Direct Copypasta from aspirespace.org.uk,
% under Technical Papers::Modelling the nitrous run tank emptying
% Author: Rick Newlands. Updated 03/01/12. Middle of page 8.

%Nitrous oxide saturated liquid density, kg/m^3

critical_Temperature = nox_prop(3);
critical_Density = nox_prop(2);

%Imperically-derived parameters:
b = [1.72328, -0.8395, 0.5106, -0.10412];


scaled_Temperature = T_Kelvin / critical_Temperature;
rab = 1.0 - scaled_Temperature;
shona = 0.0;

%Equation of state:
for dd = 1:4
    shona = shona + b(dd) * rab^(dd / 3.0);
end

bob = critical_Density * exp(shona);
end