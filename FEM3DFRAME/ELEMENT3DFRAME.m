classdef ELEMENT3DFRAME <handle & matlab.mixin.Heterogeneous
    %3d���ģ�͵ĳ������
    
    properties
        f FEM3DFRAME%ģ��ָ��        
        id double%��Ԫ���
        nds%�洢����Ԫ�еĽڵ�� 
        ndcoor%�洢�ڵ�����
        Kel double%���վ��� ����������
        Kel_ double%���վ��� �ֲ�������
        Mel double%��Ԫ��������
        Mel_ double
        KTel%�����Խṹ�նȾ���
        KTel_
        Fsel%�����ԵĻظ���
        Fsel_
        Fs_elastic%���Իظ���
        Fs_elastic_
        C66 double %����ת������ ��Ե����ڵ��
        hitbyele double%���ɶ��Ƿ񱻵�Ԫ����  ��Щ��Ԫ�����ɶȲ�δ���� ����ܵ�Ԫ �и˶�����ͷŵ�����Ԫ ��ʽΪ�ڵ����*6
        flag_nl%��ʶ�����Ԫ�Ƿ��Ƿ�����Ĭ �������Ե�0
        arg%�����м���
        
        state%��Ԫ״̬ ������ �ڵ��� ������ ��loadcase��setstate���� �����ں���
    end
    
    methods
        function obj = ELEMENT3DFRAME(f,id,nds)
            %���idΪ0 ʹ�������+1
            if 0==id
                id=f.manager_ele.maxnum+1;
            end
            
            %���nds���Ƿ����нڵ����
            for it=nds
                if false==f.node.IsExist(it)
                    error('MATLAB:myerror','�ڵ㲻����');
                end
            end
            
            
            obj.f=f;
            obj.id=id;
            obj.nds=nds;
            obj.ndcoor=[];%�ڿ�ʼ���㵥Ԫ�ն�ʱ��������
            obj.flag_nl=0;%Ĭ�������Ե�
            tmp=length(nds);
            obj.KTel=zeros(6*tmp,6*tmp);
            obj.Fsel=zeros(6*tmp,1);
            %��ʼ����Ч���ɶȾ���
            obj.hitbyele=zeros(length(obj.nds),6);
            obj.Mel=zeros(6*length(nds),6*length(nds));%Ĭ����������Ϊ��
            %��ʼ����Ԫ״̬
            obj.state.deform_=zeros(1,6);%�ֲ��������
            obj.state.force_=zeros(length(obj.nds)*6,1);%�ڵ�Ե�Ԫ���� �ֲ�����
            obj.state.eng=[0 0 0];%���� ���� �ͻغ���
            
            obj.Fs_elastic=zeros(length(obj.nds)*6,1);
            obj.Fs_elastic_=zeros(length(obj.nds)*6,1);

        end
        function set.flag_nl(obj,v)
            obj.flag_nl=v;
            if v==1
            obj.f.flag_nl=v;
            end
        end
        function mat_tar=FormMatrix(obj,mat_tar,mat)%����Ԫ��ĳĳ����mat����mat_tar
            n=length(obj.nds);
            for it1=1:n
                for it2=1:n
                    x=obj.nds(it1);
                    y=obj.nds(it2);
                    xuhao1=obj.f.node.GetXuhaoByID(x);%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
                    xuhao2=obj.f.node.GetXuhaoByID(y);
                    mat_tar(xuhao1:xuhao1+5,xuhao2:xuhao2+5)=mat_tar(xuhao1:xuhao1+5,xuhao2:xuhao2+5)+mat(6*it1-5:6*it1,6*it2-5:6*it2);
                end
            end
        end
        function vec_tar=FormVector(obj,vec_tar,vec)
            n=length(obj.nds);
            for it=1:n
                xh=obj.f.node.GetXuhaoByID(obj.nds(it));%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
                vec_tar(xh:xh+5)=vec_tar(xh:xh+5)+vec(6*it-5:6*it);
            end
        end
        function vec_i=GetMyVec(obj,vec,lc)%������������л�ȡ�Լ�������
            %vec�Ǽ���߽��������
            
            %����vec������߽�����ǰ
            v=zeros(lc.dof,1);
            v(lc.activeindex)=vec;
            n=length(obj.nds);
            vec_i=zeros(n*6,1);
            for it=1:n
                ndid=obj.nds(it);
                xh=obj.f.node.GetXuhaoByID(ndid);%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
                vec_i(6*it-5:6*it)=v(xh:xh+5);
            end
        end
        function [v,dv,ddv]=GetMyNodeState(obj,lc)%��lc�Ľڵ�״̬�л�ȡ��Ԫ�Ľڵ�λ�� �ٶ� ���ٶ����� ��������
            v=zeros(6*length(obj.nds),1);
            dv=v;
            ddv=v;
            for it=1:length(obj.nds)
                ndid=obj.nds(it);
                xh=obj.f.node.GetXuhaoByID(ndid);%�õ� �ڵ�Ŷ�Ӧ�ڸնȾ�������
                v(6*it-5:6*it)=lc.u(xh:xh+5);
                dv(6*it-5:6*it)=lc.du(xh:xh+5);
                ddv(6*it-5:6*it)=lc.ddu(xh:xh+5);
            end
        end
        function CalcHitbyele(obj)%�������ɶ��Ƿ񱻵�Ԫ����
            %���ڼ����˵��ԸնȾ���Kel��KTel������������
            %���⣺���kelû��ĳ�����ɶȵĸնȣ���ktel�ڿ�ʼʱҲû�նȵ��Ǻ��������ն�
            %���ܻᵼ�³����ڿ�ʼ�׶�ֱ����Ϊ�����ɶ�Ϊdead
            
            
            %������Ч���ɶ� Kel
            dg=diag(obj.Kel);
            for it=1:length(obj.nds)
                tmp=dg(6*it-5:6*it);
                tmp=abs(tmp)>1e-10;
                obj.hitbyele(it,tmp)=1;
            end

            
            %KTel
            dg=diag(obj.KTel);
            for it=1:length(obj.nds)
                tmp=dg(6*it-5:6*it);
                tmp=abs(tmp)>1e-10;
                obj.hitbyele(it,tmp)=1;
            end
            
        end
        function SetState(obj,varargin)%���õ�Ԫ��״̬
            %lc
            
            varargin=Hull(varargin);
            lc=varargin{1};
            [v,dv,ddv]=obj.GetMyNodeState(lc);
            if length(obj.nds)==1%���ڵ㵥Ԫ
                obj.state.deform_=[0 0 0 0 0 0];%�ޱ���
                obj.state.force_=[0 0 0 0 0 0];%�޽ڵ�Ե�Ԫ����
                obj.state.eng([1 3])=0;
                obj.state.eng(2)=0.5*dv'*obj.Mel*dv;%�ж���
            elseif length(obj.nds)==2%���ڵ㵥Ԫ
                %�������
                ui=v(1:6);
                uj=v(7:12);%���ڵ�λ�� ��������
                deform_global=uj-ui;%��������ϵ�µı���
                cli=obj.C66^-1;
                C=[obj.C66 zeros(6,6);zeros(6,6) obj.C66 ];
                Cli=C^-1;
                tmp=deform_global'*cli;
%                 delta=obj.state.deform_-tmp;%���ε�����
                obj.state.deform_=tmp;%�ֲ������µı���
                
                %���㵯����
                tmp=obj.Kel*v;%���������µ���
                obj.Fs_elastic=tmp;
                tmp=tmp'*Cli;
                obj.Fs_elastic_=tmp';
                obj.state.force_=[tmp(1:6);tmp(7:12)];
                
                %��������
                obj.state.eng(1)=0.5*v'*obj.Kel*v;
                obj.state.eng(2)=0.5*dv'*obj.Mel*dv;%�ж���
                obj.state.eng(3)=0;
            else
                error('sd')
            end
        end
        function SetState_VelAcc(obj,lc)%��lc��SetState_VelAcc����
            [~,dv,~]=obj.GetMyNodeState(lc);
            if length(obj.nds)==1%���ڵ㵥Ԫ
                obj.state.eng([1 3])=0;
                obj.state.eng(2)=0.5*dv'*obj.Mel*dv;%�ж���
            elseif length(obj.nds)==2%���ڵ㵥Ԫ
                obj.state.eng(2)=0.5*dv'*obj.Mel*dv;%�ж���
                obj.state.eng(3)=0;
            else
                error('sd')
            end
        end
        function InitialState(obj)%��ʼ����Ԫ״̬ ������״̬Ҳ���ʼ��
            obj.state.deform_=zeros(1,6);%�ֲ��������
            obj.state.force_=zeros(length(obj.nds)*6,1);%�ڵ�Ե�Ԫ���� �ֲ�����
            obj.state.eng=[0 0 0];%���� ���� �ͻغ���
            obj.Fs_elastic=zeros(length(obj.nds)*6,1);
            obj.Fs_elastic_=zeros(length(obj.nds)*6,1);
            obj.Fsel=zeros(length(obj.nds)*6,1);
            obj.Fsel_=zeros(length(obj.nds)*6,1);
        end
    end
    methods(Abstract)
        Kel = GetKel(obj)%�γ��Լ��ĵ�Ԫ����
        Mel=GetMel(obj);%��װ��Ԫ������
        K=FormK(obj,K)%KΪ�ṹ�ĸնȾ��� ���Լ���Ԫ�ľ�������ṹ
        M=FormM(obj,M)
        InitialKT(obj)%��ʼ��KTel Fsel
        [force,deform]=GetEleResult(obj,varargin)%���ݽ�����㵥Ԫ�����ͱ��� force�ǵ�Ԫ�ڲ������ֲ�����ϵ��,�ڵ�Ե�Ԫ������ deform�ǵ�Ԫ���Σ��ֲ����꣩ 
        
    end
end

