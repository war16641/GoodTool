classdef MYCELL<handle
    %�������cell + �ַ���
    
    %
    %   �˴���ʾ��ϸ˵��
    
    properties
        label%��ǩ
        c% cellÿһ�г�Ϊһ����¼���������������ÿһ����¼�ĸ�������ȵ�
        num%��¼������
    end
    
    methods
        function obj = MYCELL(l,s)
            %UNTITLED2 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            if nargin==0
                obj.c={};
                obj.num=0;
            elseif nargin==1
                obj.c={};
                obj.num=0;
                obj.label=l;
            elseif nargin==2%��ϸ��������
                %�������
                if (~isa(l,'char'))||(~isa(s,'cell'))
                    error('��������');
                end
                obj.label=l;
                obj.c=s;
                obj.num=size(s,1);
            else
                error();
            end
        end
        
        function Append(obj,s)
            obj.c=[obj.c;s];
            obj.num=obj.num+1;
        end
        function Erase(obj)
            %�������м�¼ ������ǩ
            obj.c={};
            obj.num=0;
        end
        function Switch(obj,i,j)
            %�������м�¼
            %�������
            if (~IsInteger(i))||(~IsInteger(j))
                warning('��������');
                return;
            elseif i<=0 || j<=0 ||i>obj.num||j>obj.num
                warning('��������');
                return;
            end
            
            t=obj.c(i,:);
            obj.c(i,:)=obj.c(j,:);
            obj.c(j,:)=t;
        end
        function MoveUp(obj,i)
            %��һ����¼����
            %�������
            if (~IsInteger(i))
                warning('��������');
                return;
            elseif i<=1 ||i>obj.num
                %warning('��������');
                return;
            end
            obj.Switch(i,i-1);
        end
        function MoveDown(obj,i)
            %��һ����¼����
            %�������
            if (~IsInteger(i))
                warning('��������');
                return;
            elseif i<=0 ||i>=obj.num
                %warning('��������');
                return;
            end
            obj.Switch(i,i+1);
        end   
        function DeleteOne(obj,i)
            %ɾ��һ������
            obj.c(i,:)=[];
            obj.num=obj.num-1;
        end
    end
end

