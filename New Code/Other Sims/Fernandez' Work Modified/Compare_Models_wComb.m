% Compares Rick Newlands and MM Fernandez Draining of N2O tank models
clear all
clc
% Forward Difference Time Loop
tf = 9.53;                       % final time [s]
dt = 0.001;                    % time step [s]
i_f = tf/dt;
time = (0+dt:dt:tf);
size(time)
MMF_Tank_Time = zeros(21,i_f);
WRT_Tank_Time = zeros(21,i_f); 
%PRF_Tank_Time = zeros(21,i_f);

MMF_Comb_Time = zeros(7,i_f);
WRT_Comb_Time = zeros(7,i_f);
%PRF_Comb_Time = zeros(7,i_f);

%Set the initial values in the N2O the instant before engine firing
MMF_Tank_Time(:,1) = MMF_Ox_Tank_Init();
%PRF_Tank_Time(:,1) = PRF_Tank_Init();
WRT_Tank_Time(:,1) = MMF_Ox_Tank_Init();

MMF_Comb_Time(:,1) = Comb_Chamber_Init();
%PRF_Comb_Time(:,1) = Comb_Chamber_Init();
WRT_Comb_Time(:,1) = Comb_Chamber_Init();

for i=2:i_f;
    t = i*dt;
    % Curve fitted combustion chamber pressure [Pa]:
    MMF_Comb_Time(:,i) = Comb_Chamber_Update(MMF_Tank_Time(:,i-1),...
                                             MMF_Comb_Time(:,i-1),... 
                                             dt);       
%    PRF_Comb_Time(:,i) = Comb_Chamber_Update(PRF_Tank_Time(:,i-1),... 
%                                             MMF_Comb_Time(:,i-1),...
%                                             dt);
    WRT_Comb_Time(:,i) = Comb_Chamber_Update(WRT_Tank_Time(:,i-1),... 
                                             MMF_Comb_Time(:,i-1),...
                                             dt);
    MMF_Pe = MMF_Comb_Time(2,i);
%    PRF_Pe = PRF_Comb_Time(2,i);
    WRT_Pe = WRT_Comb_Time(2,i);
    
    MMF_Tank_Time(:,i) = MMF_ideal_tank_with_liquid(MMF_Tank_Time(:,i-1), MMF_Pe, dt);
%    PRF_Tank_Time(:,i) = Model2_drainA_FD(PRF_Tank_Time(:,i-1), PRF_Pe, dt);
    WRT_Tank_Time(:,i) = WRT_tank_with_liquid(WRT_Tank_Time(:,i-1), WRT_Pe, dt);
end

%Plot results
figure(1), plot(time,MMF_Tank_Time(2,:),'r', ...                            %time,PRF_Tank_Time(2,:),'b', ...
                time,WRT_Tank_Time(2,:),'k', ...
                'LineWidth',2),grid, ...
    title('Temperature vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Temperature [K]'), ...
    legend('MMF tank temperature', ...
            'WRT tank temperature', ...                                     %'MMF PR tank temperature', 
            1); 
figure(2), plot(time,MMF_Tank_Time(13,:),'r',time,MMF_Tank_Time(12,:),'r', ... %time,PRF_Tank_Time(13,:),'b',time,PRF_Tank_Time(12,:),'b', ...
                time,WRT_Tank_Time(13,:),'k',time,WRT_Tank_Time(12,:),'k', ...
                time,WRT_Tank_Time(6,:)/44.013,'b',...
                'LineWidth',2),grid, ...
    title('Temperature vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('kmol of N2O [kmol]'), ...
    legend('MMF ideal kmol of N2O gas','MMF kmol of N2O liquid',...         %'MMF PR kmol of N2O gas', 'MMF PR kmol of N2O liquid',...
            'WRT kmol of N2O gas','WRT kmol of N2O liquid' ,1);
figure(3), plot(time,MMF_Tank_Time(7,:),'r', ...                            %time,PRF_Tank_Time(7,:),'b',...
                time,WRT_Tank_Time(7,:),'k',...
                'LineWidth',2),grid, ...
    title('Pressure vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Pressure [Pa]');
    legend('MMF tank pressure', ...
            'WRT tank pressure', ...                                       %'MMF PR tank pressure',...
            1); 
figure(4), plot(time,MMF_Tank_Time(11,:)/44.013,'r', ...                   %time,PRF_Tank_Time(11,:),'b',...
                time,WRT_Tank_Time(11,:)/44.013,'k',...
                'LineWidth',2),grid, ...
    title('N2O flowrate vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('N2O flowrate [kg/s]');
    legend('MMF N2O flowrate','WRT N2O flowrate',1);    
figure(5), plot(time,MMF_Comb_Time(4,:),'r', ...                            %time,PRF_Comb_Time(4,:),'b',...
                time,WRT_Comb_Time(4,:),'k',...
                'LineWidth',2),grid, ...
    title('Engine Thrust vs. Time'), ...
    xlabel('Time [s]'), ...
    ylabel('Engine Thrust [N]');
    legend('MMF Engine Thrust','WRT Engine Thrust',1); 
figure(6), plot(time,WRT_Tank_Time(6,:),'r');
MMF_Comb_Time(7,i_f)
WRT_Comb_Time(7,i_f)