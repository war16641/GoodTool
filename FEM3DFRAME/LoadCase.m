classdef LoadCase<handle & matlab.mixin.Heterogeneous
    %UNTITLED �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        f FEM3DFRAME
        name char%������
        bc BC
        rst 
        
        dof%���ɶ��� δ����߽�����ǰ
        activeindex%��Ч���ɶ�����
        f_ext double%����������� ����߽�����ǰ ��bc��force��������
        f_ext1 double%ӳ��߽�����
        f_node double%�ڵ��� ��f_ext+df���
        f_node1 double
        f_ele%�ڵ��ܵ�Ԫ���� ȫ���ɶ�
        f_ele1
        u_beforesolve double%���ǰ��λ��������ȫ���ɶȵģ� ����λ�ƺ���
        u double %�����λ������ Ҳ����˵�� ��ǰ��λ�������������жಽ���صĹ����� ȫ���ɶ�
        u1 double %��Ч���ɶ�
        du
        du1
        ddu 
        ddu1
        K double%�ṹ�նȾ��� ����߽�����ǰ
        M double
        C double
        K1 double%����߽�����
        M1
        C1
        
        K_inelastic double%��ǰ�ṹ�ĵķ��߲��ֵĸն�
        K1_inelastic double
        
    end
    
    methods
        function obj = LoadCase(f,name)
            obj.f=f;
            obj.name=name;
            obj.bc=BC(obj);
            obj.rst=Result(obj);
           

        end
        
        function AddBC(obj,type,ln)%ln=ndid,dir,value         dir=1~6
            obj.bc.Add(type,ln);
        end
        function CloneBC(obj,lc)%��������������BC
            for it=1:lc.bc.displ.num
                ln=lc.bc.displ.Get('index',it);
                obj.AddBC('displ',ln);
                
                
            end
            for it=1:lc.bc.force.num
                ln=lc.bc.force.Get('index',it);
                obj.AddBC('force',ln);
            end
        end
        function PreSolve(obj)%ִ��solveǰ ÿ����������Ҫִ�еĴ���
            %�����ɶȸ��� �������ɶ�
            obj.dof=6*obj.f.node.ndnum;
            %�γɽڵ���նȾ����ӳ��
            obj.f.node.SetupMapping();
            %�γ����ԸնȾ���K
            obj.GetK();
            %�γ�M
            obj.GetM();
            %��ʼ��������
            for it=1:obj.f.manager_ele.num
                e=obj.f.manager_ele.Get('index',it);
                e.InitialState();
%                 e.InitialKT();
            end
            %���߽������Ƿ��ظ�
            obj.bc.Check();
            
            %���ݹ�������Ҫ����Լ���bc�����Ƿ������� checkbc��ÿ��������Ҫ��д�ĺ������麯����
            obj.CheckBC();
            %��ʼ��activeindex
            obj.activeindex=1:obj.dof;
            
            %����λ�Ʊ߽����
            df=zeros(obj.dof,1);%��ɾ��λ�ƺ������ɶȶ����ɵĶ���������
            displindex=[];%�洢����������ɶ� λ�����Ƶ����ɶ�
            obj.u_beforesolve=zeros(obj.dof,1);%��ʼ�����ǰλ��
            for it=1:obj.bc.displ.num
                ln=obj.bc.displ.Get('index',it);
                index=obj.f.node.GetXuhaoByID(ln(1))+ln(2)-1;%�õ����
                df=df-obj.K(:,index)*ln(3);
                obj.u_beforesolve(index)=ln(3);%����λ��
                displindex=[displindex index];
            end
            obj.u=obj.u_beforesolve;%����ǰλ����Ϊ���ǰλ��
            
            %����δ����Ԫ�������ɶ�
            hit=zeros(obj.dof,1);%���ɶȱ����д���
            for it=1:obj.f.manager_ele.num
                e=obj.f.manager_ele.Get('index',it);
                e.CalcHitbyele();
                for it1=1:length(e.nds)
                    xh=obj.f.node.GetXuhaoByID(e.nds(it1));
                    hit(xh:xh+5)=hit(xh:xh+5)+e.hitbyele(it1,:)';%hit��1
                end
            end
            %�ռ�δ����Ԫ��������ɶ�
            tmp=1:obj.dof;
            deadindex=tmp(hit==0);
            %���δ����Ԫ��������ɶ���Ϣ
            if ~isempty(deadindex)
                disp('����δ����Ԫ��������ɶ�')
            end
            for it=1:length(deadindex)
                [id,~,label]=obj.f.node.GetIdByXuhao(deadindex(it));
                disp(['�ڵ�' num2str(id) ' ' label]);
            end
            
            %λ�ƺ��ض�Ӧ�����ɶ���δ����Ԫ��������ɶ��Ƿ��ص� �����ɶ�ȱ�ٵĵ�Ԫ�ڱ߽紦ʱ ������������
            [~,ia,~]=unique([displindex deadindex]);
            if ia<length(displindex)+length(deadindex)
                warning('λ�ƺ��ض�Ӧ�����ɶ���δ����Ԫ��������ɶ��ص����������ɶ�ȱ�ٵĵ�Ԫ�ڱ߽紦ʱ�����������������������ģ��������쳣�ġ�')
            end
            
            %ɾ����������δ��������ɶ�
            obj.activeindex([displindex deadindex])=[];
            
            
            
            
            %�������߽����� ����f_ext
            index_force=[];%������ ���е����ɶ����
            obj.f_ext=zeros(obj.dof,1);
            for it=1:obj.bc.force.num
                ln=obj.bc.force.Get('index',it);
                index=obj.f.node.GetXuhaoByID(ln(1))+ln(2)-1;
                obj.f_ext(index)=obj.f_ext(index)+ln(3);
                index_force=[index_force index];
            end
            %���� f_node
            obj.f_node=obj.f_ext+df;
            
            %������Ƿ������δ����Ԫ��������ɶ���
            [~,ia,~]=unique([index_force deadindex]);
            if length(index_force)+length(deadindex)>length(ia)
                error('matlab:myerror','��������δ����Ԫ��������ɶ���')
            end
            
            %����K1 f_node1
            obj.K1=obj.K(obj.activeindex,obj.activeindex);
            obj.M1=obj.M(obj.activeindex,obj.activeindex);
            obj.f_node1=obj.f_node(obj.activeindex);
            
            %��ʼ���ٶ� ���ٶ�
            obj.du=zeros(obj.dof,1);
            obj.du1=zeros(length(obj.activeindex),1);
            obj.ddu=zeros(obj.dof,1);
            obj.ddu1=zeros(length(obj.activeindex),1);
        end
        function SetState(obj,varargin)%���ýṹ״̬ ��Ч���ɶ�
            %v 
            %v dv ddv 
            switch length(varargin)
                case 1%ֻ��λ��
                    v=varargin{1};
                    dv=zeros(length(obj.dof),1);
                    ddv=dv;
                case 3%��λ�� �ٶȼ��ٶ�
                    v=varargin{1};
                    dv=varargin{2};
                    ddv=varargin{3};
                otherwise
                    error('sd')
                    
            end
            
            %�����Լ�lc�Ľڵ�״̬
            obj.u1=v;
            obj.du1=dv;
            obj.ddu1=ddv;
            obj.u(obj.activeindex)=v;
            obj.du(obj.activeindex)=dv;
            obj.ddu(obj.activeindex)=ddv;
            
            %���µ�Ԫ״̬��lc��f_ele
            obj.f_ele=zeros(obj.dof,1);
            for it=1:obj.f.manager_ele.num
                e=obj.f.manager_ele.Get('index',it);
                e.SetState(obj);
                obj.f_ele=e.FormVector(obj.f_ele,e.Fs_elastic+e.Fsel);%��װ�ڵ�Ե�Ԫ����
            end
            obj.f_ele1=obj.f_ele(obj.activeindex);
            
        end
        function SetState_VelAcc(obj,dv,ddv)%����ṹ���ٶ� ���ٶ�
            %���������ͻأ ��Ҫ�����Ĳ�ַ���λ������������� û�취 �ٶȺͼ��ٶ�ֻ�ܲ�
            
            %�����Լ�lc�Ľڵ�״̬
            obj.du1=dv;
            obj.ddu1=ddv;
            obj.du(obj.activeindex)=dv;
            obj.ddu(obj.activeindex)=ddv;
            
            %���µ�Ԫ״̬ ��Ҫ�ǵ�Ԫ�Ķ���
            for it=1:obj.f.manager_ele.num
                e=obj.f.manager_ele.Get('index',it);
                e.SetState_VelAcc(obj);
            end
            
            
        end
    end
    methods(Abstract)
        Solve(obj)
        GetK(obj)
        GetM(obj)
        CheckBC(obj)
    end
end

