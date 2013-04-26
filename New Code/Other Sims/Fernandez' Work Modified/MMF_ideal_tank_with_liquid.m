function N2O_Tank = MMF_ideal_tank_with_liquid(N2O_Tank, Pe, dt)
    %update last-times values, O = 'old'
    tank_volume                     = N2O_Tank(1);
    tank_fluid_temperature_K        = N2O_Tank(2);
    tank_liquid_mass                = N2O_Tank(3);
    tank_vapour_mass                = N2O_Tank(4);
    mdot_tank_mass_returned_previous = N2O_Tank(5);
    tank_vapourized_mass_old        = N2O_Tank(6);
    tank_pressure_bar               = N2O_Tank(7);
    tank_propellant_contents_mass   = N2O_Tank(8);
    mdot_tank_outflow               = N2O_Tank(11);
    n_lo                            = N2O_Tank(12);
    n_go                            = N2O_Tank(13);
    
    Pe = Pe*100000; %Combustion Chamber Pressure, Convert from Bar to Pa
    
    all_nox_prop = nox_prop;
    all_rocket_prop = Rocket_Prop();
    
    Tc = all_nox_prop(3);           % critical temperature of N2O [K]
    MW2 = all_nox_prop(6);          % molecular weight of N2O    
    R = all_nox_prop(7);            % ideal gas constant    
    Inj_Loss_Coeff = all_rocket_prop(11);
    m_T = all_rocket_prop(4);
    V = all_rocket_prop(1);
    % determine the total number of moles in the n2o tank
    n_tot = n_go + n_lo;
    To = tank_fluid_temperature_K;
    
    % Given functions of temperature:
        %molar specific volume of liquid N2O [m^3/kmol]
    Vhat_l = 1/(nox_Lrho(To, 'mol_m3'));
        %specific heat of N2O gas at constant volume [J/(kmol*K)]
    CVhat_g = nox_CpG(To, 'J_kmolK');
        %specific heat of N2O liquid at constant volume, approx. same as at
        %constant pressure [J/(kmol*K)] 
    CVhat_l = nox_CpL(To, 'J_kmolK');       
        % heat of vapourization of N2O [J/kmol]                                    
    delta_Hv = nox_enthV(To, 'J_kmol');  
        % vapour pressure of N2O [Pa]
    P_sat = nox_vp(To, 'Pa'); 
        % derivative of vapour pressure with respect to Temperature
    dP_sat = nox_vp(To, 'dPa_dT'); 
        % specific heat of tank, Aluminum [J/(kg*K)]
    Cp_T = (4.8 + 0.00322*To)*155.239;      
    % Simplified expression definitions for solution
    P = (n_go)*R*To/(V-n_lo*Vhat_l);                        %Ideal gas equation, solve for pressure
    a = m_T*Cp_T + n_go*CVhat_g + n_lo*CVhat_l;             %total enthalpy in system
    b = P*Vhat_l;                                           %Pressure * liquid Spec. Vol.
    e = -delta_Hv + R*To;                                   %enthalpy in the tank        
    f = -1*Inj_Loss_Coeff*sqrt(2/MW2)*sqrt((P-Pe)/Vhat_l);  %mass leaving tank this iteration
    j = -Vhat_l*P_sat;                                      %Vapour Pressure * liquid Spec. Vol.
    k = (V - n_lo*Vhat_l)*dP_sat;                           %(Total Vol. - liquid Vol.)*dP/dt
    m = R*To;                                               %R*To = (P*V)/n_tot
    q = R*n_go;                                             %R*n_go = (P*V)/To
    Z = (-f*(-j*a+(q-k)*b))/(a*(m+j) + (q-k)*(e-b));        %rate of evapouration
    W = (-Z*(m*a + (q-k)*e))/(-j*a + (q-k)*b);              %rate of liquid loss and evaporation
    % Derivative Functions
    dT = (b*W+e*Z)/a;
    dn_g = Z;
    dn_l = W;  
    %Foreard Difference Method
    To = To + dT*dt;
    
    n_go = n_go + dn_g*dt;
    n_lo = n_lo + dn_l*dt;
    
    %n_loss = n_tot - n_go - n_lo;
    n_loss_dot = -1*f;
    m_loss_dot = n_loss_dot*MW2;
    %update tank contents for next iteration
    N2O_Tank(2) = To;   %tank_fluid_temperature_K;
    N2O_Tank(3) = n_lo*MW2;
    N2O_Tank(4) = n_go*MW2;
%    N2O_Tank(5) = mdot_tank_outflow_returned;
%    N2O_Tank(6) = tank_vapourized_mass_old2;
    N2O_Tank(7) = P/100000;
    N2O_Tank(8) = tank_propellant_contents_mass;
%    N2O_Tank(9) = tank_liquid_density;
%    N2O_Tank(10) = tank_vapour_density;
    N2O_Tank(11) = m_loss_dot;
    N2O_Tank(12) = n_lo;
    N2O_Tank(13) = n_go;
    N2O_Tank(15) = 1;
end