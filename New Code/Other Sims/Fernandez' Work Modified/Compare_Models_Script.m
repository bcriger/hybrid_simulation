% Compares Rick Newlands and MM Fernandez Draining of N2O tank models
clear all
clc
% Forward Difference Time Loop
tf = 10;                       % final time [s]
dt = 0.0005;                    % time step [s]
i_f = tf/dt;
time = (0+dt:dt:tf);
size(time)
MMF_Tank_Time = zeros(21,i_f);
size(MMF_Tank_Time)
WRT_Tank_Time = zeros(21,i_f); 
%Set the initial values in the N2O the instant before engine firing
MMF_Tank_Time(:,1) = MMF_Ox_Tank_Init();
WRT_Tank_Time(:,1) = MMF_Ox_Tank_Init();
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
    MMF_Tank_Time(:,i) = MMF_ideal_tank_with_liquid(MMF_Tank_Time(:,i-1), Pe, dt);
    WRT_Tank_Time(:,i) = WRT_tank_with_liquid(WRT_Tank_Time(:,i-1), Pe, dt);
    % Physical stops to kick out of loop
    P = MMF_Tank_Time(7,i)*100000; %Convert pressure to Pa from Bar
    n_lo = MMF_Tank_Time(12,i);
    if Pe>=P
        break
    end
    if n_lo<=0
        break
    end    
end
    
%Plot results
%figure(1), plot(t,MMF_Tank_Time(2,:),'r',t,WRT_Tank_Time(2,:),'k','LineWidth',2),grid, ...
figure(1), plot(time,MMF_Tank_Time(2,:),'r','LineWidth',2),grid, ...
    title('Temperature vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Temperature [K]');
figure(2), plot(time,MMF_Tank_Time(13,:),'b',time,MMF_Tank_Time(12,:),'g','LineWidth',2),grid, ...
    title('Temperature vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('kmol of N2O [kmol]'), ...
    legend('kmol of N2O gas','kmol of N2O liquid',1);
figure(3), plot(time,MMF_Tank_Time(7,:),'r',time,WRT_Tank_Time(7,:), 'k','LineWidth',2),grid, ...
    title('Pressure vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Pressure [Pa]');
    legend('MMF tank pressure','WRT tank pressure',1);    