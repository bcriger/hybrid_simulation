classdef Nozzle
    %NOZZLE This class handles rocket nozzles.
   
    properties
        throat_diameter
        expansion_ratio
    end
    
    methods
        function obj=set.throat_diameter(obj,d_throat)
            assert(class(d_throat)=='double', 'The throat diameter must be a real number')
            obj.throat_diameter=d_throat;
        end
        function obj=set.expansion_ratio(obj,ratio)
            assert(class(ratio)=='double', 'The nozzle expansion ratio must be a real number')
            obj.expansion_ratio=ratio;
        end
    end
    
end