classdef ModalDispl<handle
    %ģ̬����
    
    properties
        lc_m LoadCase_Modal%ģ̬����
        lc_e LoadCase_Earthquake %���𹤿�
        timeframe
        timeframe_dv
        timeframe_ddv%�������ǹ����� �ֲ���Ź��������λ�� �ٶ� ���ٶ� ÿһ�����ݵ����һ��ʱ�̵����н����Ĺ���λ��
    end
    
    methods
        function obj = ModalDispl(lc_m,lc_e)
            obj.lc_m=lc_m;
            obj.lc_e=lc_e;
            obj.timeframe=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.timeframe_dv=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.timeframe_ddv=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            %������֤���ߵ�activeindex�Ƿ�һ��
            if norm(lc_m.activeindex-lc_e.activeindex)~=0
                error('nyh:error','Ҫ��modal��������Ч���ɶȺͱ�����һ�£���һ�¿����Ǳ߽�������ͬ���µġ�')
            end
            %���modal�����Ƿ��øնȹ������
            if 'k'~=lc_m.arg{2}
                warning('nyh:error','Ҫ��modal������ʹ�øնȹ�����͡�')%����������Ǳ������������Ǹնȹ�񻯿��Է����ʹ��ģ̬�����ʾӦ���ܡ�
            end
                        %���ģ̬����
%             modeli=lc_m.mode^-1; %��ģ̬������ȫ��ʱ����仰�ᱨ��
            for timeindex=1:lc_e.rst.timeframe.num
                tf=lc_e.rst.timeframe.Get('index',timeindex);
                v=tf.Get('node','displ','all','all');
                v=v(lc_e.activeindex);%ȥ����Ч���ɶ�
                v=v';%ת��Ϊ������
                 Y=lc_m.mode\v;
%                 Y=modeli*v; %��ģ̬������ȫ��ʱ����仰�ᱨ��
                obj.timeframe.Add(tf.framename,Y);
                
                v=tf.Get('node','displ','all','all','vel');
                v=v(lc_e.activeindex);%ȥ����Ч���ɶ�
                v=v';%ת��Ϊ������
                Y=lc_m.mode\v;
                obj.timeframe_dv.Add(tf.framename,Y);
                
                v=tf.Get('node','displ','all','all','acc');
                v=v(lc_e.activeindex);%ȥ����Ч���ɶ�
                v=v';%ת��Ϊ������
                Y=lc_m.mode\v;
                obj.timeframe_ddv.Add(tf.framename,Y);
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
        
        function [r,tn]=GetTimeHistory(obj,t1,t2,type,modalnum)
            switch type
                case 'v'
                    tf=obj.timeframe;
                case 'dv'
                    tf=obj.timeframe_dv;
                case 'ddv'
                    tf=obj.timeframe_ddv;%������λ���ٶȼ��ٶ�
                otherwise
                    error('��������')
            end
            [ind1,index1]=obj.timeframe.FindId(t1);
            [ind2,index2]=obj.timeframe.FindId(t2);%������ʼ�ͽ���������
            if index1==0
                index1=1;
            end
            index1=max([ind1 index1]);
            index2=max([ind2 index2]);
            numline=index2-index1+1;%���֡����
            
            assert(modalnum<=obj.lc_m.arg{1},'���ͽ���������������������')
            
            r=zeros(numline,1);
            tn=zeros(numline,1);
            for it=index1:index2
                [tmp,id]=tf.Get('index',it);
                r1=tmp(modalnum);
                r(it)=r1;
                tn(it)=id;
            end
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

