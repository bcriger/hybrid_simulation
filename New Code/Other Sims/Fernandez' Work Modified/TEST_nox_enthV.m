clear all

all_nox_prop = nox_prop;
MW = all_nox_prop(6);
T_Crit = all_nox_prop(3);
Low_Temp = 182.3;
High_Temp = 309.57;
gran = 0.1;

Temp_K = (Low_Temp:gran:High_Temp);
Temp_size = size(Temp_K,2);
enthV_J_kg = zeros(Temp_size);
enthV_J_kmol = zeros(Temp_size);
Error = zeros(Temp_size);

for Temp_i = 1:1:Temp_size
    T_Kelvin = Temp_K(Temp_i);
    enthV_J_kg(Temp_i) = nox_enthV(T_Kelvin, 'J_kg');
    enthV_J_kmol(Temp_i) = nox_enthV(T_Kelvin, 'J_kmol')/MW;
    Error(Temp_i) = abs(enthV_J_kg(Temp_i)-enthV_J_kmol(Temp_i))/...
        (enthV_J_kg(Temp_i)+enthV_J_kmol(Temp_i)/2)*100;
end

hold off;
figure(1), plot(Temp_K, Error, 'k'),grid, ...
    title('Error between nox entV methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Error [%]');
figure(2), plot(Temp_K, enthV_J_kg,'r', Temp_K, enthV_J_kmol, 'b'),grid, ...
    title('Values of nox enthV methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Enthalpy of Vapour N2O [J/(kg K)]');