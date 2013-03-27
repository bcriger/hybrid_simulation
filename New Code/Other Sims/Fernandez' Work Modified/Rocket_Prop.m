function rocket_prop = Rocket_Prop()
%Returns the static properties of the rocket (engine) to be simulated
Profile = 'MMF';% Use this variable to determine which of the profiles
                % will be used for the simulation
if 1 == strcmp(Profile, 'MMF') 
%N2O Tank Properties
    %Volume of tank
    N2O_Tank_V = 0.0354; % total tank volume [m^3]
    N2O_Ti = 286.5;             % initial temperature [K]: Test 1 
    % N20_Ti = 278.5;             % Test 2
    % N20_Ti = 271.5;             % Test 3
    % N20_Ti = 291.3              % Test 4
    % Given constants
    N2O_m_loaded = 19.32933;    % N2O mass initially loaded into tank [kg]: Test 1
    % N2O_m_loaded = 16.23298;    % Test 2
    % N2O_m_loaded = 14.10076;    % Test 3
    % N2O_m_loaded = 23.62427;    % Test 4
elseif 1 == strcmp(Profile, 'WRT')
end    
rocket_prop = [
    N2O_Tank_V,...
    N2O_Ti,...
    N2O_m_loaded];
end