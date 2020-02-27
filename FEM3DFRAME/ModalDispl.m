classdef ModalDispl<handle
    %ģ̬����
    
    properties
        lc_m LoadCase_Modal%ģ̬����
        lc_e LoadCase_Earthquake %���𹤿�
        timeframe
    end
    
    methods
        function obj = ModalDispl(lc_m,lc_e)
            obj.lc_m=lc_m;
            obj.lc_e=lc_e;
            obj.timeframe=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            %������֤���ߵ�activeindex�Ƿ�һ��
            if norm(lc_m.activeindex-lc_e.activeindex)~=0
                error('nyh:error','Ҫ��modal��������Ч���ɶȺͱ�����һ�£���һ�¿����Ǳ߽�������ͬ���µġ�')
            end
            %���modal�����Ƿ��øնȹ������
            if 'k'~=lc_m.arg{2}
                warning('nyh:error','Ҫ��modal������ʹ�øնȹ�����͡�')%����������Ǳ������������Ǹնȹ�񻯿��Է����ʹ��ģ̬�����ʾӦ���ܡ�
            end
                        %���ģ̬����
            modeli=lc_m.mode^-1;
            for timeindex=1:lc_e.rst.timeframe.num
                tf=lc_e.rst.timeframe.Get('index',timeindex);
                v=tf.Get('node','displ','all','all');
                v=v(lc_e.activeindex);%ȥ����Ч���ɶ�
                v=v';%ת��Ϊ������
                Y=modeli*v;
                obj.timeframe.Add(tf.framename,Y);
            end
            

            
        end
        
        function [maxY,YY,eng]=PlotData(obj,order)%��ͼ��ʾ
            %order ������ͼ�����Ľ���
            
            %maxY����ģ̬����
            %YYģ̬���� ʱ������*order double
            %eng    ʱ������*4 ���һ��Ϊ���ܺ�
            if nargin==1
                order=obj.lc_m.arg{1};%��ָ��ʱ ȡ�������ͽ���
            end
            YY=zeros(obj.timeframe.num,order);
            for timeindex=1:obj.timeframe.num
                tmp=obj.timeframe.Get('index',timeindex);
                YY(timeindex,1:order)=tmp(1:order);
            end
            le=obj.Number2Str(1:order);
            eng=YY.^2;%����
            tn=obj.timeframe.GetAllId();
            tn=cell2mat(tn);
            figure
            plot(tn,YY);
            xlabel('ʱ��/s');ylabel('ģ̬����');
            title(['ģ̬����' obj.lc_m.name ' ���𹤿�' obj.lc_e.name])
            legend(le);
            maxY=max(YY);
            figure
            plot(tn',eng);
            t=sum(eng,2);
            eng=[eng t];
            xlabel('ʱ��/s');ylabel('��������');
            title(['ģ̬����' obj.lc_m.name ' ���𹤿�' obj.lc_e.name])
            legend(le);
            set(gca,'yscale','log');%��Ϊ��������
        end
        
        function [u_comp,tn]=GetDispComp(obj,nd_id,dir)%�ֽ�ָ���ڵ��λ�� �����ͷֽ�
            %u_comp�� ʱ������*������ double 
            %dir 1 2 3 ����ux uy uz

            nd_xuhao1=obj.lc_m.GetIndex1InM1(nd_id,dir);
            u_comp=zeros(obj.timeframe.num,obj.lc_m.arg{1});
            for i=1:obj.timeframe.num
                u_comp(i,:)=obj.lc_m.mode(nd_xuhao1,:).*obj.timeframe.Get('index',i)';
            end
            tn=obj.lc_e.ei.ew.tn;
        end
    end
    methods(Static)
        function c=Number2Str(x)%���������������ַ���ϸ��
            c=cell(1,length(x));
            for it=1:length(x)
                c{it}=num2str(x(it));
            end
        end
    end
end

