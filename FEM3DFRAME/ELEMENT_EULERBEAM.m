classdef ELEMENT_EULERBEAM<ELEMENT3DFRAME
    %ŷ����
    
    properties
        sec SECTION%����
        xdir
        ydir
        zdir double %3����λ�������� ��Ϊ������  x������ ��i��j  z���ڳ�ʼ����ָ�� y�����xz�Ƴ�(���ַ���)
        endrelease char%�˶�����ͷ���Ϣ
    end
    
    methods
        function obj = ELEMENT_EULERBEAM(varargin)
            %f,id,nds,sec,p,endrelease
            %p����(��ѡĬ����0,0,1 ��0,1,0��x������0,0,1ʱ)
            %endrelease�˶�����ͷ���Ϣ ��Ϊ''���ͷ�
%                                          'i'�ͷ�i��
%                                          'j'
%                                          'ij'���ͷ�
            obj=obj@ELEMENT3DFRAME(varargin{1},varargin{2},varargin{3});
            
            %�������Ƿ����
%             if isempty(obj.f.manager_sec.GetByIdentifier(varargin{4}.name))%����ֻͨ����ʶ������ ���ԸĽ��ɸ��ݶ����Ƿ���ȫһ��
%                 error('MATLAB:myerror','û���������')
%             end
            %�������
            if ~obj.f.manager_sec.IsExist(varargin{4})
                error('MATLAB:myerror','û���������')
            end
            obj.sec=varargin{4};
            
            %����Ϊ���������ĳ�ʼ�� �Ƚ�Ϊָ���Ĳ�������Ĭ�ϲ���ȡ��
            if nargin==4%δָ��zdir��endrelease 
                p=[];
                endrelease='';
            elseif nargin==5%ָ��zdir��ƽ�棨��xdir��p���ɵ�ƽ�棩
                p=varargin{5};
                endrelease='';
            elseif nargin==6%ָ�����в���
                p=varargin{5};
                endrelease=varargin{6};              
            else
                error('δ֪����')  
            end
            
            %����ȡ�������в������г�ʼ��
            
            %����
            ELEMENT_EULERBEAM.InitializeDir(obj,p)
            
            %�˶��ͷ���Ϣ
            obj.endrelease=endrelease;

        end
        
        function Kel = GetKel(obj)

            
            %һ���ڵ�6���ɶ�
            E=obj.sec.mat.E;
            A=obj.sec.A;
            Iy=obj.sec.Iy;
            Iz=obj.sec.Iz;
            G=obj.sec.mat.G;
            J=obj.sec.J;
            L=obj.f.node.Distance(obj.nds(1),obj.nds(2));%��Ԫ����
            %�ֲ������µĵ���
            %   ux1    |   uy1    |    uz1   |    rx1   |    ry1   |   rz1    |   ux2    |   uy2    |    uz2   |    rx2   |    ry2   |   rz2    |
            Kel_=[   E*A/L      0         0             0          0        0          -E*A/L      0            0         0            0        0
                0      12*E*Iz/L^3    0           0          0     6*E*Iz/L^2     0      -12*E*Iz/L^3   0         0          0       6*E*Iz/L^2
                0         0      12*E*Iy/L^3     0      -6*E*Iy/L^2  0           0           0      -12*E*Iy/L^3  0        -6*E*Iy/L^2   0
                0         0           0      G*J/L         0           0         0            0         0          -G*J/L     0          0
                0         0           0          0        4*E*Iy/L    0          0           0          6*E*Iy/L^2   0      2*E*Iy/L      0
                0         0           0          0          0         4*E*Iz/L   0       -6*E*Iz/L^2   0         0             0       2*E*Iz/L
                0         0           0          0          0         0          E*A/L   0             0             0          0           0
                0         0           0          0          0         0          0        12*E*Iz/L^3    0         0          0        -6*E*Iz/L^2
                0         0           0          0          0         0          0           0          12*E*Iy/L^3   0    6*E*Iy/L^2       0
                0         0           0           0         0          0          0          0          0        G*J/L       0              0
                0         0           0          0          0         0           0          0          0           0      4*E*Iy/L       0
                0         0           0          0          0         0           0          0          0           0        0           4*E*Iz/L];
            Kel_=MakeSymmetricMatrix(Kel_);%�Գ���
            
            
            %���˶��ͷ���Ϣ�����նȾ��� %������
            %ע�⣺�����ڵ��ת�ǲ���ͬʱ�ͷ�
            switch char(obj.endrelease)
                case ''%���ͷ�
                    index_release=[];%�ͷŵ����ɶ�
                    index_reserve=1:12;
                    index_reserve(index_release)=[];%���������ɶ�
                case 'i'%�ͷ�i��
                    index_release=[4 5 6 ];%�ͷŵ����ɶ�
                    index_reserve=1:12;
                    index_reserve(index_release)=[];%���������ɶ�
                case 'j'%�ͷ�j��
                    index_release=[ 10 11 12];%�ͷŵ����ɶ�
                    index_reserve=1:12;
                    index_reserve(index_release)=[];%���������ɶ�
                case 'ij'
                    index_release=[4 5 6  11 12];%�ͷŵ����ɶ�
%                     index_release=[ 5 6  11 12];%�ͷŵ����ɶ�
                    index_reserve=1:12;
                    index_reserve(index_release)=[];%���������ɶ�                    
                otherwise
                    error('matlab:myerror','sd')
            end
            if ~isempty(index_release)%����Ҫ�ͷŵ����ɶ�
                %�������ۺ�ʣ�µĸնȾ���
                Kel_reserve=Kel_(index_reserve,index_reserve)-Kel_(index_reserve,index_release)*Kel_(index_release,index_release)^-1*Kel_(index_release,index_reserve);
                %����0Ԫ����12*12
                Kel_=zeros(12,12);
                Kel_(index_reserve,index_reserve)=Kel_reserve;
            end
            obj.Kel_=Kel_;%����ֲ����굥��
            
            
            
            
            %����Ӿֲ����굽���������ת������C 3*3
            xd=[1 0 0];yd=[0 1 0];zd=[0 0 1];%��������
            C=[dot(obj.xdir,xd)      dot(obj.xdir,yd)      dot(obj.xdir,zd)
               dot(obj.ydir,xd)      dot(obj.ydir,yd)      dot(obj.ydir,zd)
               dot(obj.zdir,xd)      dot(obj.zdir,yd)      dot(obj.zdir,zd)];
           C=[C zeros(3,3);zeros(3,3) C];
           obj.C66=C;%���浥�ڵ��ת������
           C=[C zeros(6,6);zeros(6,6) C];%���䵽12���ɶ�
           
           %�õ����������µĵ���
           Kel=C^-1*Kel_*C;
           obj.Kel=Kel;
           
%            %������Ч���ɶ�
%             dg=diag(Kel);
%             tmp=dg(1:6);
%             tmp=abs(tmp)>1e-10;
%             obj.hitbyele(1,tmp)=obj.hitbyele(1,tmp)+1;
%             tmp=dg(7:12);
%             tmp=abs(tmp)>1e-10;
%             obj.hitbyele(2,tmp)=obj.hitbyele(2,tmp)+1;
            
        end
        
        function K=FormK(obj,K)
            obj.GetKel();%�ȼ��㵥�վ��� ��������
            
            %��Kel��Ϊ6*6���Ӿ��������ܸ�K
            n=length(obj.nds);
            for it1=1:n
                for it2=1:n
                    x=obj.nds(it1);
                    y=obj.nds(it2);
                    xuhao1=obj.f.node.GetXuhaoByID(x);%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
                    xuhao2=obj.f.node.GetXuhaoByID(y);
                    K(xuhao1:xuhao1+5,xuhao2:xuhao2+5)=K(xuhao1:xuhao1+5,xuhao2:xuhao2+5)+obj.Kel(6*it1-5:6*it1,6*it2-5:6*it2);
                end
            end
        end
        function [force,deform,eng]=GetEleResult(obj,varargin)
            %���ݼ��������ڵ�λ�ƣ� ���㵥Ԫ�� ����
            %varargin ֻ���������ڵ�ij�ı���2*6 
            if length(varargin)~=1
                error('matlab:myerror','�����ʽ')
            end
            ui=varargin{1}(1,:);
            uj=varargin{1}(2,:);%���ڵ�λ�� ��������
            deform_global=uj-ui;%��������ϵ�µı���
            cli=obj.C66^-1;
            deform=deform_global*cli;
            ui_local=ui*cli;
            uj_local=uj*cli;%���ڵ�λ�� �ֲ�����
            tmp=obj.Kel_*[ui_local uj_local]';
            force=[tmp(1:6)';tmp(7:12)'];%ת��Ϊn*6��ʽ
            
            %����
            eng=[0 0 0];
        end
        function Mel=GetMel(obj)%��װ��������
            
            %����׼��
            rou=obj.sec.mat.rou;%�ܶ�
            L=obj.f.node.Distance(obj.nds(1),obj.nds(2));%��Ԫ����
            J=obj.sec.J;
            A=obj.sec.A;
            Mel_=A*[rou*L/3	0	0	0	0	0	rou*L/6	0	0	0	0	0
                0	156*rou*L/420	0	0	0	22*rou*L^2/420	0	54*rou*L/420	0	0	0	-13*rou*L^2/420
                0	0	156*rou*L/420	0	22*rou*L^2/420	0	0	0	54*rou*L/420	0	-13*rou*L^2/420	0
                0	0	0	rou*J*L/3	0	0	0	0	0	rou*J*L/6	0	0
                0	0	0	0	4*rou*L^3/420	0	0	0	13*rou*L^2/420	0	-3*rou*L^3/420	0
                0	0	0	0	0	4*rou*L^3/420	0	13*rou*L^2/420	0	0	0	-3*rou*L^3/420
                0	0	0	0	0	0	rou*L/3	0	0	0	0	0
                0	0	0	0	0	0	0	156*rou*L/420	0	0	0	-22*rou*L^2/420
                0	0	0	0	0	0	0	0	156*rou*L/420	0	-22*rou*L^2/420	0
                0	0	0	0	0	0	0	0	0	rou*J*L/3	0	0
                0	0	0	0	0	0	0	0	0	0	4*rou*L^3/420	0
                0	0	0	0	0	0	0	0	0	0	0	4*rou*L^3/420
                ];
            Mel_=MakeSymmetricMatrix(Mel_);%�Գ���
            obj.Mel_=Mel_;
            
            %ת������������ϵ
            C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66];
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
        function InitialKT(obj)%��ʼ��KTel Fsel
            sz=length(obj.nds)*6;
            obj.Fsel=zeros(sz,1);
            obj.KTel=zeros(sz,sz);
        end
        function SetState(obj,varargin)
            SetState@ELEMENT3DFRAME(obj,varargin);
        end
    end
    methods(Static)
        function InitializeDir(obj,p)%��ʼ��xdir ydir zdir�������� �˺���������ʱ�����з���ĵ�Ԫ���� ���ӵ�Ԫ��һ��Ĭ�ϵķ���
            if isempty(p)%��ָ��zdir��������p
                obj.xdir=obj.f.node.DirBy2Node(obj.nds(1),obj.nds(2));
                if isequal([0 0 1],obj.xdir)%x��Ϊ����
                    obj.ydir=[1 0 0];
                    obj.zdir=[0 1 0];%z��Ϊ�����Y��
                else%x��Ϊ����
                    %z��Ϊ����Z���x��ƽ����
                    x1=obj.xdir(1);y1=obj.xdir(2);z1=obj.xdir(3);
                    alpha=-z1*sqrt(1/(1-z1^2));
                    beta=sqrt(1/(1-z1^2));
                    obj.zdir=alpha*obj.xdir+beta*[0 0 1];
                    obj.ydir=cross(obj.zdir,obj.xdir);%��˵�y��
                end
            else
                obj.xdir=obj.f.node.DirBy2Node(obj.nds(1),obj.nds(2));
                p=VectorDirection(p,'row');%ת��Ϊ������
                p=p/norm(p);%��λ��
                dot1=dot(p,obj.xdir);
                beta=sqrt(1/(1-dot1^2));
                alpha=-dot1*beta;
                obj.zdir=alpha*obj.xdir+beta*p;
                obj.ydir=cross(obj.zdir,obj.xdir);%��˵�y��
            end
        end
        function InitializeDir2(obj,xdir,p)%��ʼ��xdir ydir zdir�������� ָ��xdir
            if isempty(p)%��ָ��zdir��������p
                obj.xdir=xdir/norm(xdir);
                if isequal([0 0 1],obj.xdir)%x��Ϊ����
                    obj.ydir=[1 0 0];
                    obj.zdir=[0 1 0];%z��Ϊ�����Y��
                else%x��Ϊ����
                    %z��Ϊ����Z���x��ƽ����
                    x1=obj.xdir(1);y1=obj.xdir(2);z1=obj.xdir(3);
                    alpha=-z1*sqrt(1/(1-z1^2));
                    beta=sqrt(1/(1-z1^2));
                    obj.zdir=alpha*obj.xdir+beta*[0 0 1];
                    obj.ydir=cross(obj.zdir,obj.xdir);%��˵�y��
                end
            else
                obj.xdir=xdir/norm(xdir);
                p=VectorDirection(p,'row');%ת��Ϊ������
                p=p/norm(p);%��λ��
                dot1=dot(p,obj.xdir);
                beta=sqrt(1/(1-dot1^2));
                alpha=-dot1*beta;
                obj.zdir=alpha*obj.xdir+beta*p;
                obj.ydir=cross(obj.zdir,obj.xdir);%��˵�y��
            end
        end
    end
end

