classdef LoadCase_Modal<LoadCase
    %自振工况
    
    properties
        arg cell%求解参数:阶数 规格化形式
        
        mode%阵型矩阵
        w%周期信息
        
        generalized_vars double%广义质量 广义刚度 每一行代表一阶
        modal_participating_mass_ratio double %振型质量参与比 3列 代表ux uy uz，每一行代表每一阶 与sap2000一致
        modal_participation_factor double %振型参与因子 3列 代表ux uy uz，每一行代表每一阶 与sap2000一致。这个值与mode有关，当mode按质量矩阵归一化时，与sap2000完全一致。
        modal_participation_factor1 double %振型参与因子1 激活自由度个数*振型个数 每一列代表一个振型，每一行代表一个自由度 这个值乘以谱值=该自由度的振型分解值
        
        
        R%质量影响列向量 参见《桥梁抗震》 P72
        R1 %质量影响列向量 引入边界条件后

    end
    
    methods
        function obj = LoadCase_Modal(f,name)
            obj=obj@LoadCase(f,name);
            obj.rst=Result_Modal(obj);%覆盖原有结果对象 改为使用模态专用结果对象
            obj.arg={[],'k'};
        end
        function Solve(obj)
            obj.PreSolve();
            %调用算法求解特征值
            [obj.w,obj.mode]=LoadCase_Modal.GetInfoForFreeVibration_eig(obj.K1,obj.M1,obj.arg{1},obj.arg{2});
            if isempty(obj.arg{1})
                obj.arg{1}=size(obj.K1,1);
            end
            %处理求解后所有自由度上的力和位移 保存结果
            tic
            u1=obj.u_beforesolve;
            for it=1:length(obj.w)%这一块循环有点花时间
                w1=obj.w(it);
                mode1=obj.mode(:,it);
                obj.SetState(mode1);
%                 u1(obj.activeindex)=mode1;
%                 f1=obj.K*u1;
                obj.rst.Add(it,w1,[],[]);
            end
            toc

            
            
            %广义变量
            obj.generalized_vars=zeros(obj.arg{1},2);
            t=obj.mode'*obj.M1*obj.mode;
            obj.generalized_vars(:,1)=diag(t);
            t=obj.mode'*obj.K1*obj.mode;
            obj.generalized_vars(:,2)=diag(t);

            
            
            %振型参与质量比
            [obj.R,obj.R1]=LoadCase_Earthquake.MakeR(obj);
            
            mat_t=obj.R1*[1 0 0]';%1方向 ux
            mass_vec=obj.M1*mat_t;%每个自由度上的质量
            t1=obj.mode'*obj.M1*mat_t;
            mass_parti=repmat(t1,1,obj.arg{1})'.*repmat(mass_vec,1,obj.arg{1}) .*obj.mode;
            tt1=[sum(mass_parti)/sum(mass_vec)]';
            
            mat_t=obj.R1*[0 1 0]';%2方向 uy
            mass_vec=obj.M1*mat_t;%每个自由度上的质量
            t1=obj.mode'*obj.M1*mat_t;
            mass_parti=repmat(t1,1,obj.arg{1})'.*repmat(mass_vec,1,obj.arg{1}) .*obj.mode;
            tt2=[sum(mass_parti)/sum(mass_vec)]';
            
            mat_t=obj.R1*[0 0 1]';%3方向 uz
            mass_vec=obj.M1*mat_t;%每个自由度上的质量
            t1=obj.mode'*obj.M1*mat_t;
            mass_parti=repmat(t1,1,obj.arg{1})'.*repmat(mass_vec,1,obj.arg{1}) .*obj.mode;
            tt3=[sum(mass_parti)/sum(mass_vec)]';
            
            obj.modal_participating_mass_ratio=[tt1 tt2 tt3];
            
            
            %振型参与因子
            obj.modal_participation_factor=zeros(obj.arg{1},3);
            for i =1:obj.arg{1}
                obj.modal_participation_factor(i,:)=obj.mode(:,i)'*obj.M1*obj.R1*[1 0 0;0 1 0;0 0 1];
            end
            
            
            
            
            
            %振型参与因子1
            obj.modal_participation_factor1=zeros(length(obj.activeindex)  ,obj.arg{1});
            for i =1:obj.arg{1}
                t=obj.modal_participation_factor(i,:);
                t=[t 0 0 0]';%补充旋转的3个0
                t=repmat(t,obj.f.node.ndnum,1);
                obj.modal_participation_factor1(:,i)=obj.mode(:,i).*t(obj.activeindex);
            end
            
            
            
            
            
            
            
            
            
            
            
            %初始化结果指针
            obj.rst.SetPointer();
            
            
            
            
            


        end
        function GetK(obj)
            %K是总刚度矩阵(边界条件处理前) 阶数为6*节点个数
            obj.K=zeros(6*obj.f.node.ndnum,6*obj.f.node.ndnum);
            f=waitbar(0,'组装刚度矩阵','Name','FEM3DFRAME');
            for it=1:obj.f.manager_ele.num
                waitbar(it/obj.f.manager_ele.num,f,['组装刚度矩阵' num2str(it) '/' num2str(obj.f.manager_ele.num)]);
                e=obj.f.manager_ele.Get('index',it);
                obj.K=e.FormK(obj.K);
                
            end
            close(f);
        end
        function GetM(obj)%组装质量矩阵（边界条件引入之前) 务必先调用GetM形成映射
            %M是总质量矩阵(边界条件处理前) 阶数为6*节点个数
            obj.M=zeros(6*obj.f.node.ndnum,6*obj.f.node.ndnum);
            f=waitbar(0,'组装质量矩阵','Name','FEM3DFRAME');
            for it=1:obj.f.manager_ele.num
                waitbar(it/obj.f.manager_ele.num,f,['组装刚度矩阵' num2str(it) '/' num2str(obj.f.manager_ele.num)]);
                e=obj.f.manager_ele.Get('index',it);
                obj.M=e.FormM(obj.M);
                
            end
            close(f);
        end
        function CheckBC(obj)
            %要求位移边界条件全是0
            for it=1:obj.bc.displ.num
                ln=obj.bc.displ.Get('index',it);
                if ln(3)~=0
                    error('matlab:myerror','自振工况不能出现位移不为0的边界条件')
                end
            end
        end
        function r=PredictWithResponseSpectrum(obj,nd_id,dir,xi,ew)%使用反应谱预测位移响应
            %各个振型的谱值线性叠加 有限元软件中有srss cmc的叠加方法，此处没实现。
            index1=obj.GetIndex1InM1(nd_id,dir);
            t=obj.modal_participation_factor1(index1,:);%获取所有阶的index1值
            Ts=2*pi./obj.w;%周期
            [sds,~]=ew.ResponseSpectra_Tn(Ts,'sd',xi,0);%谱值
            r=t*sds;
        end
    end
    methods(Static)
        function [w,mode]=GetInfoForFreeVibration_eig(k,m,nummode,fmt)
            %利用广义特征值 KV=BVD求解自振信息
            %nummode 可选 前几阶频率和振型
            if nargin==2
                nummode=size(k,1);
                fmt='m';%默认按质量阵归一化
            elseif nargin==3
                fmt='m';
            elseif nargin==4
                if isempty(nummode)
                    nummode=size(k,1);
                end
            else
                error('未知参数')
            end
            if length(k)==1%单自由度
                [mode,D]=eigs(m^-1*k,nummode,'sm');%输出频率按从小到大排列
            else%多自由度
                [mode,D]=eigs(k,m,nummode,'sm');%输出频率按从小到大排列
            end
            
            w=sqrt(diag(D));
            %规格化振型
            switch fmt
                case 'm'
                    for it=1:nummode
                        mn=mode(:,it)'*m*mode(:,it);
                        mode(:,it)=mode(:,it)/sqrt(mn);
                    end
                case 'k'%按弹性势能为1规格化
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

