classdef Injector
    %INJECTOR This class handles hybrid rocket injector characteristics.
   
    properties
        initial_pressure
        internal_volume
        initial_ox_density
        ullage
    end
    
    methods
        function obj=set.initial_pressure(obj,p_init)
            assert(strcmp(class(p_init),'double')==1, 'The initial pressure must be a real number')
            obj.initial_pressure=p_init;
        end
        function obj=set.internal_volume(obj,v_int)
            assert(strcmp(class(v_int),'double')==1, 'The internal volume must be a real number')
            obj.internal_volume=v_int;
        end
        function obj=set.initial_ox_density(obj,dens)
            assert(strcmp(class(dens),'double')==1, 'The initial ox density must be a real number')
            obj.initial_ox_density=dens;
        end
        function obj=set.ullage(obj,ull)
            assert(strcmp(class(ull),'double')==1, 'The ullage percentage must be a real number')
            obj.ullage=ull;
        end
    end
    
end
