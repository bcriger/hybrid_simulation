function bob = nox_on_press(P_Bar_abs, nox_prop)
% nitrous temperature based on pressure (bar)
    tCrit = nox_prop(tCrit);
    pCrit = nox_prop(pCrit);
    p = [1.0, 1.5, 2.5, 5.0];
    b = [-6.71893, 1.35966, -1.3779, -4.051];
    step = -1.0;
    tempK = (tCrit - 0.1) - step;
    pp_guess = pCrit;
    while(abs((pp_guess - P_Bar_abs)) > 0.01)
        while( ((pp_guess - P_Bar_abs) * sign(step)) < 0.0)
            tempK = tempK + step;
            Tr = tempK / tCrit;
            rab = 1.0 - Tr;
            shona = 0.0;
            for dd = 0:4
                shona = shona + b(dd) * rab^p(dd);
            end    
            pp_guess = pCrit * exp((shona / Tr));
        end
        step = step / (-2.0); 
    end
    bob = tempK;
end
    
            