classdef LoadCase_Modal<LoadCase
    %���񹤿�
    
    properties
        arg cell%������:���� �����ʽ
        
        mode%���;���
        w%������Ϣ
        

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

