classdef InitialDispl<handle
    %�����ʼλ��
    properties
        lc LoadCase_Earthquake
        displ
        u0 double %��ʼλ������
    end
    
    methods
        function obj = InitialDispl(lc)
            obj.lc=lc;
            obj.displ=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
        end
        
        function Add(obj,ln,flag_overwrite)%��ӳ�ʼλ��
            %ע����ӵĳ�ʼλ�Ʋ��ܺ�bc�е�λ�Ʊ߽��ظ� �˺����Դ˽��м��
            if nargin==2
                flag_overwrite=1;%Ĭ�ϸ���
            end
            
            %���ln�Ƕ��в�ɵ���һ��һ����
            if 1~=size(ln,1)
                for it=1:size(ln,1)
                    obj.Add(ln(it,:),flag_overwrite);
                end
                return;
            end
            
            %������
            if false==obj.lc.f.node.IsExist(ln(1))
                error('MATLAB:myerror','�ڵ㲻����');
            end
            if ~IsIn(ln(2),1:6)
                error('MATLAB:myerror','�޴����ɶȷ���');
            end
            
            %����Ƿ���bc��λ�Ʊ߽��ظ�
            if 0~=obj.lc.bc.displ.FindId(ln(1)+ln(2)*0.1)
                error('nyh:error','��ʼλ����bc��λ�Ʊ߽��ظ�')
            end
            
            [success,ow]=obj.displ.Add(ln(1)+ln(2)*0.1,ln,flag_overwrite);
            if success==0
                error('matlab:myerror','���BC����')
            end
            if ow==1
                disp(['��ʼλ�Ƹ���'  ' �ڵ�' num2str(ln(1)) ' ����'  num2str(ln(2))])
            end
        end
        
        
        
        function u0=MakeU0(obj)%���ɳ�ʼλ������������߽�����ǰ��
            obj.u0=zeros(obj.lc.dof,1);
            for it=1:obj.displ.num
                ln=obj.displ.Get('index',it);
                index=obj.lc.f.node.GetXuhaoByID(ln(1))+ln(2)-1;%�õ����
                obj.u0(index)=ln(3);
            end
            u0=obj.u0;
        end
    end
end

