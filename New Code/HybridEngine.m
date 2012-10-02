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
            assert(class(noz)=='Nozzle', ...
                'The nozzle must be input as a Nozzle object, see Nozzle.m')
            obj.nozzle=noz;
        end
        function obj=set.oxidizer_tank(obj,ox_tank)
            assert(class(ox_tank)=='OxidizerTank', ...
                'The oxidizer tank must be input as an OxidizerTank object, see OxidizerTank.m')
            obj.oxidizer_tank=ox_tank;
        end
        function obj=set.combustion_chamber(obj,comb_cham)
            assert(class(comb_cham)=='CombustionChamber',...
                'The combustion chamber must be input as a CombustionChamber object, see CombustionChamber.m')
            obj.combustion_chamber=comb_cham;
        end
        function dynamic_properties=simulate(obj)
            dynamic_properties=obj;
        end
    end
    
end