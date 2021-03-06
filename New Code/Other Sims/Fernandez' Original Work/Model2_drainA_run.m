% Margaret Mary Fernandez's Master's Thesis
% Non Ideal (Peng-Robinson), High Pressure Equilibrium Model
% draining Tank Calculation - ODE45 Run File

clear all
clc

% ---------------- Get Initial Conditions from Model2_IC.m ----------------
y2_guess = 1;               % Guess mol fraction N2O
nHe = 0;                    % He in tank [kmol]
mloaded = 19.32933;         % mass of N2O initially loaded into tank [kg]: Test 1
% mloaded = 16.23298;         % Test 2
% mloaded = 14.10076          % Test 3 
% mloaded = 23.62427;         % Test 4
MW2 = 44.013;                % molecular weight of N2O [kg/kmol]
nT = mloaded/MW2;           % total N2O loaded into tank [kmol]
Tsur = 286.5;               % inital temperature in tank [K]: Test 1
% Tsur = 278.5;               % Test 2
% Tsur = 271.5;               % Test 3
% Tsur = 291.3;               % Test 4
Vol = 0.0354;               % total volume of tank [m^3]

[Po,n2vo,n2lo,y2o] = Model2_IC(y2_guess,nHe,nT,Tsur,Vol);
% -------------------------------------------------------------------------
% Note: if "nHe" or "Vol" are change above, change them in
% Model2_drainA_sol.m

IC = [Tsur Po n2lo n2vo]';
time = (0:0.0005:4.8)';

% Matlab ODE: Implicit Solution Method
[t_out,x_out] = ode45(@Model2_drainA_sol,time,IC);

T = x_out(:,1);
P = x_out(:,2);
n2l = x_out(:,3);
n2v = x_out(:,4);

figure(4),plot(t_out,x_out(:,1),'r','LineWidth',2),grid, ...
    title('Temperature vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Temperature [K]');
figure(5),plot(t_out,x_out(:,2),'m','Linewidth',2),grid, ...
    title('Pressure vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Pressure [Pa]');
figure(6),plot(t_out,x_out(:,3),'g',t_out,x_out(:,4),'b','LineWidth',2),grid, ...
    title('kmol of N2O vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('kmol of N2O [kmol]'), ...
    legend('kmol of N2O liquid','kmol of N2O gas',1);
%final temp should be ~271.7 ish
%final amount of liqid N2O should be 0
%final pressure should be around 3.1*10^6 bar