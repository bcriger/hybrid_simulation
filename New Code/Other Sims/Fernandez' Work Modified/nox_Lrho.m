function density = nox_Lrho(T_Kelvin, units)
 %Nitrous oxide saturated liquid density, kg/m^3 or mol/m^3
 if 1 == strcmp(units , 'kg_m3')
    % Direct Copypasta from aspirespace.org.uk,
    % under Technical Papers::Modelling the nitrous run tank emptying
    % Author: Rick Newlands. Updated 03/01/12. Middle of page 8.
    all_nox_prop = nox_prop;
    critical_Temperature = all_nox_prop(3);
    critical_Density = all_nox_prop(2);
    %Imperically-derived parameters:
    b = [1.72328, -0.8395, 0.5106, -0.10412];
    scaled_Temperature = T_Kelvin / critical_Temperature;
    rab = 1.0 - scaled_Temperature;
    shona = 0.0;
    %Equation of state:
    for dd = 1:4
        shona = shona + b(dd) * rab^(dd / 3.0);
    end
    density = critical_Density * exp(shona);
elseif 1 == strcmp(units, 'mol_m3')
    % Perry's Chemical Engineers' Handbook Property Equations
    Q1 = 2.781;         %molar specific volume of liquid N2O [m^3/kmol] coefficients
    Q2 = 0.27244;
    Q3 = 309.57;
    Q4 = 0.2882;
    density = 1/(Q2^(1+(1-T_Kelvin/Q3)^Q4)/Q1);
end
end