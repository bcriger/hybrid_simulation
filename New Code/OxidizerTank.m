classdef OxidizerTank
    %OXIDIZERTANK This class handles hybrid rocket oxidizer tanks.
   
    properties
        internal_volume
        ullage = 0.01; %Default ullage
        fluid_temperature_t; %Degrees Kelvin, assuming gas and liquid are 
                             %at the same temperature.
        liquid_mass_t
        liquid_density_t
        vapour_mass_t
        vapour_density_t
        fluid_pressure_t % bar (atmospheres), assuming both components are
                         % at the same pressure.
        gas_phase_flag = 0;
    end
    
    methods
        function obj=set.internal_volume(obj,v_int)
            assert(strcmp(class(v_int),'double')==1,...
                'The internal volume must be a real number')
            obj.internal_volume=v_int;
        end
        function obj=set.ullage(obj,ull)
            assert(strcmp(class(ull),'double')==1,...
                'The ullage percentage must be a real number')
            assert(ull>0 && ull<1,...
                'ullage percentage must be between 0 and 1')
            obj.ullage=ull;
        end
        function obj=set.fluid_temperature_t(obj,tmptr)
            assert(strcmp(class(tmptr),'double')==1,...
                'The temperature must be a real number')
            assert(tmptr>243.15 && tmptr<309.6,...
                strcat('Tank temperature (',num2str(tmptr),...
            ') is outside the range of simulation validity,',...
                '243.15 K to 309.6 K'))
            obj.fluid_temperature_t=tmptr;
        end
        function obj=set.liquid_mass_t(obj,liq_mass)
            assert(strcmp(class(liq_mass),'double')==1,...
                'The liquid mass must be a real number')
            obj.liquid_mass_t=liq_mass;
        end
        function obj=set.liquid_density_t(obj,liq_dens)
            assert(strcmp(class(liq_dens),'double')==1,...
                'The liquid oxidizer density must be a real number')
            obj.liquid_density_t=liq_dens;
        end
        function obj=set.vapour_mass_t(obj,vap_mass)
            assert(strcmp(class(vap_mass),'double')==1,...
                'The vapour mass must be a real number')
            obj.vapour_mass_t=vap_mass;
        end
        function obj=set.vapour_density_t(obj,vap_dens)
            assert(strcmp(class(vap_dens),'double')==1,...
                'The vapour density must be a real number')
            obj.vapour_density_t=vap_dens;
        end
        function obj=set.fluid_pressure_t(obj,press)
            assert(strcmp(class(press),'double')==1,...
                'The pressure must be a real number')
            obj.fluid_pressure_t=press;
        end
        function obj=set.gas_phase_flag(obj,flag)
            assert((flag==0 || flag==1),...
                'The gas phase flag must be 0 or 1')
            obj.gas_phase_flag=flag;
        end
    end
end
