classdef HybridEngine
    %HYBRIDENGINE This class is meant to encapsulate all the aspects of a
    %designed hybrid engine, and methods to calculate derived properties.
    %   Detailed explanation goes here
    
    properties
        nozzle
        oxidizer_tank
        combustion_chamber
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
    end
    
end
