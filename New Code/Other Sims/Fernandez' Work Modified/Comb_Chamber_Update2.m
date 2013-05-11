function Comb_Chamber = Comb_Chamber_Update2(N2O_Tank, Comb_Chamber, dt)
FGr_m1          = Comb_Chamber(1); %prior iteration fuel grain diameter in metres
Comb_Press      = Comb_Chamber(2); %pressure in the combustion chamber
m_fuel_dot_m1   = Comb_Chamber(3); %fuel mass flow rate in kg/s 
total_impulse   = Comb_Chamber(7);
fuel_mass       = Comb_Chamber(8);
V               = Comb_Chamber(9);
rho             = Comb_Chamber(10);

% Oxidizer mass flow rate
mox_dot = N2O_Tank(11);

all_rocket_prop = Rocket_Prop;
FGl_m           = all_rocket_prop(12);    %fuel grain length, constant with time
Nports          = all_rocket_prop(14);    %number of ports
rho_fuel        = all_rocket_prop(15);    %kg/m^3
Nozzle_TArea    = all_rocket_prop(16);    %m^2  old radius = 0.01m
Nozzle_EArea    = all_rocket_prop(17);
FG_OD_m         = all_rocket_prop(18);

%a = 0.00002788;
a = 0.00041919;
n = 0.8559;         %is usually between 0.4 and 0.7
m = 0.55;           %is usually between 0 and 0.25
l = 0.35;           %is usually between 0 and 0.7

a = 0.22*10^-4;
n = 0.68;
m = 0.07;
l = 0.09;   %try different m values

%oxidizer mass flowrate per area kg/m^2-sec
% Go_m =  mox_dot / (pi * FGr_m1^2);
% 
% if Go_m == 0
%     Go_m = 0.000001;  %make sure we don't divide by zero
% end

P = Comb_Press;%*100000;  % Get from previous iteration, convert to Pa

%oxidizer mass flowrate per area lbm/ft^2-sec - used in calc from sutton
%Go_i = Go_m * 2.2046 * 10.7639;
%Rate of change of Fuel Grain port diameter
%FGrdot_i = a*2^l*pi^(-n)*mox_dot^n*P^m*r^(l-2*n);          %Inches/second?
%Radius of Fuel Grain at time step
%FGr_i2 = FGr_i1 + FGrdot_i * dt;    %Radius in inches
%FGr_m2 = FGr_i2 * 0.0254;           %Radius in metres
%Mass of fuel burned at time step in kg/s
% m_fuel_dot_m2 = ...
%     Nports*pi*(FGr_m2^2-FGr_m1^2)*FGl_m*rho_fuel/dt;

%mof = m_ox_dot_m/m_fuel_dot_m2;
%Comb_Press_psi = Comb_Press * 14.7;

%balance parameters
% Ratio of specific heats
k = 1.5;    %obtained from source using PP fuel and n2o ox.
%X = (V - V_i)/(V_f - V_i);
c_vol = a*FGl_m^(n+1/2-l/2)*2^(n+1/2+l/2)*pi^(1/2-l/2); %BEN CHECK MAY 10
%delta_V = c_vol*mox_dot_i^n*V^(-n+1/2+l/2)*P_i^m;
%V = V_i + X(V_f - V_i);
LAMDA = sqrt(k*(2/(k+1))^((k+1)/(k-1))); %BEN CHECK MAY 10
% Heat quantity ejected by burning reaction of 1kg of solid fuel
Qcs = 2.5d6;  %[J/kg] %UNCHECKABLE
% amount of heat transferred to the combustion chamber in time unit
q = 1000;   %[J/s] obtained from paper %UNCHECKABLE
% gas constant in burning chamber
%R = 336.6777; %[J/kg/K] - obtained from source using PP fuel and n2o ox.
%C_V = R/(k-1);

%linear equations
aVV = (-n+1/2+l/2)*c_vol*mox_dot^n*P^m*V^(-n-1/2+l/2);%BEN CHECK MAY 10
aPV = m*c_vol*mox_dot^n*P^(m-1)*V^(-n+1/2+l/2);%BEN CHECK MAY 10
bMV = n*c_vol*mox_dot^(n-1)*P^m*V^(-n+1/2+l/2);%BEN CHECK MAY 10
aVR = (-n-1/2+l/2)*(rho_fuel-rho)*c_vol*mox_dot^n*P^m*V^(-n-3/2+l/2)...
    +LAMDA*Nozzle_TArea*P^(1/2)*rho^(1/2)*V^(-2)-mox_dot*V^-2;%BEN CHECK MAY 10
aRR = -c_vol*mox_dot*P^m*V^(-n-1/2+l/2)...
    -1/2*LAMDA*Nozzle_TArea*P^(1/2)*rho^(-1/2)*V^(-1);%BEN CHECK MAY 10
aPR = m*(rho_fuel-rho)*c_vol*mox_dot^n*P^(m-1)*V^(-n-1/2+l/2) ...
    -1/2*LAMDA*Nozzle_TArea*P^(-1/2)*rho^(1/2)*V^-1;%BEN CHECK MAY 10
bMR = n*(rho_fuel-rho)*c_vol*mox_dot^(n-1)*P^m*V^(-n-1/2+l/2)+V^(-1);%BEN CHECK MAY 10
aVP = (-n-1/2+l/2)*(k-1)*rho_fuel*Qcs*c_vol*mox_dot^n*P^m*V^(-n-3/2+l/2)...
    +k*LAMDA*Nozzle_TArea*rho^(-1/2)*P^(3/2)*V^(-2)+(k-1)*q*V^(-2);%BEN CHECK MAY 10
aRP = 1/2*k*LAMDA*Nozzle_TArea*rho^(-3/2)*P^(3/2)*V^-1;%BEN CHECK MAY 10
aPP = m*(k-1)*rho_fuel*Qcs*c_vol*mox_dot^n*P^(m-1)*V^(-n-1/2+l/2) ...
    -3/2*k*LAMDA*Nozzle_TArea*rho^(-1/2)*P^(1/2)*V^(-1);%BEN CHECK MAY 10
bMP = n*(k-1)*rho_fuel*Qcs*c_vol*mox_dot^(n-1)*P^m*V^(-n-1/2+l/2);%BEN CHECK MAY 10
% develop state-space equations for the engine
SYS_mat = [aVV 0 aPV; aVR aRR aPR; aVP aRP aPP];
CON_mat = [bMV; bMR; bMP];
% set up the 'X' matrix, and determine the next values
X_mat       = [V; rho; P];
X_mat_dot   = SYS_mat*X_mat + CON_mat*mox_dot;
X_mat       = X_mat_dot*dt + X_mat;

if mox_dot ~= 0
    V   = X_mat(1,1);
    rho = X_mat(2,1);
    P   = X_mat(3,1);
end

% lamda:  Ratio between velocity in exit plane and velocity in throat area
% solved iteratively
a1 = 1/(1-k);                               %the following are coeff's
b1 = (1-k)/(1+k);                           %used to solve for lamda
c1 = Nozzle_TArea/Nozzle_EArea*((k+1)/2)^a1;
lamda_error = 1;
lamda_i = 1;
iteration_count = 0;
while(lamda_error > 0.0001)||(iteration_count < 1000)
    lamda_iP1 = lamda_i - ((lamda_i - c1*(1 + b1)*lamda_i^2)^a1)/...
        (1 - 2*a1*b1*c1*lamda_i*(1+b1*lamda_i^2)^(a1-1));  
    lamda_error = abs(lamda_i - lamda_iP1)/lamda_iP1;
    iteration_count = iteration_count + 1;
end
lamda = lamda_iP1;

% Thrust Loss Coefficient
sigma_c = 0.90;     % Obtained from same source as model.
% Atmospheric Pressure
P_atm = 101325;     %[Pa]

Engine_Thrust = Nozzle_EArea*P_atm*(sigma_c*(P/P_atm)*...
    Nozzle_TArea/Nozzle_EArea*k*(2/(k+1)^(1/(k-1))*(lamda - 1)));

total_impulse = total_impulse + Engine_Thrust*dt;

%fuel_mass = fuel_mass - m_fuel_dot_m2*dt;
Comb_Press = P;%/100000; %Pressure in Bar

% if Comb_Press < 1
%     Comb_Press = 1;
% end             

%Comb_Chamber(1) = FGr_m2;
Comb_Chamber(2) = Comb_Press;
%Comb_Chamber(3) = m_fuel_dot_m2;
Comb_Chamber(4) = Engine_Thrust;
%Comb_Chamber(5) = mof;
%Comb_Chamber(6) = Go_Isp;
Comb_Chamber(7) = total_impulse;
Comb_Chamber(8) = fuel_mass;
Comb_Chamber(9) = V;
Comb_Chamber(10) = rho;
end