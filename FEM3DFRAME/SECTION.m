classdef SECTION<handle
    %UNTITLED12 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        name
        mat MATERIAL
        A
        Iy 
        Iz
        J
    end
    
    methods
        function obj = SECTION(varargin)
            %name
            %mat
            %A
            %Iy
            %Iz
            %J ��ѡ
            if length(varargin)==5
                obj.name=varargin{1};
                obj.mat=varargin{2};
                obj.A=varargin{3};
                obj.Iy=varargin{4};
                obj.Iz=varargin{5};
                obj.J=obj.Iy+obj.Iz;%û��ָ��Ťת����ʱ ʹ�� ����߾�ĺ�
            elseif length(varargin)==6
                obj.name=varargin{1};
                obj.mat=varargin{2};
                obj.A=varargin{3};
                obj.Iy=varargin{4};
                obj.Iz=varargin{5};
                obj.J=varargin{6};
            else
                error('δ֪�Ĺ������')
            end
        end
        function disp(obj)
            disp([sprintf('%10s','name') sprintf('%10s','mat_name') sprintf('%10s%10s%10s','A','Iy','Iz')]);
            for it=1:length(obj)
                disp([sprintf('%10s',obj(it).name) sprintf('%10s',obj(it).mat.name) sprintf('% 10.2e% 10.2e% 10.2e',obj(it).A,obj(it).Iy,obj(it).Iz)]);
            end
            
        end
%         function obj = SECTION(A,Iy,Iz,name)
%             
%             obj.A=A;
%             obj.Iy=Iy;
%             obj.Iz=Iz;
%             obj.name=name;
%       
%         end

    end
end

