classdef EarthquakeInput<handle
    %���𲨵�����
    
    properties
        lc
        name
        ew%����
        scale%�Ŵ�ϵ��
        theta%��������Ƕ� ��z�� ��xΪ0��
        
        tn%1*n
        accn%3*n һ�д���ĳʱ�̵���������ļ��ٶ�
    end
    
    methods
        function obj = EarthquakeInput(lc,name,ew,scale,theta)%��δ֧����������
            obj.lc=lc;
            obj.name=name;
            obj.ew=ew;
            obj.theta=theta;
            obj.scale=scale;
            obj.MakeData();
        end
        
        function MakeData(obj)%����tn accn 
            obj.ew.SwitchUnit();%ת����λ
            obj.tn=obj.ew.tn';
            obj.accn=zeros(3,obj.ew.numofpoint);
            obj.accn(1,:)=[obj.ew.accn*cos(obj.theta)]'*obj.scale;
            obj.accn(2,:)=[obj.ew.accn*sin(obj.theta)]'*obj.scale;
        end
    end
end

