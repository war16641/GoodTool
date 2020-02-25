classdef Result_Modal<Result
    %Ϊmodal����׼������
    
    properties
        periodinfo %�洢������Ϣ ����Ƶ�� �ȵ�
    end
    
    methods
        function obj = Result_Modal(lc)
            obj=obj@Result(lc);
            obj.periodinfo=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
        end
        
        function Add(obj,order,w,vector_f,vectro_u)
            %���ĳ�����͵ļ����� 
            %ͨ��ԲƵ�� �� ��񻯵�����
            
            obj.periodinfo.Add(order,[2*pi/w w/2/pi w]);%���� ʱ��Ƶ�� ԲƵ��
            obj.AddByState(order,'time');
%             obj.AddTime(order,vector_f,vectro_u);

        end
        function SetPointer(obj,order)
            %frametype ��ȡ'time' 'nontime'
            if nargin==1%ûָ��frametype,framename
                order=1;%����Ĭ��ָ�� Ϊ ʱ��֡�ĵ�һ�� ��һ������
            end
            obj.pointer=obj.timeframe.Get('id',order);

        end

        function [order,pi]=GetPeriodInfo(obj)%���ص�ǰ�Ľ�����periodinfo��Ϣ
            order=obj.pointer.framename;
            pi=obj.periodinfo.Get('index',order);
        end
        function PrintPeriodInfo(obj)%��ӡperiodinfo��Ϣ
            fprintf('%10s%10s%10s%10s\n','����','����','Ƶ��','��Ƶ��');
            for it=1:obj.periodinfo.num
                pi=obj.periodinfo.Get('index',it);
                fprintf('%10.4f%10.4f%10.4f%10.4f\n',it,pi(1),pi(2),pi(3));
            end
        end
    end
end

