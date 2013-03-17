clear all

all_nox_prop = nox_prop;
MW = all_nox_prop(6);
T_Crit = all_nox_prop(3);
Low_Temp = 182.3;
High_Temp = 309.57;
gran = 0.1;

Temp_K = (Low_Temp:gran:High_Temp);
Temp_size = size(Temp_K,2);
Lrho_kg_m3 = zeros(Temp_size);
Lrho_mol_m3 = zeros(Temp_size);
Error = zeros(Temp_size);

for Temp_i = 1:1:Temp_size
    T_Kelvin = Temp_K(Temp_i);
    Lrho_kg_m3(Temp_i) = nox_Lrho(T_Kelvin, 'kg_m3');
    Lrho_mol_m3(Temp_i) = nox_Lrho(T_Kelvin, 'mol_m3')*MW;
    Error(Temp_i) = abs(Lrho_kg_m3(Temp_i)-Lrho_mol_m3(Temp_i))/...
        (Lrho_kg_m3(Temp_i)+Lrho_mol_m3(Temp_i)/2)*100;
end

hold off;
figure(1), plot(Temp_K, Error, 'k'),grid, ...
    title('Error between nox Lrho methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Error [%]');
figure(2), plot(Temp_K, Lrho_kg_m3,'r', Temp_K, Lrho_mol_m3, 'b'),grid, ...
    title('Values of nox Lrho methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Density of Liquid N2O [kg/m^3]');