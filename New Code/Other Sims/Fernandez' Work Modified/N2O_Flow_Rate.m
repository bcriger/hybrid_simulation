function mass_flowrate = N2O_Flow_Rate(N2O_Tank, Pe)
%determine if the valve or the injector is the limiting factor, assuming
%all pressure drop is due to that component

tank_P = N2O_Tank(7);
comb_P = Pe;

injector_flowrate = ...
    MMF_injector_model(N2O_Tank, comb_P);
%valve_flowrate = ...
%    valve_model(N2O_Tank, Comb_Chamber, N2O_Valve, tank_P, comb_P);

%upper_flowrate = min(injector_flowrate, valve_flowrate);

P_valve_high = tank_P;
P_valve_low = comb_P;
P_valve = (tank_P + comb_P)/2;
check_flowrate = 1;
safety = 0;

%while(check_flowrate > 0.001)&&(safety < 100)
    
%    valve_flowrate = ...
%        valve_model(N2O_Tank, Comb_Chamber, N2O_Valve, tank_P, P_valve);
%    if injector_flowrate > valve_flowrate
%        P_valve_high = P_valve;
%    else
%        P_valve_low = P_valve;
%    end
%    P_valve = (P_valve_low + P_valve_high)/2;
%    check_flowrate = abs(injector_flowrate-valve_flowrate)/valve_flowrate;
%    safety = safety + 1;  %stops a non-converging iteration
%end    
injector_flowrate = MMF_injector_model(N2O_Tank, comb_P);
mass_flowrate = injector_flowrate;
