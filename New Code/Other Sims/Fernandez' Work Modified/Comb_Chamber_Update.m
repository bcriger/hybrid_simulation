function Comb_Chamber = Comb_Chamber_Update(N2O_Tank, Comb_Chamber, dt)
FGr_m1 = Comb_Chamber(1);   %prior iteration fuel grain diameter in metres
FGr_i1 = FGr_m1/0.0254;      %prior iteration fuel grain diameter in inches   
Comb_Press = Comb_Chamber(2);   %pressure in the combustion chamber
m_fuel_dot_m1 = Comb_Chamber(3); %fuel mass flow rate in kg/s 
total_impulse = Comb_Chamber(7);
fuel_mass = Comb_Chamber(8);

all_rocket_prop = Rocket_Prop;
FGl_m = all_rocket_prop(12);    %fuel grain length, constant with time
Nports = all_rocket_prop(14);         %number of ports
rho_fuel = all_rocket_prop(15);    %kg/m^3
Nozzle_TArea = all_rocket_prop(16); %m^2  old radius = 0.01m
FG_OD_m = all_rocket_prop(17  );
N2O_Tank_Pressure = N2O_Tank(7);
%Comb_Press = N2O_Tank_Pressure * 0.8;

%Fuel and Combustion Parameters
m_ox_dot_m = N2O_Tank(11);         %oxidizer mass flow rate in kg/s 
m_ox_dot_i = m_ox_dot_m * 2.2046;  %convert oxidzer mass flow rate to lb/s

a = 0.00002788;
n = 0.8559;         %is usually between 0.4 and 0.7
m = 0.55;           %is usually between 0 and 0.25
l = 0.35;           %is usually between 0 and 0.7

%oxidizer mass flowrate per area kg/m^2-sec
Go_m =  m_ox_dot_m / (pi * FGr_m1^2);

if Go_m == 0
    Go_m = 0.000001;  %make sure we don't divide     by zero
end

%oxidizer mass flowrate per area lbm/ft^2-sec - used in calc from sutton
Go_i = Go_m * 2.2046 * 10.7639;
%Rate of change of Fuel Grain port diameter
FGrdot_i = a * Go_i ^ n;            %Inches/second?
%Radius of Fuel Grain at time step
FGr_i2 = FGr_i1 + FGrdot_i * dt;    %Radius in inches
FGr_m2 = FGr_i2 * 0.0254;           %Radius in metres
%Mass of fuel burned at time step in kg/s
m_fuel_dot_m2 = ...
    Nports*pi*(FGr_m2^2-FGr_m1^2)*FGl_m*rho_fuel/dt;

fuel_mass = fuel_mass - m_fuel_dot_m2*dt;

mof = m_ox_dot_m/m_fuel_dot_m2;
Comb_Press_psi = Comb_Press * 14.7;

%returns Isp * gravity, in s * m/s^2 (even though pressure is in psi)
%From Simulation in RPA Lite:

%% Here, we derive chamber temperature, so we can formulate an update rule
% for chamber pressure.

%Code beginning at "Go_Isp" should be deprecated, derivative of pressure
%wrt time should be inserted. You'll need to calculate the molar mass of
%combustion gas, the specific heat capacity ratio and the combustion
%chamber temperature/volume. 

Go_Isp =    - 7.342389450519946e-001 * mof^4 ...
            + 6.683230205578385e-004 * mof^3 * Comb_Press_psi ...
            + 1.200563013892130e+001 * mof^3 ...
            - 1.163922548378338e-006 * mof^2 * Comb_Press_psi^2 ...
            - 1.254222291978717e-002 * mof^2 * Comb_Press_psi ...
            - 8.797614213770305e+001 * mof^2 ...
            + 1.359060347287261e-008 * mof * Comb_Press_psi^3 ...
            - 2.359257600394199e-005 * mof * Comb_Press_psi^2 ...
            + 1.166209421943506e-001 * mof * Comb_Press_psi ...
            + 3.183596459907845e+002 * mof ...
            - 8.669302768852224e-010 * Comb_Press_psi^4 ...
            + 2.651570898636023e-006 * Comb_Press_psi^3 ...
            - 3.336370927713973e-003 * Comb_Press_psi^2 ...
            + 2.100818858859686e+000 * Comb_Press_psi ...
            + 1.197510940958335e+003;

Engine_Thrust = Go_Isp *(9.81/32.2)* (m_fuel_dot_m2 + m_ox_dot_m);
%
total_impulse = total_impulse + Engine_Thrust*dt;

CF = 1.4; %Dimensionless, see Sutton Figures 3.6, 3.6, 3.8

Comb_Press = Engine_Thrust/(CF * Nozzle_TArea)/100000; %Bar
if (Comb_Press < 1)
    Comb_Press = 1;
end

Comb_Chamber(1) = FGr_m2;
Comb_Chamber(2) = Comb_Press;
Comb_Chamber(3) = m_fuel_dot_m2;
Comb_Chamber(4) = Engine_Thrust;
Comb_Chamber(5) = mof;
Comb_Chamber(6) = Go_Isp;
Comb_Chamber(7) = total_impulse;
Comb_Chamber(8) = fuel_mass;

end