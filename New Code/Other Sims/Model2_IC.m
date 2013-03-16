%Margaret Mary Fernandez's Master's Thesis
%Non Ideal (Peng-Robinson), High Pressure Equilibrium Model
%Initial Conditions Calculation

function [P_eq,n2v_eq,n2l_eq,y2_eq] = Model2_IC(y2guess,n_He,n_T,T_sur,V)
R = 8314.3;         % universal gas constant [J/(kmol*K)]

G1 = 96.512;        % vapour pressure of N2O [Pa] coefficients
G2 = -4045;         % valid for Temp range [182.3 K - 309.57 K]
G3 = -12.277;
G4 = 2.886e-5;
G5 = 2;

Q1 = 2.781;         % liquid molar volume of N2O [m^3/kmol] coefficients
Q2 = 0.27244;
Q3 = 309.57;
Q4 = 0.2882;

Vhat_l = Q2^(1+(1-T_sur/Q3)^Q4)/Q1;     % liquid molar volume of N2O [m^3/kmol]
Psat = exp(G1 + G2/T_sur + G3*log(T_sur) + G4*T_sur^G5);
    % Ideal correlation of pure N2O vapour pressure [Pa]
n2vo = Psat*(V - Vhat_l*n_T)/(-Psat*Vhat_l + R*T_sur);
    % Guess initial N2O vapour [kmol] based on ideal correlation
presso = Psat/y2guess;
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

Y2(1,1) = y2guess;
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
        
        c2 = -(1-B2);
        c1 = (A2 - 3*B2^2 - 2*B2);
        c0 = -(A2*B2 - B2^2 - B2^3);
        
        ql = c1/3 - c2^2/9;
        rl = (c1*c2 - 3*c0)/6 - c2^3/27;
        qrl = ql^3 + rl^2;
        
        % loop for finding Z_21
        if qrl > 0                % Case 1: 1 real root
            rpqrl = rl + qrl^0.5;
            rmqrl = rl - qrl^0.5;
            if rpqrl>=0
                s1 = rpqrl^(1/3);
            else
                s1 = -(abs(rpqrl)^(1/3));
            end
            if rmqrl >= 0
                s2 = rmqrl^(1/3);
            else
                s2 = -(abs(rmqrl)^(1/3));
            end
            Z_2l = s1 + s2 - c2/3;
        elseif qrl ==0              % Case 2:  3 real roots, at least 2 equal
            if rl >= 0
                s1 = rl^(1/3);
                s2 = rl^(1/3);
            else
                s1 = -(abs(r1))^(1/3);
                s2 = -(abs(r1))^(1/3);
            end
            Z_2l_1 = s1 + s2 - c2/3;
            Z_2l_2 = -0.5*(s1 + s2) - c2/3;
            Z_2l = min([Z_2l_1 Z_2l_2]);
        else
            alpha = (abs(qrl))^0.5;
            if rl > 0
                th1 = atan(alpha/rl);
            else
                th1 = pi - atan(alpha/abs(rl));
            end
            th2 = atan2(alpha,rl);
            if abs(th1 - th2) < 1e-14
                th = th1;
            else
                disp('Liquid Thetas do not match');
                break;
                %pause;
            end
            rho = (rl^2 + alpha^2)^0.5;
            Z_2l_1 = 2*rho^(1/3)*cos(th/3) - c2/3;
            Z_2l_2 = -rho^(1/3)*cos(th/3) - c2/3 - sqrt(3)*rho^(1/3)*sin(th/3);
            Z_2l_3 = -rho^(1/3)*cos(th/3) - c2/3 + sqrt(3)*rho^(1/3)*sin(th/3);
            Z_2l = min([Z_2l_1 Z_2l_2 Z_2l_3]);
        end    
        % Gas - Mixture
        % Z_m^3 + d2*Z_m^2 + d1*Z_m + d0 = 0
        
        k12 = 0;                                    % binary interaction parameter (He/N2O mix)
        a21 = sqrt(a1*a2)*(1-k12);                  % Sandler p.423
        am = (1-y2)^2*a1 + 2*y2*(1-y2)*a21 + y2^2*a2;
        bm = (1-y2)*b1 + y2*b2;
        
        Am = P*am/(R*T_sur)^2;                      % Sandler p.425
        Bm = P*bm/(R*T_sur);
        A2l = P*a21/(R*T_sur)^2;
        
        d2 = -(1-Bm);
        d1 = (Am - 3*Bm^2 - 2*Bm);
        d0 = -(Am*Bm - Bm^2 - Bm^3);
        
        qm = d1/3 - d2^2/9;
        rm = (d1*d2 - 3*d0)/6 - d2^3/27;
        qrm = qm^3 + rm^2;
        
        % loop for finding Z_m
        if qrm > 0                                  % Case 1: 1 real root
            rpqrm = rm + qrm^0.5;
            rmqrm = rm - qrm^0.5;
            if rpqrm>=0
                s1m = rpqrm^(1/3);
            else
                s1m = -(abs(rpqrm)^(1/3));
            end
            if rmqrm>=0
                s2m = rmqrm^(1/3);
            else
                s2m = -(abs(rmqrm)^(1/3));
            end
            Z_m = s1m + s2m - d2/3;
        elseif qrm == 0                             % Case 2: 3 real roots, at least 2 equal
            if rm >= 0
                s1m = rm^(1/3);
                s2m = rm^(1/3);
            else
                s1m = -(abs(rm))^(1/3);
                s2m = -(abs(rm))^(1/3);
            end
            Z_m_1 = s1m + s2m - d2/3;
            Z_m_2 = -0.5*(s1m + s2m) - d2/3;
            Z_m = max([Z_m_1 Z_m_2]);
        else                                        % Case 3: 3 real, distinct roots
            alpham = (abs(qrm))^0.5;
            if rm > 0
                th1m = atan(alpham/rm);
            else
                th1m = pi - atan(alpham/abs(rm));
            end
            th2m = atan2(alpham,rm);            % double check angle with Matlab atan2 code
            if abs(th1m - th2m) < 1e-14
                thm = th1m;
            else
                disp('Mixture Thetas do not match');
                break;
                %pause;
            end
            rhom = (rm^2 + alpham^2)^0.5;
            Z_m_1 = 2*rhom^(1/3)*cos(thm/3) - d2/3;
            Z_m_2 = -rhom^(1/3)*cos(thm/3) - d2/3 - sqrt(3)*rhom^(1/3)*sin(thm/3);
            Z_m_3 = -rhom^(1/3)*cos(thm/3) - d2/3 + sqrt(3)*rhom^(1/3)*sin(thm/3);
            Z_m = max([Z_m_1 Z_m_2 Z_m_3]);
        end
        
        % Fugacity Coefficient Calculations
        % phi_2l: Sandler p.300
        % phi_2v: Sandler p.423
        phi_2l = exp((Z_2l-1) - log(Z_2l - B2) - (A2/(2*sqrt(2)*B2))*...
            log((Z_2l+(1+sqrt(2))*B2)/(Z_2l+(1-sqrt(2))*B2)));
        phi_2v = exp((B2/Bm)*(Z_m-1) - log(Z_m - Bm) - (Am/(2*sqrt(2)*Bm))*...
            ((2*((1-y2)*A2l+y2*A2)/Am) - B2/Bm)*...
            log((Z_m+(1+sqrt(2))*Bm)/(Z_m+(1-sqrt(2))*Bm)));
        
        % Initial Solution Guess Calculation
        f1(k,n) = (n_He + n_2v)*phi_2l - n_2v*phi_2v;
        f2(k,n) = (n_He + n_2v)*Z_m + (n_T - n_2v)*Z_2l - P*V/(R*T_sur);
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
    Y2(k+1,1) = n2v(k+1,1)/(n2v(k+1,1) + n_He);     % update y2
    
    % Check errors
    del = ((n2v(k+1,1) - n2v(k,1))^2 + (pbar(k+1,1) - pbar(k,1))^2)^0.5;
    delF = (F1^2 + F2^2)^0.5;
    error = max([del delF]);
    
    % convergence criterion
    if error < 1e-8
        break
    end
end
n_T
P_eq = press(k+1,1);
n2v_eq = n2v(k+1,1);
n2l_eq = n_T - n2v(k+1,1);
y2_eq = Y2(k+1,1);