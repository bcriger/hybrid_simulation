classdef OxidizerTank
    %OXIDIZERTANK This class handles hybrid rocket oxidizer tanks.
   
    properties
        initial_pressure
        internal_volume
        initial_ox_density
        ullage
    end
    
    methods
        function obj=set.initial_pressure(obj,p_init)
            assert(class(p_init)=='double', 'The initial pressure must be a real number')
            obj.initial_pressure=p_init;
        end
        function obj=set.internal_volume(obj,v_int)
            assert(class(v_int)=='double', 'The internal volume must be a real number')
            obj.internal_volume=v_int;
        end
        function obj=set.initial_ox_density(obj,dens)
            assert(class(dens)=='double', 'The initial ox density must be a real number')
            obj.initial_ox_density=dens;
        end
        function obj=set.ullage(obj,ull)
            assert(class(ull)=='double', 'The ullage percentage must be a real number')
            obj.ullage=ull;
        end
    end
    
end
