function Z = PR_Find_Z(x1, x2, type)
    c2 = -(1-x2);
    c1 = (x1 - 3*x2^2 - 2*x2);
    c0 = -(x1*x2 - x2^2 - x2^3);
       
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
        Z = s1 + s2 - c2/3;
    elseif qrl ==0              % Case 2:  3 real roots, at least 2 equal
        if rl >= 0
            s1 = rl^(1/3);
            s2 = rl^(1/3);
        else
            s1 = -(abs(r1))^(1/3);
            s2 = -(abs(r1))^(1/3);
        end
        Z_1 = s1 + s2 - c2/3;
        Z_2 = -0.5*(s1 + s2) - c2/3;
        if 1 == strcmp(type, 'l')
            Z = min([Z_1 Z_2]);
        elseif 1 == strcmp(type, 'm')
            Z = max([Z_1 Z_2]);
        end
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
            disp('error in PR_Find_Z');
        end
        rho = (rl^2 + alpha^2)^0.5;
        Z_1 = 2*rho^(1/3)*cos(th/3) - c2/3;
        Z_2 = -rho^(1/3)*cos(th/3) - c2/3 - sqrt(3)*rho^(1/3)*sin(th/3);
        Z_3 = -rho^(1/3)*cos(th/3) - c2/3 + sqrt(3)*rho^(1/3)*sin(th/3);
        if 1 == strcmp(type, 'l')
            Z = min([Z_1 Z_2 Z_3]);
        elseif 1 == strcmp(type, 'm')
            Z = max([Z_1 Z_2 Z_3]);
        end
    end    
end