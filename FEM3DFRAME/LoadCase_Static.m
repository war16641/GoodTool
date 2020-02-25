classdef LoadCase_Static<LoadCase
    %UNTITLED3 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        
    end
    
    methods
        function obj = LoadCase_Static(f,name)
            obj=obj@LoadCase(f,name);
        end
        function Solve(obj)

            obj.PreSolve();
            %�жϹ��������ԵĻ��Ƿ����Ե�
            if obj.f.flag_nl==0%���Խṹ
                %���
                u1=obj.K1\obj.f_node1;
                
                %���������������ɶ��ϵ�����λ��
                obj.SetState(u1);
                
                %�ѽ�����浽noderst
                %static����ֻ��һ����Ϊstatic�ķ�ʱ����
                obj.rst.AddByState('static','nontime');

                
                %��ʼ�����ָ��
                obj.rst.SetPointer();
            else%�����Խṹ
                %����Ƿ����λ�Ʊ߽�����
                obj.CheckBC1();
                u_all=obj.Script_NR(obj,obj.f_node1);
                
                %���浽lc��
                obj.SetState(u_all(obj.activeindex));
                
                %������
                obj.rst.AddByState('static','nontime');
                
%                 obj.u=u_all;
%                 %���㵯�Բ�����
%                 f=obj.K*obj.u;
%                 %�ѽ�����浽rst
%                 %static����ֻ��һ����Ϊstatic�ķ�ʱ����
%                 obj.rst.AddNontime('static',f,obj.u);
                
                %��ʼ�����ָ��
                obj.rst.SetPointer();

            end


        end
        

        function GetK(obj)
            %K���ܸնȾ���(�߽���������ǰ) ����Ϊ6*�ڵ����
            
            

            
            
            K=zeros(6*obj.f.node.ndnum,6*obj.f.node.ndnum);
            f=waitbar(0,'��װ�նȾ���','Name','FEM3DFRAME');
            for it=1:obj.f.manager_ele.num
                waitbar(it/obj.f.manager_ele.num,f,['��װ�նȾ���' num2str(it) '/' num2str(obj.f.manager_ele.num)]);
                e=obj.f.manager_ele.Get('index',it);
                obj.K=e.FormK(K);
                K=obj.K;
                
            end
            close(f);
        end
        function CheckBC(obj)
            %����������bc�޶���Ҫ��
            return;
        end
        function CheckBC1(obj)%�����Թ�����Ҫ���bc����
            %Ҫ��λ�Ʊ߽�����ȫ��0
            for it=1:obj.bc.displ.num
                ln=obj.bc.displ.Get('index',it);
                if ln(3)~=0
                    error('nyh:error','�ǵ��Թ������ܳ���λ�Ʋ�Ϊ0�ı߽�����')
                end
            end
        end
        function GetM(obj)
            %������������ҪM
            obj.M=zeros(obj.dof,obj.dof);
        end
    end
    methods(Static)
        %�������
%         function [u_all]=Script_NR(obj,fn1,Kadd)%NR��������
%             %fn1ָ������� ��Ч���ɶ�
%             %Kadd���Ӿ���
%             if nargin==2
%                 Kadd=zeros(length(obj.activeindex),length(obj.activeindex));%��ָ��ʱ ȡ0
%             end
%             %u��λ������ ȫ���ɶ�
%             j=1;%��������
%             maxj=500;%����������
%             u=obj.u(obj.activeindex);
%             tol=1e-4;
%             Fs_n=zeros(obj.dof,1);
%             KT=zeros(obj.dof,obj.dof);
% 
% %             norm_f1=norm(obj.f_node1);%f1����
%             norm_f1=norm(fn1);%f1����
%             if norm_f1<tol%������Ϊ0ʱ
%                 norm_f1=tol;%Ϊ���ܼ���������norm(f_unbalance)/norm_f1 ȡ����Ϊһ����С��
%             end
%             %����ʼFs_n��KT
%             for it=1:obj.f.manager_ele.num
%                 e=obj.f.manager_ele.Get('index',it);
%                 if e.flag_nl==0%���Ե�Ԫ
%                     continue;
%                 end
%                 KT=e.FormMatrix(KT,e.KTel);
%                 Fs_n=e.FormVector(Fs_n,e.Fsel);
%             end
%             
%             Fs_n1=Fs_n(obj.activeindex);%��Чziyoudu
%             fig=figure;
%             
%             plot(u(1),Fs_n1(1),'+')
%             hold on;
%             xlast=u;
%             ylast=Fs_n1;
%             while 1
%                 disp('____________________________________________________________')
%                 disp([num2str(j) '�ε�����ʼ'])
%                 KT1=KT(obj.activeindex,obj.activeindex);
%                 Fs_n1=Fs_n(obj.activeindex);%��Чziyoudu
%                 disp('����ն�')
%                 KT1
%                 disp('�����Իظ���')
%                 Fs_n1
%                 f_unbalance=fn1-(obj.K1+Kadd)*u-Fs_n1;%��ƽ����
%                 plot([xlast(1) u(1)],[ylast(1) Fs_n1(1)],'r-o');
%                 xlast=u;
%                 ylast=Fs_n1;
%                 disp('��ƽ����');
%                 f_unbalance
%                 
%                 
%                 %����Ƿ������������
%                 if norm(f_unbalance)/norm_f1<tol%����
%                     %����nr״̬
%                     for it=1:obj.f.manager_ele.num
%                         e=obj.f.manager_ele.Get('index',it);
%                         if e.flag_nl==0%���Ե�Ԫ
%                             continue;
%                         end
%                         e.FinishNR();
%                         
%                     end
%                     close(fig)
%                     %����ڵ�λ��
%                     u_all=obj.u_beforesolve;
%                     u_all(obj.activeindex)=u;
%                     
%                     break;
%                 end
%                 %����Ƿ��Ѿ��ﵽ����������
%                 if j>=maxj
%                     error('nyh:error','�Ѿ��ﵽ���NR����')
%                 end
%                 %������
%                 du=(obj.K1+Kadd+KT1)^-1*f_unbalance;%����
%                 disp('λ������')
%                 du
%                 u=u+du;
%                 disp('����λ��')
%                 u
%                 %����
%                 Fs_n=zeros(obj.dof,1);
%                 KT=zeros(obj.dof,obj.dof);
%                 
%                 %������д�뵽���������Ե�Ԫ��
%                 for it=1:obj.f.manager_ele.num
%                     e=obj.f.manager_ele.Get('index',it);
%                     if e.flag_nl==0%���Ե�Ԫ
%                         continue;
%                     end
%                     
%                     duel=e.GetMyVec(du,obj);
%                     [Fsel,KTel]=e.AddNRHistory(duel);
% 
%                     Fs_n=e.FormVector(Fs_n,Fsel);
%                     KT=e.FormMatrix(KT,KTel);
%                     
%                 end
%                 j=j+1;%����������1
%                 
%                 
%             end
%         end
        function [u_all]=Script_NR(obj,fn1,Kadd)%NR��������
            %fn1ָ������� ��Ч���ɶ�
            %Kadd���Ӿ���
            if nargin==2
                Kadd=zeros(length(obj.activeindex),length(obj.activeindex));%��ָ��ʱ ȡ0
            end
            %u��λ������ ȫ���ɶ�
            j=1;%��������
            maxj=500;%����������
            u=obj.u(obj.activeindex);
            tol=1e-4;
            Fs_n=zeros(obj.dof,1);
            KT=zeros(obj.dof,obj.dof);
            norm_f1=norm(fn1);%f1����
            if norm_f1<tol%������Ϊ0ʱ
                norm_f1=tol;%Ϊ���ܼ���������norm(f_unbalance)/norm_f1 ȡ����Ϊһ����С��
            end
            %����ʼFs_n��KT
            for it=1:obj.f.manager_ele.num
                e=obj.f.manager_ele.Get('index',it);
                if e.flag_nl==0%���Ե�Ԫ
                    continue;
                end
                KT=e.FormMatrix(KT,e.KTel);
                Fs_n=e.FormVector(Fs_n,e.Fsel);
            end
            
            Fs_n1=Fs_n(obj.activeindex);%��Чziyoudu
%             fig=figure;
            
%             plot(u(1),Fs_n1(1),'+')
%             hold on;
%             xlast=u;
%             ylast=Fs_n1;
            while 1
%                 disp('____________________________________________________________')
%                 disp([num2str(j) '�ε�����ʼ'])
                KT1=KT(obj.activeindex,obj.activeindex);
                Fs_n1=Fs_n(obj.activeindex);%��Чziyoudu
%                 disp('����ն�')
%                 KT1
%                 disp('�����Իظ���')
%                 Fs_n1
                f_unbalance=fn1-(obj.K1+Kadd)*u-Fs_n1;%��ƽ����
%                 plot([xlast(1) u(1)],[ylast(1) Fs_n1(1)],'r-o');
%                 xlast=u;
%                 ylast=Fs_n1;
%                 disp('��ƽ����');
%                 f_unbalance
                
                
                %����Ƿ������������
                if norm(f_unbalance)/norm_f1<tol%����
                    %����nr״̬
                    for it=1:obj.f.manager_ele.num
                        e=obj.f.manager_ele.Get('index',it);
                        if e.flag_nl==0%���Ե�Ԫ
                            continue;
                        end
                        e.FinishNR();
                        
                    end
%                     close(fig)
                    %����ڵ�λ��
                    u_all=obj.u_beforesolve;
                    u_all(obj.activeindex)=u;
                    
                    break;
                end
                %����Ƿ��Ѿ��ﵽ����������
                if j>=maxj
                    error('nyh:error','�Ѿ��ﵽ���NR����')
                end
                %������
                du=(obj.K1+Kadd+KT1)^-1*f_unbalance;%����
%                 disp('λ������')
%                 du
                u=u+du;
%                 disp('����λ��')
%                 u
                %����
                Fs_n=zeros(obj.dof,1);
                KT=zeros(obj.dof,obj.dof);
                
                %������д�뵽���������Ե�Ԫ��
                for it=1:obj.f.manager_ele.num
                    e=obj.f.manager_ele.Get('index',it);
                    if e.flag_nl==0%���Ե�Ԫ
                        continue;
                    end
                    
                    duel=e.GetMyVec(du,obj);
                    [Fsel,KTel]=e.AddNRHistory(duel);

                    Fs_n=e.FormVector(Fs_n,Fsel);
                    KT=e.FormMatrix(KT,KTel);
                    
                end
                j=j+1;%����������1
                
                
            end
        end
    end
end

