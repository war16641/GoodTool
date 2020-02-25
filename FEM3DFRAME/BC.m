classdef BC<handle
    %����Ԫ�ı߽�������������λ��
    
    properties
        displ 
        force %Լ����forceδ������displδ�����Ľڵ���Ϊ0
        lc LoadCase
    end
    
    methods
        function obj = BC(lc)
            obj.lc=lc;
            obj.displ=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.force=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
        end
        
        function Add(obj,type,ln,flag_overwrite)
            %ln=ndid,dir,value         dir=1~6
            %flag_overwriteָʾ�Ƿ񸲸� Ĭ�ϸ���1
            if nargin==3
                flag_overwrite=1;
            end
            
            %���ln�Ƕ��в�ɵ���һ��һ����
            if 1~=size(ln,1)
                for it=1:size(ln,1)
                    obj.Add(type,ln(it,:),flag_overwrite);
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
            
            
            
            switch type
                case 'displ'
                    [success,ow]=obj.displ.Add(ln(1)+ln(2)*0.1,ln,flag_overwrite);
                    if success==0
                        error('matlab:myerror','���BC����')
                    end
                    if ow==1
                        disp(['λ�ƺ��ظ���'  ' �ڵ�' num2str(ln(1)) ' ����'  num2str(ln(2))])
                    end
                case 'force'
                    [success,ow]=obj.force.Add(ln(1)+ln(2)*0.1,ln,flag_overwrite);
                    if success==0
                        error('matlab:myerror','���BC����')
                    end
                    if ow==1
                        disp(['�����ظ���'  ' �ڵ�' num2str(ln(1)) ' ����'  num2str(ln(2))])
                    end
                otherwise
                    error('adf')
            end

        end
        function Overwrite(obj,type,ln)%����
            %������
            if false==obj.lc.f.node.IsExist(ln(1))
                error('MATLAB:myerror','�ڵ㲻����');
            end
            if ~IsIn(ln(2),1:6)
                error('MATLAB:myerror','�޴����ɶȷ���');
            end
            
            switch type
                case 'displ'
                    for it=1:size(obj.displ,1)
                        if ln(1)==obj.displ(it,1) && ln(2)==obj.displ(it,2)%�ڵ�źͷ���һ��
                            obj.displ(it,:)=ln; 
                            return;
                        end
                    end
                    error('matlab:myerror','δ�ҵ�')
                case 'force'
                    for it=1:size(obj.force,1)
                        if ln(1)==obj.force(it,1) && ln(2)==obj.force(it,2)%�ڵ�źͷ���һ��
                            obj.force(it,:)=ln; 
                            return;
                        end
                    end
                    error('matlab:myerror','δ�ҵ�')
                otherwise
                    error('adf')
            end
        end
        function Check(obj)%���߽������Ƿ�����
            obj.force.Check();
            obj.displ.Check();
            %���λ�� ���Ƿ�ͬʱ������ͬһ���ɶ���
            if obj.force.num>0&&obj.displ.num>0
                tmp1=[obj.force.object{:,1}];
                tmp2=[obj.displ.object{:,1}];
                tmp=[tmp1 tmp2];
                [~,ia,~]=unique(tmp);
                if length(ia)~=obj.force.num+obj.displ.num
                    error('nyh:error','λ�� ���Ƿ�ͬʱ������ͬһ���ɶ���')
                end
            end


%             len1=size(obj.displ,1);
%             len2=size(obj.force,1);
%             tmp=[];
%             if len1~=0
%                 tmp=obj.displ(:,[1 2]);
%             end
%             if len2~=0
%                 tmp=[tmp ;obj.force(:,[1 2])];
%             end
%             [~,ia,~]=unique(tmp,'rows');
%             if len1+len2~=length(ia)
%                 error('matlab:myerror','�߽����������ظ���')
%             end
        end
    end
end

