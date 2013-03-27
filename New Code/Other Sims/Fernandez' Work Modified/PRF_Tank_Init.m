%Margaret Mary Fernandez's Master's Thesis
%Non Ideal (Peng-Robinson), High Pressure Equilibrium Model
%Initial Conditions Calculation

function N2O_Tank = PRF_Tank_Init()
all_nox_prop = nox_prop;
all_rocket_prop = Rocket_Prop();

MW2 =   all_nox_prop(6);        % Molecular mass in g/mol
R =     all_nox_prop(7);        % Universal Gas Constant

V =         all_rocket_prop(1);    % total tank volume [m^3]
Ti =        all_rocket_prop(2);    % initial temperature [K]
m_loaded =  all_rocket_prop(3);    % N2O mass initially loaded in tank [kg]

T_sur = Ti;
n_T = m_loaded/MW2;

Vhat_l = 1/nox_Lrho(T_sur, 'mol_m3');     
    % liquid molar volume of N2O [m^3/kmol]
Psat = nox_vp(T_sur, 'Pa');
    % Ideal correlation of pure N2O vapour pressure [Pa]
n2vo = Psat*(V - Vhat_l*n_T)/(-Psat*Vhat_l + R*T_sur);
    % Guess initial N2O vapour [kmol] based on ideal correlation
%presso = Psat/y2guess;
presso = Psat;
    %Guess initial pressure in tank [Pa] based on ideal assumption
    %(Raoults's Law)

% Step sizes for numerical derivative claculation    
deltan2v = 1e-8;                % small change in n2v [kmol]
deltaP = 1e-8;                  % small change in pressure P [Pa]
Pscale = 10^6;                  % scaling factor for Jacobian calculation

% Critical constants and acentric factors from Perry's Handbook
% Tc1 = 5.2;        % He critical temperature [K]
% Tc2 = 309.57;     % N2O critical temperature [K]
% Pc1 = 0.23e6;     % He critical pressure [Pa]
% Pc2 = 7.28e6;     % N2O critical pressure [Pa]
% w1 = -0.388;      % He acentric factor
% w2 = 0.143;       % N2O acentric factor
% Critical Constants and acentricd factors from Sandler's code
Tc1 = 5.19;
Tc2 = 309.6;
Pc1 = 0.227e6;
Pc2 = 7.24e6;
w1 = -0.365;
w2 = 0.165;

% Peng-Robinson parameters
kappa1 = 0.37464 + 1.54226*w1 - 0.26992*w1^2;   % Sandler p.250
kappa2 = 0.37464 + 1.54226*w2 - 0.26992*w2^2;   
alpo1 = (1 + kappa1*(1-sqrt(T_sur/Tc1)))^2;
alpo2 = (1 + kappa2*(1-sqrt(T_sur/Tc2)))^2;
a1 = 0.45724*R^2*Tc1^2*alpo1/Pc1;               % Sandler p.250
a2 = 0.45724*R^2*Tc2^2*alpo2/Pc2;
b1 = 0.0778*R*Tc1/Pc1;
b2 = 0.0778*R*Tc2/Pc2;

% Store values from each iteration
% kth row = iteration number
Y2 = zeros(100,1);          % blank matrix to store y2 values
n2v = zeros(100,1);         % blank matrix to store n_2v values
press = zeros(100,1);       % blank matrix to store P values
pbar = zeros(100,1);        % blank matirx to store Pbar values

Y2(1,1) = 1;
n2v(1,1) = n2vo;
press(1,1) = presso;
pbar(1,1) = presso/Pscale;

for k = 1:100       % iteration number
    for n = 1:5
        if n==1
            P = press(k,1);
            n_2v = n2v(k,1);
        elseif n==2
            P = press(k,1) + deltaP/2;
            n_2v = n2v(k,1);
        elseif n==3
            P = press(k,1) - deltaP/2;
            n_2v = n2v(k,1);
        elseif n==4
            P = press(k,1);
            n_2v = n2v(k,1) + deltan2v/2;
        else
            P = press(k,1);
            n_2v = n2v(k,1) - deltan2v/2;
        end
        
        y2 = Y2(k,1);
        
        % Liquid - Pure
        % Z_21^3 + c2*Z_21^2 + c1*Z_21 + c0 = 0

        A2 = P*a2/(R*T_sur)^2;      % Sandler p.251
        B2 = P*b2/(R*T_sur);
        
        Z_2l = PR_Find_Z(A2, B2, 'l');
        % Gas - Mixture
        % Z_m^3 + d2*Z_m^2 + d1*Z_m + d0 = 0
        k12 = 0;                                    % binary interaction parameter (He/N2O mix)
        a21 = sqrt(a1*a2)*(1-k12);                  % Sandler p.423
        am = (1-y2)^2*a1 + 2*y2*(1-y2)*a21 + y2^2*a2;
        bm = (1-y2)*b1 + y2*b2;
        
        Am = P*am/(R*T_sur)^2;                      % Sandler p.425
        Bm = P*bm/(R*T_sur);
        A2l = P*a21/(R*T_sur)^2;
        Z_m = PR_Find_Z(Am, Bm, 'm');
               
        % Fugacity Coefficient Calculations
        % phi_2l: Sandler p.300
        % phi_2v: Sandler p.423
        phi_2l = exp((Z_2l-1) - log(Z_2l - B2) - (A2/(2*sqrt(2)*B2))*...
            log((Z_2l+(1+sqrt(2))*B2)/(Z_2l+(1-sqrt(2))*B2)));
        phi_2v = exp((B2/Bm)*(Z_m-1) - log(Z_m - Bm) - (Am/(2*sqrt(2)*Bm))*...
            ((2*((1-y2)*A2l+y2*A2)/Am) - B2/Bm)*...
            log((Z_m+(1+sqrt(2))*Bm)/(Z_m+(1-sqrt(2))*Bm)));
        
        % Initial Solution Guess Calculation
        f1(k,n) = (n_2v)*phi_2l - n_2v*phi_2v;
        f2(k,n) = (n_2v)*Z_m + (n_T - n_2v)*Z_2l - P*V/(R*T_sur);
    end
    
    % for derivative calculations
    F1   = f1(k,1);                     % F1(n2v,P)
    F1pp = f1(k,2);                     % F1(n2v,P+deltaP/2)
    F1pm = f1(k,3);                     % F1(n2v,P-deltaP/2)
    F1np = f1(k,4);                     % F1(n2v+deltan2v/2,P)
    F1nm = f1(k,5);                     % F1(n2v-dentan2v/2,P)
    F2   = f2(k,1);                     % F2(n2v,P)
    F2pp = f2(k,2);                     % F2(n2v,P+deltaP/2)
    F2pm = f2(k,3);                     % F2(n2v,P-deltaP/2)
    F2np = f2(k,4);                     % F2(n2v+deltan2v/2,P)
    F2nm = f2(k,5);                     % F2(n2v-deltan2v/2,P)
    
    % Update guesses for n_2v andP
    Pbar = P/Pscale;
    dF1dn = (F1np - F1nm)/deltan2v;
    dF1dP = (F1pp - F1pm)/deltaP;
    dF1dPb = dF1dP*Pscale;
    dF2dn = (F2np - F2nm)/deltan2v;
    dF2dP = (F2pp - F2pm)/deltaP;
    dF2dPb = dF2dP*Pscale;
    
    JAC_inv = (1/(dF1dn*dF2dPb - dF1dPb*dF2dn))*[dF2dPb -dF1dPb; -dF2dn dF1dn];
    F = [F1 F2]';
    
    sol_old = [n_2v Pbar]';             % old guess
    sol_new = sol_old - JAC_inv*F;      % new guess
    n2v(k+1,1) = sol_new(1,1);
    pbar(k+1,1) = sol_new(2,1);
    press(k+1,1) = sol_new(2,1)*Pscale;
    Y2(k+1,1) = n2v(k+1,1)/(n2v(k+1,1));     % update y2
    
    % Check errors
    del = ((n2v(k+1,1) - n2v(k,1))^2 + (pbar(k+1,1) - pbar(k,1))^2)^0.5;
    delF = (F1^2 + F2^2)^0.5;
    error = max([del delF]);
    
    % convergence criterion
    if error < 1e-8
        break
    end
end
tank_pressure_bar = press(k+1,1)/100000;
n_go = n2v(k+1,1);
n_lo = n_T - n2v(k+1,1);
tank_volume = V;
tank_fluid_temperature_K = Ti;
tank_propellant_contents_mass = m_loaded;
N2O_Tank = [tank_volume, ...                    % Set by MMF
            tank_fluid_temperature_K, ...           % Set by MMF
            0,0,0,0, ...
            tank_pressure_bar, ...                  % Set by MMF in Bar, note:  MMF uses Pa!
            tank_propellant_contents_mass, ...      % Set by MMF
            0,0,0, ...                              % Not Used
            n_lo, ...                               % number of liquid n2o moles        
            n_go, ...                               % number of gaseous n2o moles    
            0,0,0,0,0,0,0,0];