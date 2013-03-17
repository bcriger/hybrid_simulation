clear all

all_nox_prop = nox_prop;
MW = all_nox_prop(6);
T_Crit = all_nox_prop(3);
Low_Temp = 182.3;
High_Temp = 309.57;
gran = 0.1;

Temp_K = (Low_Temp:gran:High_Temp);
Temp_size = size(Temp_K,2);
VapP_Bar = zeros(Temp_size);
VapP_Pa = zeros(Temp_size);
Error = zeros(Temp_size);

for Temp_i = 1:1:Temp_size
    T_Kelvin = Temp_K(Temp_i);
    VapP_Bar(Temp_i) = nox_vp(T_Kelvin, 'Bar');
    VapP_Pa(Temp_i) = nox_vp(T_Kelvin, 'Pa')/100000;
    Error(Temp_i) = abs(VapP_Bar(Temp_i)-VapP_Pa(Temp_i))/...
        (VapP_Bar(Temp_i)+VapP_Pa(Temp_i)/2)*100;
end

hold off;
figure(1), plot(Temp_K, Error, 'k'),grid, ...
    title('Error between nox VapP methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Error [%]');
figure(2), plot(Temp_K, VapP_Bar,'r', Temp_K, VapP_Pa, 'b'),grid, ...
    title('Values of nox Vapour Pressure methods'), ...
    xlabel('Temperature [K]'), ...
    ylabel('Vapour Pressure N2O [Bar]');