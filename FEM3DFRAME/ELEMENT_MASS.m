classdef ELEMENT_MASS<ELEMENT3DFRAME
    %������Ԫ
    
    properties
        xdir
        ydir
        zdir double %3����λ�������� ��Ϊ������  x������ ��i��j  z���ڳ�ʼ����ָ�� y�����xz�Ƴ�(���ַ���)
        const double%����6*1
    end
    
    methods
        function obj = ELEMENT_MASS(varargin)
            %f     id      nds     const
            %f     id      nds     const    p
            
            %p���� 2*3 double ��һ����xdir �ڶ���������p
            obj=obj@ELEMENT3DFRAME(varargin{1},varargin{2},varargin{3});
            %ȡ��Ĭ�ϲ���
            if nargin==4
                obj.const=varargin{4};
                xdir=[1 0 0];
                p=[0 0 1];%������ָ������ ȡ��������
            elseif nargin==5
                obj.const=varargin{4};
                xdir=varargin{5}(1,:);
                p=varargin{5}(2,:);
            else
                error('δ֪����')  
            end
            
            %��ʼ������
            ELEMENT_EULERBEAM.InitializeDir2(obj,xdir,p);
            
        end
        
        function Kel = GetKel(obj)
            %������Ԫ�޸նȾ���
            obj.Kel_=zeros(6,6);
            obj.Kel=zeros(6,6);
            Kel=obj.Kel;
            %����Ӿֲ����굽���������ת������C 3*3
            xd=[1 0 0];yd=[0 1 0];zd=[0 0 1];%��������
            C=[dot(obj.xdir,xd)      dot(obj.xdir,yd)      dot(obj.xdir,zd)
               dot(obj.ydir,xd)      dot(obj.ydir,yd)      dot(obj.ydir,zd)
               dot(obj.zdir,xd)      dot(obj.zdir,yd)      dot(obj.zdir,zd)];
           C=[C zeros(3,3);zeros(3,3) C];
           obj.C66=C;%���浥�ڵ��ת������
           
%            %������Ч���ɶ�
%             obj.hitbyele=zeros(1,6);

        end
        function K=FormK(obj,K)
            obj.GetKel();
            %������Ԫ�޸նȾ���
        end
        function Mel=GetMel(obj)
            Mel_=diag([obj.const]);
            obj.Mel_=Mel_;
            
            %ת������������ϵ
            C=obj.C66;
            Mel=C^-1*Mel_*C;
            obj.Mel=Mel;
        end
        function M=FormM(obj,M)
            obj.GetMel();%�ȼ��㵥�վ��� ��������
            
            %��Kel��Ϊ6*6���Ӿ��������ܸ�K
            n=length(obj.nds);
            for it1=1:n
                for it2=1:n
                    x=obj.nds(it1);
                    y=obj.nds(it2);
                    xuhao1=obj.f.node.GetXuhaoByID(x);%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
                    xuhao2=obj.f.node.GetXuhaoByID(y);
                    M(xuhao1:xuhao1+5,xuhao2:xuhao2+5)=M(xuhao1:xuhao1+5,xuhao2:xuhao2+5)+obj.Mel(6*it1-5:6*it1,6*it2-5:6*it2);
                end
            end
        end
        function [force,deform,eng]=GetEleResult(obj,varargin)%���ݼ��������ڵ�λ�ƣ� ���㵥Ԫ�� ����
            varargin=Hull(varargin);
            force=zeros(1,6);
            deform=force;%�����ڵ�û�����ͱ��� 
            eng=[0 0 0];%���ܶ��ܺ���
            v=varargin{2};%Ѱ���ٶ�
            eng(2)=0.5*v*obj.Mel*v';
            
        end
        function InitialKT(obj)%��ʼ��KTel Fsel
            
            sz=length(obj.nds)*6;
            obj.Fsel=zeros(sz,1);
            obj.KTel=zeros(sz,sz);
            
        end
        function SetState(obj,varargin)
            SetState@ELEMENT3DFRAME(obj,varargin);
        end
    end
end

