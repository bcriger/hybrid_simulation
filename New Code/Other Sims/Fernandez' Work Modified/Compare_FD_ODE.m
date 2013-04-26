% Compares Rick Newlands and MM Fernandez Draining of N2O tank models
clear all
clc
% Forward Difference Time Loop
tf = 1.00;%4.75;                       % final time [s]
dt = .000045;%0.00009;                    % time step [s]
i_f = tf/dt;
time = (0+dt:dt:tf);
size(time)
PRF_FDM_Tank_Time = zeros(21,i_f);
PRF_ODE_Tank_Time = zeros(21,i_f);
%Set the initial values in the N2O the instant before engine firing
PRF_FDM_Tank_Time(:,1) = PRF_Tank_Init();
PRF_ODE_Tank_Time(:,1) = PRF_Tank_Init();

for i=2:i_f;
    t = i*dt;
    % Curve fitted combustion chamber pressure [Pa]:
    Pe =-2924.42*t^6 + 46778.07*t^5 - 285170.63*t^4 + 813545.02*t^3 - ...
        1050701.53*t^2 + 400465.85*t +1175466.2;
    % Pe = 95.92*t^6 - 2346.64*t^5 + 21128.78*t^4 - 87282.73*t^3 + ...
    %    186675.17*t^2 - 335818.91*t + 3029190.03;
    % Pe = 58.06*t^6 - 1201.90*t^5 + 8432.11*t^4 - 22175.67*t^3 + ...
    %    21774.66*t^2 - 99922.82*t = 2491369.68;
    % Pe = -4963.73*t + 910676.22;
    Pe = Pe/100000;  %Convert pressure to Bar from Pa
    PRF_FDM_Tank_Time(:,i) = Model2_drainA_FD(PRF_FDM_Tank_Time(:,i-1), Pe, dt);
    % Physical stops to kick out of loop
    P = PRF_FDM_Tank_Time(7,i);
    n_lo = PRF_FDM_Tank_Time(12,i);
    if Pe>=P
        break
    end
    if n_lo<=0
        break
    end    
end
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

[Po,n2vo,n2lo,y2o] = Model2_IC(1,0,nT,Tsur,Vol);
IC = [Tsur Po n2lo n2vo]';
[t_out,x_out] = ode45(@Model2_drainA_sol,time,IC);

T = x_out(:,1);
P = x_out(:,2)/100000;
n2l = x_out(:,3);
n2v = x_out(:,4);

%Plot results
figure(1), plot(time,PRF_FDM_Tank_Time(2,:),'b', ...
                time,T,'k', ...
                'LineWidth',2),grid, ...
    title('Temperature vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Temperature [K]');
figure(2), plot(time,PRF_FDM_Tank_Time(13,:),'b',time,PRF_FDM_Tank_Time(12,:),'b', ...
                time,n2l,'k',time,n2v,'k', ...
                'LineWidth',2),grid, ...
    title('N2O Moles vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('kmol of N2O [kmol]');%, ...
    legend('FDM PR kmol of N2O gas', 'FDM PR kmol of N2O liquid',...
           'ODE kmol of N2O gas','ODE kmol of N2O liquid' ,1);
figure(3), plot(time,PRF_FDM_Tank_Time(7,:),'b',...
                time,P, 'k',...
                'LineWidth',2),grid, ...
    title('Pressure vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Pressure [Pa]');
    legend('FDM tank pressure','ODE tank pressure',1); 
% figure(4), plot(time,MMF_Tank_Time(11,:),'r', ...
%                 time,PRF_FDM_Tank_Time(11,:),'b',...
%                 time,WRT_Tank_Time(11,:), 'k',...
%                 'LineWidth',2),grid, ...
%     title('N2O flowrate vs. Time'), ...
%     xlabel('Time [s]'), ...
%     ylabel('N2O flowrate [kg/s]');
%     legend('MMF N2O flowrate','WRT N2O flowrate',1);    