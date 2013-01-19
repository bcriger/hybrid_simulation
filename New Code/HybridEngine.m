classdef HybridEngine
    %HYBRIDENGINE This class is meant to encapsulate all the aspects of a
    %designed hybrid engine, and methods to calculate derived properties.
    %   Detailed explanation goes here
    
    properties
        injector
        nozzle
        oxidizer_tank
        combustion_chamber
        regression_rate_a=0.0127; %Proportionality constant from HDP to 
                                  %produce regression rate in mm/s
        regression_rate_n=0.65;   %Exponent from HDP, for G_o in N/(m^2*s)
    end
    
    properties (Dependent)
        regression_rate_t
        chamber_pressure_t
    end
    
    methods
        function obj=set.nozzle(obj,noz)
            assert(strcmp(class(noz),'Nozzle')==1, ...
                'The nozzle must be input as a Nozzle object, see Nozzle.m')
            obj.nozzle=noz;
        end
        function obj=set.oxidizer_tank(obj,ox_tank)
            assert(strcmp(class(ox_tank),'OxidizerTank')==1, ...
                'The oxidizer tank must be input as an OxidizerTank object, see OxidizerTank.m')
            obj.oxidizer_tank=ox_tank;
        end
        function obj=set.combustion_chamber(obj,comb_cham)
            assert(strcmp(class(comb_cham),'CombustionChamber')==1,...
                'The combustion chamber must be input as a CombustionChamber object, see CombustionChamber.m')
            obj.combustion_chamber=comb_cham;
        end
        function dynamic_properties=simulate_burn(obj)
            dynamic_properties=obj;
        end
        function obj=set.regression_rate_a(obj,r_r_a)
            assert(strcmp(class(r_r_a),'double')==1,...
                'The "a" coefficient for the regression rate calculation must be a real number.')
            obj.regression_rate_a=r_r_a;
        end
        function obj=set.regression_rate_n(obj,r_r_n)
            assert(strcmp(class(r_r_n),'double')==1,...
                'The "n" coefficient for the regression rate calculation must be a real number.')
            obj.regression_rate_n=r_r_n;
        end
    end    
end
