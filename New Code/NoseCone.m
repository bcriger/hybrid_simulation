classdef NoseCone
%NOSECONE This class handles rocket nose cones.
    
    properties
        base_diameter
        main_length
        step_offset
        step_length
        nose_cone_type
        spherically_blunted=0
        skin_thickness
        type_parameter_list
    end
    
    methods
        
        function obj=set.base_diameter(obj,b_diam)
            assert(isfloat(b_diam)==1, 'base_diameter must be a float')
            obj.base_diameter=b_diam;
        end
        
        function obj=set.main_length(obj,main_l)
            assert(isfloat(main_l)==1, 'main_length must be a float')
            obj.main_length=main_l;
        end
        
        function obj=set.step_offset(obj,step_o)
            assert(isfloat(step_o)==1, 'step_offset must be a float')
            obj.step_offset=step_o;
        end
        
        function obj=set.step_length(obj,step_l)
            assert(isfloat(step_l)==1, 'step_length must be a float')
            obj.step_length=step_l;
        end
        
        function obj=set.nose_cone_type(obj,cone_type)
            type_list={'elliptical','conical','bi_conic','tangent_ogive'...
                'secant_ogive','haack','ld_haack'};
            assert(ischar(cone_type)==1, 'nose_cone_type must be a string')
            cone_type=lower(cone_type);
            assert(any(cellfun(@(x)strcmp(cone_type,x),type_list)),...
                strcat('nose_cone_type must be one of the following:\n',...
                sprintf('%s ',type_list{:})))
            if strcmp(cone_type,'ld_haack')
                
            end
            obj.nose_cone_type=cone_type;
        end
        
        function obj=set.spherically_blunted(obj,blunt_bool)
            %It remains to be seen whether Ben knows what he's doing.
            assert(blunt_bool==0||1, 'spherically_blunted must be 0 or 1.')
            assert(isempty(obj.nose_cone_type),...
                strcat('Since type_parameter_list depends on',...
                'spherically_blunted, set spherically_blunted before',...
                'setting the type.'))
            obj.spherically_blunted=blunt_bool;
        end
        
        function obj=set.skin_thickness(obj,skin_t)
            assert(isfloat(skin_t)==1, 'skin_thickness must be a float')
            obj.skin_thickness=skin_t;
        end
        
        function text_file=write_scad_to_file(nose_cone,text_file)
            if text_file.bytes~=0
                disp('This text file is non-empty. If you use it, it will')
                disp('be overwritten. If you wish to continue, press')
                disp(' Enter. If not, press ctrl-c to halt execution.')
                pause;
            end
            
        end
    end
    
end
