classdef MATERIAL<handle
    %UNTITLED3 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        E%��ģ
        v%���ɱ�
        rou%�ܶ�
        name
        D
        G%����ģ��
    end
    
    methods
        function obj = MATERIAL(e,v,rou,n)


            obj.E=e;
            obj.v=v;
            obj.rou=rou;
            obj.name=n;
            obj.G=e/(1+v)/2;
            %���㵯�Ծ���
            obj.D=e/(1-v^2)*[1 v 0
                v  1 0
                0  0  (1-v)/2];
        end
        function disp(obj)%��д��ʾ����
            disp([sprintf('%10s','name') sprintf('%10s%10s%10s','E','v','rou')]);
            for it=1:length(obj)
                disp([sprintf('%10s',obj(it).name) sprintf('% 10.2e% 10.2e% 10.2e',obj(it).E,obj(it).v,obj(it).rou) ]);
            end            
        end
        
    end
end

