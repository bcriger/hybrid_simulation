classdef Injector
    %INJECTOR This class handles hybrid rocket injector characteristics.
   
    properties
        num_holes
        hole_diameter
        length
    end
    
    methods
        function obj=set.num_holes(obj,holes)
            assert(strcmp(class(holes),'double')==1, 'The number of holes must be a real number')
            obj.num_holes=holes;
        end
        function obj=set.hole_diameter(obj,d)
            assert(strcmp(class(d),'double')==1, 'The hole diameter must be a real number')
            obj.hole_diameter=d;
        end
        function obj=set.length(obj,len)
            assert(strcmp(class(len),'double')==1, 'The injector length must be a real number')
            obj.length=len;
        end
    end
    
end
