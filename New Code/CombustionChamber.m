classdef CombustionChamber
    %COMBUSTIONCHAMBER This class handles hybrid rocket combustion chambers.
   
    properties
        port_type='circular';
        n_ports
        grain_diameter
        grain_length
        combustion_pressure_t
        port_radius_t
    end
    
    properties(Dependent)
        port_cross_sectional_area
        port_surface_area
    end
    
    methods
        %setters to ensure proper type
        function obj=set.n_ports(obj,port_number)
            assert(strcmp(class(port_number),'double')==1 && mod(port_number,1)==0, 'The number of ports must be an integer')
            obj.n_ports=port_number;
        end
        function obj=set.port_radius_t(obj,rad)
            assert(strcmp(class(rad),'double')==1, 'The port radius must be a real number')
            obj.port_radius_t=rad;
        end
        function obj=set.grain_diameter(obj,d_grain)
            assert(strcmp(class(d_grain),'double')==1, 'The grain diameter must be input as a real number')
            obj.grain_diameter=d_grain;
        end
        function obj=set.grain_length(obj,l_grain)
            assert(strcmp(class(l_grain),'double')==1, 'The grain length must be input as a real number')
            obj.grain_length=l_grain;
        end
    end
    
end
