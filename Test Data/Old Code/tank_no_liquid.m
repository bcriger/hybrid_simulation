function N2O_Tank = tank_no_liquid(N2O_Tank, Comb_Chamber, ...
                                    N2O_Valve, nox_prop, dt)
%subroutine to model the tank emptying of vapour only
%Isentropic vapour-only blowdown model
    %Basic Nitrous Oxide properties
    pCrit = nox_prop(1);
    ZCrit = nox_prop(4);
    gamma = nox_prop(5);
    %obtain the required conditions in the combustion chamber,
    %nitrous oxide tank, and valve
    %Combustion Chamber Pressure in Bar
    chamber_press_bar = Comb_Chamber(2);
    %Tank Volume in Litres
    tank_volume = N2O_Tank(1); 
    %Fluid Temperature in Kelvin
    tank_fluid_temperature_K = N2O_Tank(2);
    %Mass of Fluid that is Liquid in kg
    tank_liquid_mass = N2O_Tank(3);
    %Mass of Fluid that is vapour in kg
    tank_vapour_mass = N2O_Tank(4);
    %Mass of Liquid from previous iteration
    tank_liquid_mass_old = N2O_Tank(5);
    %Mass of Vapour from previous iteration
    tank_vapour_mass_old = N2O_Tank(6);
    %Nitrous Oxide Pressure in Bar
    tank_pressure_bar = N2O_Tank(7);
    %Sum of Liquid and Vapour in Nitrous Oxide Tank - check
    tank_propellant_contents_mass = N2O_Tank(8);
    %Vapour Density in (Units to be checked)
    tank_vapour_density = N2O_Tank(10);
    %Mass of oxidizer leaving the tank (kg/s)
    mdot_tank_outflow = N2O_Tank(11);
    %Mass of oxidizer leaving the tank from previous iteration (kg/s)
    mdot_tank_outflow_old = N2O_Tank(21);
    %A flag for determining if there is still liquid oxidizer in the tank, 
    %or just vapour
    first_vapour_it = N2O_Tank(15);
    %the conditions at the instant where the tank is vapour only
    %have an impact on how the gas behaves until the contents are 
    %completely expended
    if (first_vapour_it == 1)
        %Temperature of Vapour at transition iteration in Kelvin
        initial_vapour_temp_K = N2O_Tank(2);
        %Mass of Vapour at transition iteration in kg
        initial_vapour_mass = N2O_Tank(4);
        %Pressure of Vapour at transition iteration in Bar
        initial_vapour_pressure_bar = N2O_Tank(7);
        %Density of Vapour at transition iteration in (check)
        initial_vapour_density = N2O_Tank(10);
        %Compressibility Factor of Vapour at transition iteration-no units
        initial_Z = ...
            LinearInterpolate(tank_pressure_bar, 0.0, 1.0, pCrit, ZCrit);
        %in the previous iteration, it was assumed liquid only was exiting
        %the tank, but since there is only vapour left, the old mass
        %outflow would be misleading
        old_mdot_tank_outflow = 0.0; %reset
        first_vapour_it = 0;
        %Positions 15-20 remain unchanged for the rest of the simulation 
        %and are only set here
        N2O_Tank(15) = first_vapour_it;
        N2O_Tank(16) = initial_vapour_temp_K;
        N2O_Tank(17) = initial_vapour_mass;
        N2O_Tank(18) = initial_vapour_pressure_bar;
        N2O_Tank(19) = initial_vapour_density;
        N2O_Tank(20) = initial_Z;
    else
        %Get some more reader-friendly names for the values stored
        %during the tranisition iteration
        initial_vapour_temp_K = N2O_Tank(16);
        initial_vapour_mass = N2O_Tank(17);
        initial_vapour_pressure_bar = N2O_Tank(18);
        initial_vapour_density = N2O_Tank(19);
        initial_Z = N2O_Tank(20);
    end
    
    % integrate mass flowrate using Addams second order integration formula 
    %Xn = X(n-1) + DT/2 * ((3 * Xdot(n-1) - Xdot(n-2)));
    mdot_tank_outflow = N2O_Flow_Rate(N2O_Tank, Comb_Chamber, N2O_Valve);                                    
    %delta_outflow_mass = 0.5 * dt * ...
    %    (3.0 * mdot_tank_outflow - mdot_tank_outflow_old);
    % drain the tank based on flowrates only
    % update mass within tank for next iteration
    tank_propellant_contents_mass = ...
        tank_propellant_contents_mass - mdot_tank_outflow * dt;
    % drain off vapour
    % update vapour mass within tank for next iteration
    tank_vapour_mass = tank_vapour_mass - mdot_tank_outflow * dt; 
    % initial guess of current compressibility factor using the tank
    % pressure from the prior iteration
    current_Z_guess = ...
        LinearInterpolate(tank_pressure_bar, 0.0, 1.0, pCrit, ZCrit);
    %set current_Z to value to ensure at least one loop iteration occurs
    current_Z = 2*current_Z_guess; 
    step = 1.0 / 0.9; % initial step size
    
    OldAim = 2; 
    Aim = 0; % flags used below to home-in
    % recursive loop to get correct compressibility factor
    while (((current_Z_guess / current_Z) > 1.000001) || ...
        ((current_Z_guess / current_Z) < (1.0/ 1.000001)) );
      %develop a guess for the tank fluid properties using an isentropic 
      %assumption
        %exponent used in following equaion
        bob = gamma - 1.0;
        %isentropic relation
        tank_fluid_temperature_K = initial_vapour_temp_K * ...
            (((tank_vapour_mass * current_Z_guess)...
            /(initial_vapour_mass * initial_Z))^bob);
      %develop a guess for the tank pressure using the prior guess at 
      %vapour temperature, and isentropic assumption
        %exponent used in following equation
        bob = gamma / (gamma - 1.0);
        %isentropic relation
        tank_pressure_bar = initial_vapour_pressure_bar ...
            * ((tank_fluid_temperature_K /initial_vapour_temp_K)^bob);
        %use the guess of the tank pressure to guess the current iterations
        %guess of the compressibility factor (current_Z)
        current_Z = ...
            LinearInterpolate(tank_pressure_bar, 0.0, 1.0, pCrit, ZCrit);
        
        %Set OldAim to the value of Aim from the previous iteration
        OldAim = Aim;
        %Compare the guess of Z from the previous iteration to the guess of
        %Z from the current iteration
        if (current_Z_guess < current_Z)
            %increase the guess of Z slightly if it is smaller than what
            %the current iteration predicts
            current_Z_guess = current_Z_guess * step;
            Aim = 1;
        else
            %decrease the guess of Z slightly if it is larger than what the
            %current iteration predicts
            current_Z_guess = current_Z_guess / step;
            Aim = -1;
            % check for overshoot of target, and if so, 
            %reduce step nearer to 1.0
            if (Aim == -OldAim)
                step = sqrt(step);
            end    
        end
    end
    bob = 1.0 / (gamma - 1.0);
    tank_vapour_density = initial_vapour_density ...
        *((tank_fluid_temperature_K / initial_vapour_temp_K)^bob);
    %Set Vapour Properties
    N2O_Tank(2) = tank_fluid_temperature_K;
    N2O_Tank(4) = tank_vapour_mass;
    N2O_Tank(6) = tank_vapour_mass_old;
    N2O_Tank(7) = tank_pressure_bar;
    N2O_Tank(13) = tank_volume;
    N2O_Tank(8) = tank_propellant_contents_mass;
    N2O_Tank(10) = tank_vapour_density;
    N2O_Tank(11) = mdot_tank_outflow;
    N2O_Tank(21) = mdot_tank_outflow_old;
    N2O_Tank(15) = first_vapour_it;
end