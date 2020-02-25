classdef ELEMENT_SPRING<ELEMENT3DFRAME
    %���ɵ�Ԫ
    
    properties
        xdir
        ydir
        zdir double %3����λ�������� ��Ϊ������  x������ ��i��j  z���ڳ�ʼ����ָ�� y�����xz�Ƴ�(���ַ���)
        const double %�˵�Ԫ�ĳ��� 1*6 double �ն�
        dir_nl double%���������� ������ ���ɶȷ��򣨾ֲ����꣩
        prop_nl double%����������  ��ǰ�ն� ������ ����ն� ����λ��
        nlstate %��������״̬�ṹ��
%         dv_history_NR cell%ţ������ɭ���������в������м������
    end
    
    methods
        function obj = ELEMENT_SPRING(varargin)  
            %f     id      nds     const
            %f     id      nds     const    p
            obj=obj@ELEMENT3DFRAME(varargin{1},varargin{2},varargin{3});
            
            %ȡ��Ĭ�ϲ���
            if nargin==4
                obj.const=varargin{4};
                p=[];
            elseif nargin==5
                obj.const=varargin{4};
                p=varargin{5};
                
            else
                error('δ֪����')  
            end
            
            %��ʼ������
            ELEMENT_EULERBEAM.InitializeDir(obj,p);
        end
        
        function Kel = GetKel(obj)
%             %��ʼ����Ч���ɶȾ���'
%             obj.hitbyele=zeros(2,6);
            
            %���ɾֲ������µĵ���
            kx=obj.const(1);
            ky=obj.const(2);
            kz=obj.const(3);
            krx=obj.const(4);
            kry=obj.const(5);
            krz=obj.const(6);
            Kel_=[kx	0	0	0	0	0	-kx	0	0	0	0	0
                0	ky	0	0	0	0	0	-ky	0	0	0	0
                0	0	kz	0	0	0	0	0	-kz	0	0	0
                0	0	0	krx	0	0	0	0	0	-krx	0	0
                0	0	0	0	kry	0	0	0	0	0	-kry	0
                0	0	0	0	0	krz	0	0	0	0	0	-krz
                0	0	0	0	0	0	kx	0	0	0	0	0
                0	0	0	0	0	0	0	ky	0	0	0	0
                0	0	0	0	0	0	0	0	kz	0	0	0
                0	0	0	0	0	0	0	0	0	krx	0	0
                0	0	0	0	0	0	0	0	0	0	kry	0
                0	0	0	0	0	0	0	0	0	0	0	krz
                ];
            Kel_=MakeSymmetricMatrix(Kel_);%�Գ���
            obj.Kel_=Kel_;
            
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
%             obj.hitbyele(1,tmp)=1;
%             tmp=dg(7:12);
%             tmp=abs(tmp)>1e-10;
%             obj.hitbyele(2,tmp)=1;
            
        end
        function K=FormK(obj,K)
            obj.GetKel();%�ȼ��㵥�վ��� ��������
            K=obj.FormMatrix(K,obj.Kel);
            %��Kel��Ϊ6*6���Ӿ��������ܸ�K
%             n=length(obj.nds);
%             for it1=1:n
%                 for it2=1:n
%                     x=obj.nds(it1);
%                     y=obj.nds(it2);
%                     xuhao1=obj.f.node.GetXuhaoByID(x);%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
%                     xuhao2=obj.f.node.GetXuhaoByID(y);
%                     K(xuhao1:xuhao1+5,xuhao2:xuhao2+5)=K(xuhao1:xuhao1+5,xuhao2:xuhao2+5)+obj.Kel(6*it1-5:6*it1,6*it2-5:6*it2);
%                 end
%             end
        end

        function [force,deform,Eng]=GetEleResult(obj,varargin)
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
            %���Ϸ����ԵĲ���
            C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66];
            tmp=obj.Fsel'*C^-1;
            force=force+[tmp(1:6) ;tmp(7:12)];
            %����
            Eng=[0 0 0];%���ܶ��ܺ���
            delta=[ui'; uj'];
            Eng(1)=0.5*delta'*obj.Kel*delta;
        end
        function Mel=GetMel(obj)
            
        end
        function M=FormM(obj,M)
            %�˵�Ԫ������
        end
        function SetNLProperty(obj,dir,prop)%���÷���������
            %propֻ������ǰ���� ���ĸ����Զ��������
            if obj.flag_nl==0%δ���÷�����
                obj.flag_nl=1;
            end
            
            obj.dir_nl=[obj.dir_nl ;dir];
            prop=[prop prop(2)/prop(1)];
            obj.prop_nl=[obj.prop_nl;prop];
            obj.const(dir)=0;%��Ҫɾ�����������ɶȶ�Ӧ�����Ըն�
            %��ʼ��������״̬
            tmp.ela=0;
            tmp.dumax=prop(4);
            tmp.dumin=-prop(4);
            tmp.fs=0;
            tmp.kt=0;
            tmp.dv_NRhistory=[];
            obj.nlstate=[obj.nlstate;tmp];%���浽����
        end
        function [Fs,KT]=AddNRHistory(obj,varargin)
            %varargin�ǽڵ�λ������������
            %flag_fail Ϊ1 ʱ����nrʧ��
            %Fs�ǽڵ�Ե�Ԫ���� ֻ�������Բ���
            %Fs�ǵ�Ԫ��nr�����иն� ֻ�������Բ���
            ui=varargin{1}(1:6);
            uj=varargin{1}(7:12);%���ڵ�λ�� ��������
            deform_global=uj-ui;%��������ϵ�µı���
            cli=obj.C66^-1;
            deform=deform_global'*cli;%�ֲ����ε�����
            Fs=zeros(12,1);
            KT=zeros(12,12);
            flag_fail=0;
            for it=1:length(obj.dir_nl)
                dir=obj.dir_nl(it);
                dv=deform(dir);%��������
                
                %��鲻��������
                if isempty(obj.nlstate(it).dv_NRhistory)%��һ��nr����
                    if obj.nlstate(it).ela==1%��������
                        delta_f=obj.prop_nl(it,3)*dv;%������
                        if delta_f<-2*obj.prop_nl(it,4)*obj.prop_nl(it,3)&&delta_f>2*obj.prop_nl(it,4)*(obj.prop_nl(it,3)-obj.prop_nl(it,1))
                            error('nr���������������nr������������״̬�������л���������С����')
                        end
                    end
                    if obj.nlstate(it).ela==-1%��ѹ����
                        delta_f=obj.prop_nl(it,3)*dv;%������
                        if delta_f>2*obj.prop_nl(it,2)*obj.prop_nl(it,3)&&delta_f<-2*obj.prop_nl(it,4)*(obj.prop_nl(it,3)-obj.prop_nl(it,1))
                            error('nr���������������nr������������״̬�������л���������С����')
                        end
                    end
                end
                
                obj.nlstate(it).dv_NRhistory=[obj.nlstate(it).dv_NRhistory; [dv 0 0 0]];
                %����fs��kt
                k1=obj.prop_nl(it,1);
                k2=obj.prop_nl(it,3);
                dvhe=sum(obj.nlstate(it).dv_NRhistory(:,1));%����nr���̱��������ĺ�
                if dvhe>=obj.nlstate(it).dumax%������������
                    fs=obj.nlstate(it).fs+k1*obj.nlstate(it).dumax+k2*(dvhe-obj.nlstate(it).dumax);
                    kt=k2;
                    ela=1;
                elseif dvhe<=obj.nlstate(it).dumin%������������
                    fs=obj.nlstate(it).fs+k1*obj.nlstate(it).dumin+k2*(dvhe-obj.nlstate(it).dumin);
                    kt=k2;
                    ela=-1;
                else
                    fs=obj.nlstate(it).fs+dvhe*k1;
                    kt=k1;
                    ela=obj.nlstate(it).ela+dvhe/obj.prop_nl(it,4);
                end
                %����fs kt��nrhistory��
                obj.nlstate(it).dv_NRhistory(end,2)=fs;
                obj.nlstate(it).dv_NRhistory(end,3)=kt;
                obj.nlstate(it).dv_NRhistory(end,4)=ela;
                %������߾��� ֻ������ �ڵ���
                Fs(dir)=-fs;
                Fs(dir+6)=fs;
                KT(dir,dir)=kt;
                KT(dir+6,dir+6)=kt;
                KT(dir+6,dir)=-kt;
                KT(dir,dir+6)=-kt;
                %ת������������
                C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66 ];
                KT=C^-1*KT*C;
                Fs=Fs'*C;
                Fs=Fs';
            end
        end
        function FinishNR(obj)%����nr����
%             Fs=zeros(12,1);
%             KT=zeros(12,12);
            for it=1:length(obj.dir_nl)
%                 dir=obj.dir_nl(it);
                %���nrhistory��Ϣ
                obj.nlstate(it).dv_NRhistory=[];
%                 %��nr���������һ�����뵽nlstate��
%                 if ~isempty(obj.nlstate(it).dv_NRhistory)
%                     obj.nlstate(it).fs=obj.nlstate(it).dv_NRhistory(end,2);
%                     obj.nlstate(it).kt=obj.nlstate(it).dv_NRhistory(end,3);
%                     obj.nlstate(it).ela=obj.nlstate(it).dv_NRhistory(end,4);
%                     %���nrhistory��Ϣ
%                     obj.nlstate(it).dv_NRhistory=[];
%                 else%���nrhistoryΪ�� ˵�� ��һ���ĺ��غ���һ��һ�� ʲô�����ö�
%                 end
%                 
%                 obj.nlstate(it).dumax=(1-obj.nlstate(it).ela)*obj.prop_nl(it,4);
%                 obj.nlstate(it).dumin=(-1-obj.nlstate(it).ela)*obj.prop_nl(it,4);
%                 
%                 %������߾��� ֻ������ �ڵ���
%                 fs=obj.nlstate(it).fs;
%                 kt=obj.nlstate(it).kt;
%                 Fs(dir)=-fs;
%                 Fs(dir+6)=fs;
%                 KT(dir,dir)=kt;
%                 KT(dir+6,dir+6)=kt;
%                 KT(dir+6,dir)=-kt;
%                 KT(dir,dir+6)=-kt;
%                 %ת������������
%                 C=[obj.C66 zeros(6,6); zeros(6,6) obj.C66];
%                 KT=C^-1*KT*C;
%                 Fs=Fs'*C;
%                 Fs=Fs';
            end
            %д��KTel Fsel
%             obj.Fsel=Fs;
%             obj.KTel=KT;
        end
        function [KTel,Fsel]=GetKT(obj)%��������Բ��ֵĵĸնȾ���
            KTel=obj.KTel;
            Fsel=obj.Fsel;
%             kt=zeros(12,12);
%             for it=1:length(obj.dir_nl)
%                 dir=obj.dir_nl(it);%���ɶ�
%                 if obj.nlstate(it).ela==-1 || obj.nlstate(it).ela==1%����
%                     k=obj.prop_nl(it,3);%����ն�
%                 else
%                     k=obj.prop_nl(it,1);%��ǰ�ն�
%                 end
%                 
%                 kt(dir,dir)=k;
%                 kt(dir+6,dir+6)=k;
%                 kt(dir,dir+6)=-k;
%                 kt(dir,dit+6)=-k;
%             end
%             %����ת��
%             C=[obj.C66 zeros(6,6);obj.C66 zeros(6,6)];
%             KT=C^-1*kt*C;
        end
        function InitialKT(obj)%��ʼ��KTel Fsel nlstate
            sz=length(obj.nds)*6;
            obj.Fsel=zeros(sz,1);%��ʼ����fselΪ0
            kt=zeros(12,12);
            for it=1:length(obj.dir_nl)
                dir=obj.dir_nl(it);%���ɶ�
                k=obj.prop_nl(it,1);
                kt(dir,dir)=k;
                kt(dir+6,dir+6)=k;
                kt(dir,dir+6)=-k;
                kt(dir+6,dir)=-k;
                %��ʼ��nlstate
                obj.nlstate(it).ela=0;
                obj.nlstate(it).dumax=obj.prop_nl(it,4);
                obj.nlstate(it).dumin=-obj.prop_nl(it,4);
                obj.nlstate(it).fs=0;
                obj.nlstate(it).kt=obj.prop_nl(it,1);
                obj.nlstate(it).dv_NRhistory=[];
            end
            %����ת��
            C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66 ];
            obj.KTel=C^-1*kt*C;
            
            
        end
        function SetState(obj,varargin)%���µ�Ԫ״̬
            %lc
            
            lc=varargin{1};
            [v,dv,ddv]=obj.GetMyNodeState(lc);
            ui=v(1:6);
            uj=v(7:12);%���ڵ�λ�� ��������
            deform_global=uj-ui;%��������ϵ�µı���
            cli=obj.C66^-1;
            C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66 ];
            tmp=deform_global'*cli;
            delta=tmp-obj.state.deform_;%���ε�����
            SetState@ELEMENT3DFRAME(obj,varargin);%�ȼ��㵯�ԵĲ��� 
            
%             %�������
%             lc=varargin{1};
%             [v,dv,ddv]=obj.GetMyNodeState(lc);
%             ui=v(1:6);
%             uj=v(7:12);%���ڵ�λ�� ��������
%             deform_global=uj-ui;%��������ϵ�µı���
%             cli=obj.C66^-1;
%             C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66 ];
%             Cli=C^-1;
%             tmp=deform_global'*cli;
%             delta=tmp-obj.state.deform_;%���ε�����
%             obj.state.deform_=tmp;%�ֲ������µı���
%             
%             %���㵯����
%             tmp=obj.Kel*v;%���������µ���
%             obj.Fs_elastic=tmp;
%             tmp=tmp'*Cli;
%             fs_e=tmp';%�ֲ�������
            
            %������ߵ��ԵĻظ���

            Fs=zeros(12,1);
            KT=zeros(12,12);
            for it=1:length(obj.dir_nl)
                dir=obj.dir_nl(it);%���ɶȷ���
                delta_v=delta(dir);%������ɶȷ����ϱ��ε�����
                k1=obj.prop_nl(it,1);
                k2=obj.prop_nl(it,3);
                if delta_v>=obj.nlstate(it).dumax%������������
                    fs=obj.nlstate(it).fs+k1*obj.nlstate(it).dumax+k2*(delta_v-obj.nlstate(it).dumax);
                    kt=k2;
                    ela=1;
                elseif delta_v<=obj.nlstate(it).dumin%������������
                    fs=obj.nlstate(it).fs+k1*obj.nlstate(it).dumin+k2*(delta_v-obj.nlstate(it).dumin);
                    kt=k2;
                    ela=-1;
                else
                    fs=obj.nlstate(it).fs+delta_v*k1;
                    kt=k1;
                    ela=obj.nlstate(it).ela+delta_v/obj.prop_nl(it,4);
                end
                %������߾��� ֻ������ �ڵ���
                Fs(dir)=-fs;
                Fs(dir+6)=fs;
                KT(dir,dir)=kt;
                KT(dir+6,dir+6)=kt;
                KT(dir+6,dir)=-kt;
                KT(dir,dir+6)=-kt;
                %����nlstate
                obj.nlstate(it).ela=ela;
                obj.nlstate(it).dumax=(1-obj.nlstate(it).ela)*obj.prop_nl(it,4);
                obj.nlstate(it).dumin=(-1-obj.nlstate(it).ela)*obj.prop_nl(it,4);
                obj.nlstate(it).fs=fs;
                obj.nlstate(it).kt=kt;
            end
            %���� ���ߵ������͸ն�
            obj.KTel_=KT;
            obj.Fsel_=Fs;
            
            obj.KTel=C^-1*KT*C;
            tmp=Fs'*C;
            obj.Fsel=tmp';
            
            %�ϲ�������
            tmp=obj.Fs_elastic_+obj.Fsel_;
            obj.state.force_=[tmp(1:6)';tmp(7:12)'];
            
%             %��������
%             obj.state.eng(1)=0.5*v'*obj.Kel*v;
%             obj.state.eng(2)=0;
%             obj.state.eng(3)=0;
            
        end
        function InitialState(obj)
            InitialState@ELEMENT3DFRAME(obj);
            
            %�����Լ������ԵĲ��� �����ԸնȾ���
            obj.KTel=zeros(12,12); 
            for it=1:length(obj.dir_nl)
                dir=obj.dir_nl(it);%���ɶ�
                k=obj.prop_nl(it,1);
                obj.KTel(dir,dir)=k;
                obj.KTel(dir+6,dir+6)=k;
                obj.KTel(dir,dir+6)=-k;
                obj.KTel(dir+6,dir)=-k;
                %��ʼ��nlstate
                obj.nlstate(it).ela=0;
                obj.nlstate(it).dumax=obj.prop_nl(it,4);
                obj.nlstate(it).dumin=-obj.prop_nl(it,4);
                obj.nlstate(it).fs=0;
                obj.nlstate(it).kt=obj.prop_nl(it,1);
                obj.nlstate(it).dv_NRhistory=[];
            end
            %����ת��
            C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66 ];
            obj.KTel=C^-1*obj.KTel*C;
        end
    end
end

