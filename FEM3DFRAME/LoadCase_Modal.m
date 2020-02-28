classdef LoadCase_Modal<LoadCase
    %���񹤿�
    
    properties
        arg cell%������:���� �����ʽ
        
        mode%���;���
        w%������Ϣ
        
        generalized_vars double%�������� ����ն� ÿһ�д���һ��
        modal_participating_mass_ratio double %������������� 3�� ����ux uy uz��ÿһ�д���ÿһ�� ��sap2000һ��
        modal_participation_factor double %���Ͳ������� 3�� ����ux uy uz��ÿһ�д���ÿһ�� ��sap2000һ�¡����ֵ��mode�йأ���mode�����������һ��ʱ����sap2000��ȫһ�¡�
        modal_participation_factor1 double %���Ͳ�������1 �������ɶȸ���*���͸��� ÿһ�д���һ�����ͣ�ÿһ�д���һ�����ɶ� ���ֵ������ֵ=�����ɶȵ����ͷֽ�ֵ
        
        
        R%����Ӱ�������� �μ����������� P72
        R1 %����Ӱ�������� ����߽�������

    end
    
    methods
        function obj = LoadCase_Modal(f,name)
            obj=obj@LoadCase(f,name);
            obj.rst=Result_Modal(obj);%����ԭ�н������ ��Ϊʹ��ģ̬ר�ý������
            obj.arg={[],'k'};
        end
        function Solve(obj)
            obj.PreSolve();
            %�����㷨�������ֵ
            [obj.w,obj.mode]=LoadCase_Modal.GetInfoForFreeVibration_eig(obj.K1,obj.M1,obj.arg{1},obj.arg{2});
            if isempty(obj.arg{1})
                obj.arg{1}=size(obj.K1,1);
            end
            %���������������ɶ��ϵ�����λ�� ������
            tic
            u1=obj.u_beforesolve;
            for it=1:length(obj.w)%��һ��ѭ���е㻨ʱ��
                w1=obj.w(it);
                mode1=obj.mode(:,it);
                obj.SetState(mode1);
%                 u1(obj.activeindex)=mode1;
%                 f1=obj.K*u1;
                obj.rst.Add(it,w1,[],[]);
            end
            toc

            
            
            %�������
            obj.generalized_vars=zeros(obj.arg{1},2);
            t=obj.mode'*obj.M1*obj.mode;
            obj.generalized_vars(:,1)=diag(t);
            t=obj.mode'*obj.K1*obj.mode;
            obj.generalized_vars(:,2)=diag(t);

            
            
            %���Ͳ���������
            [obj.R,obj.R1]=LoadCase_Earthquake.MakeR(obj);
            
            mat_t=obj.R1*[1 0 0]';%1���� ux
            mass_vec=obj.M1*mat_t;%ÿ�����ɶ��ϵ�����
            t1=obj.mode'*obj.M1*mat_t;
            mass_parti=repmat(t1,1,obj.arg{1})'.*repmat(mass_vec,1,obj.arg{1}) .*obj.mode;
            tt1=[sum(mass_parti)/sum(mass_vec)]';
            
            mat_t=obj.R1*[0 1 0]';%2���� uy
            mass_vec=obj.M1*mat_t;%ÿ�����ɶ��ϵ�����
            t1=obj.mode'*obj.M1*mat_t;
            mass_parti=repmat(t1,1,obj.arg{1})'.*repmat(mass_vec,1,obj.arg{1}) .*obj.mode;
            tt2=[sum(mass_parti)/sum(mass_vec)]';
            
            mat_t=obj.R1*[0 0 1]';%3���� uz
            mass_vec=obj.M1*mat_t;%ÿ�����ɶ��ϵ�����
            t1=obj.mode'*obj.M1*mat_t;
            mass_parti=repmat(t1,1,obj.arg{1})'.*repmat(mass_vec,1,obj.arg{1}) .*obj.mode;
            tt3=[sum(mass_parti)/sum(mass_vec)]';
            
            obj.modal_participating_mass_ratio=[tt1 tt2 tt3];
            
            
            %���Ͳ�������
            obj.modal_participation_factor=zeros(obj.arg{1},3);
            for i =1:obj.arg{1}
                obj.modal_participation_factor(i,:)=obj.mode(:,i)'*obj.M1*obj.R1*[1 0 0;0 1 0;0 0 1];
            end
            
            
            
            
            
            %���Ͳ�������1
            obj.modal_participation_factor1=zeros(length(obj.activeindex)  ,obj.arg{1});
            for i =1:obj.arg{1}
                t=obj.modal_participation_factor(i,:);
                t=[t 0 0 0]';%������ת��3��0
                t=repmat(t,obj.f.node.ndnum,1);
                obj.modal_participation_factor1(:,i)=obj.mode(:,i).*t(obj.activeindex);
            end
            
            
            
            
            
            
            
            
            
            
            
            %��ʼ�����ָ��
            obj.rst.SetPointer();
            
            
            
            
            


        end
        function GetK(obj)
            %K���ܸնȾ���(�߽���������ǰ) ����Ϊ6*�ڵ����
            obj.K=zeros(6*obj.f.node.ndnum,6*obj.f.node.ndnum);
            f=waitbar(0,'��װ�նȾ���','Name','FEM3DFRAME');
            for it=1:obj.f.manager_ele.num
                waitbar(it/obj.f.manager_ele.num,f,['��װ�նȾ���' num2str(it) '/' num2str(obj.f.manager_ele.num)]);
                e=obj.f.manager_ele.Get('index',it);
                obj.K=e.FormK(obj.K);
                
            end
            close(f);
        end
        function GetM(obj)%��װ�������󣨱߽���������֮ǰ) ����ȵ���GetM�γ�ӳ��
            %M������������(�߽���������ǰ) ����Ϊ6*�ڵ����
            obj.M=zeros(6*obj.f.node.ndnum,6*obj.f.node.ndnum);
            f=waitbar(0,'��װ��������','Name','FEM3DFRAME');
            for it=1:obj.f.manager_ele.num
                waitbar(it/obj.f.manager_ele.num,f,['��װ�նȾ���' num2str(it) '/' num2str(obj.f.manager_ele.num)]);
                e=obj.f.manager_ele.Get('index',it);
                obj.M=e.FormM(obj.M);
                
            end
            close(f);
        end
        function CheckBC(obj)
            %Ҫ��λ�Ʊ߽�����ȫ��0
            for it=1:obj.bc.displ.num
                ln=obj.bc.displ.Get('index',it);
                if ln(3)~=0
                    error('matlab:myerror','���񹤿����ܳ���λ�Ʋ�Ϊ0�ı߽�����')
                end
            end
        end
        function r=PredictWithResponseSpectrum(obj,nd_id,dir,xi,ew)%ʹ�÷�Ӧ��Ԥ��λ����Ӧ
            %�������͵���ֵ���Ե��� ����Ԫ�������srss cmc�ĵ��ӷ������˴�ûʵ�֡�
            index1=obj.GetIndex1InM1(nd_id,dir);
            t=obj.modal_participation_factor1(index1,:);%��ȡ���н׵�index1ֵ
            Ts=2*pi./obj.w;%����
            [sds,~]=ew.ResponseSpectra_Tn(Ts,'sd',xi,0);%��ֵ
            r=t*sds;
        end
    end
    methods(Static)
        function [w,mode]=GetInfoForFreeVibration_eig(k,m,nummode,fmt)
            %���ù�������ֵ KV=BVD���������Ϣ
            %nummode ��ѡ ǰ����Ƶ�ʺ�����
            if nargin==2
                nummode=size(k,1);
                fmt='m';%Ĭ�ϰ��������һ��
            elseif nargin==3
                fmt='m';
            elseif nargin==4
                if isempty(nummode)
                    nummode=size(k,1);
                end
            else
                error('δ֪����')
            end
            if length(k)==1%�����ɶ�
                [mode,D]=eigs(m^-1*k,nummode,'sm');%���Ƶ�ʰ���С��������
            else%�����ɶ�
                [mode,D]=eigs(k,m,nummode,'sm');%���Ƶ�ʰ���С��������
            end
            
            w=sqrt(diag(D));
            %�������
            switch fmt
                case 'm'
                    for it=1:nummode
                        mn=mode(:,it)'*m*mode(:,it);
                        mode(:,it)=mode(:,it)/sqrt(mn);
                    end
                case 'k'%����������Ϊ1���
                    for it=1:nummode
                        mn=0.5*mode(:,it)'*k*mode(:,it);
                        mode(:,it)=mode(:,it)/sqrt(mn);
                    end
                otherwise
                    error('sd')
            end

        end
    end
end

