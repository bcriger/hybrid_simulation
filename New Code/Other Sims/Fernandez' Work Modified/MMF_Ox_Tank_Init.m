function N2O_Tank = MMF_Ox_Tank_Init()
%Subroutine to initialise main program variables */
%Gets called only once, prior to firing */
all_nox_prop = nox_prop;
MW2 = all_nox_prop(6);      % Molecular mass in g/mol
R = all_nox_prop(7);        % Universal Gas Constant
%From MMF!
% Given constants
m_loaded = 19.32933;    % N2O mass initially loaded into tank [kg]: Test 1
% m_loaded = 16.23298;    % Test 2
% m_loaded = 14.10076;    % Test 3
% m_loaded = 23.62427;    % Test 4
Ti = 286.5;             % initial temperature [K]: Test 1 
% Ti = 278.5;             % Test 2
% Ti = 271.5;             % Test 3
% Ti = 291.3              % Test 4
% Initial conditions
V = 0.0354;             % total tank volume [m^3]
n_to = m_loaded/MW2;                                        % initial total N2O intank [kmol]
Vhat_li = 1/nox_Lrho(Ti, 'mol_m3');                           % molar volume of liquid N2O [m^3/kmol]                                                        % initial temperature [K]   
P_sato = nox_vp(Ti, 'Pa');                                   % initial vapour pressure of N2O [Bar]
n_go = P_sato*(V - Vhat_li*n_to)/(-P_sato*Vhat_li + R*Ti);  % initial N2O gas [kmol]
n_lo = (n_to*R*Ti - P_sato*V)/(-P_sato*Vhat_li + R*Ti);     % initial N2O liquid [kmol]

Press_Bar = P_sato/100000;
%End
tank_volume = V; %Volume in m^3 now from MMF    
initial_ullage = n_lo/n_to;  %(Value is a percentage) - now from MMF
mdot_tank_outflow = 0.0; 
tank_fluid_temperature_K = Ti; %set to negative if unknown
tank_pressure_bar = Press_Bar;
% get initial nitrous properties
tank_liquid_density = nox_Lrho(tank_fluid_temperature_K, 'mol_m3');
%tank_vapour_density = nox_Vrho(tank_fluid_temperature_K);
% base the nitrous vapour volume on the tank percentage ullage 
%(gas head-space) 
%tank_vapour_volume = (initial_ullage/100.0)*tank_volume;
%tank_liquid_volume = tank_volume - tank_vapour_volume;
tank_liquid_mass = n_lo*tank_liquid_density;        %kg
tank_vapour_mass = m_loaded - tank_liquid_mass;     %kg
% total mass within tank
tank_propellant_contents_mass = m_loaded; 
%guessed initial value of amount of nitrous vaporised per iteration
%in the nitrous tank blowdown model (actual value is not important)
tank_liquid_mass_old = tank_liquid_mass;
mdot_tank_outflow_returned = 0.000;
first_vapour_it = 1;
    N2O_Tank = [tank_volume, ...                    % Set by MMF
            tank_fluid_temperature_K, ...           % Set by MMF
            tank_liquid_mass, ...                   % Set by MMF
            tank_vapour_mass, ...                   % Set by MMF
            tank_liquid_mass_old, ...               % == tank_liquid_mass
            mdot_tank_outflow_returned, ...         % == 0.000
            tank_pressure_bar, ...                  % Set by MMF in Bar, note:  MMF uses Pa!
            tank_propellant_contents_mass, ...      % Set by MMF
            0, ...                                  % Not Used
            0, ...                                  % Not Used
            mdot_tank_outflow, ...                  % set to 0 for first iteration
            n_lo, ...                               % number of liquid n2o moles        
            n_go, ...                               % number of gaseous n2o moles    
            0, ...
            first_vapour_it, ...                    % Not used
            0,0,0,0,0,0];
end