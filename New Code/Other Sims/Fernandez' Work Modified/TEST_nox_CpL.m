clear all

all_nox_prop = nox_prop;
MW = all_nox_prop(6);
Low_Temp = 182.3;
High_Temp = 200;
gran = 0.1;

Temp_K = (Low_Temp:gran:High_Temp);
Temp_size = size(Temp_K,2);
CpL_J_kgK = zeros(Temp_size);
CpL_J_kmolK = zeros(Temp_size);
Error = zeros(Temp_size);

for Temp_i = 1:1:Temp_size
    T_Kelvin = Temp_K(Temp_i);
    CpL_J_kgK(Temp_i) = nox_CpL(T_Kelvin, 'J_kgK');
    CpL_J_kmolK(Temp_i) = nox_CpL(T_Kelvin, 'J_kmolK')/MW;
    Error(Temp_i) = abs(CpL_J_kgK(Temp_i)-CpL_J_kmolK(Temp_i))/...
        (CpL_J_kgK(Temp_i)+CpL_J_kmolK(Temp_i)/2)*100;
end

hold off;
figure(1), plot(Temp_K, Error, 'k'),grid, ...
    title('Error between nox CpL methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Error [%]');
figure(2), plot(Temp_K, CpL_J_kgK,'r', Temp_K, CpL_J_kmolK, 'b'),grid, ...
    title('Values of nox CpL methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Specific Heat Capacity of Liquid N2O [J/(kg K)]');