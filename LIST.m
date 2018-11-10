classdef LIST<handle
    %UNTITLED �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        cells MYCELL%������
        num%��¼����
    end
    
    methods
        function obj = LIST(inputArg1,inputArg2)
            %��������ʵ��
            if nargin==0
                obj.num=0;
            else
                error('����Ĳ�������')
            end
        end
        
        function Append(obj,s1,s2)
            %���һ����¼
            %   �˴���ʾ��ϸ˵��
            if nargin==2
                if isa(s1,'MYCELL')
                    obj.cells=[obj.cells;s1];
                    obj.num=obj.num+1;
                else
                    error('��������');
                end
            elseif nargin==3
                if isa(s2,'cell')&&isa(s1,'char')
                    t=MYCELL(s1,s2);
                    obj.cells=[obj.cells;t];
                    obj.num=obj.num+1;
                else
                    error('��������');
                end
            else
                error('��������');
            end
            
        end
        function Switch(obj,i,j)
            %�������
            if (~IsInteger(i))||(~IsInteger(j))
                warning('��������');
                return;
            elseif i<=0 || j<=0 ||i>obj.num||j>obj.num
                warning('��������');
                return;
            end
            t=obj.cells(i);
            obj.cells(i)=obj.cells(j);
            obj.cells(j)=t;
        end
        function Print(obj)
            for it=1:obj.num
                disp(obj.cells(it).label);
            end
        end
        function DeleteOne(obj,i)
            if i>=0&&i<=obj.num
                obj.cells(i)=[];
                obj.num=obj.num-1;
                return;
            else
                warning('δִ��ɾ������')
            end
            
            
        end
        function MoveUp(obj,i)
                        %�������
            if (~IsInteger(i))
                warning('��������');
                return;
            elseif i<=1 ||i>obj.num
                warning('��������');
                return;
            end
            obj.Switch(i,i-1);
        end
        function MoveDown(obj,i)
            %�������
            if (~IsInteger(i))
                warning('��������');
                return;
            elseif i<=0 ||i>=obj.num
                warning('��������');
                return;
            end
            obj.Switch(i,i+1);            
        end
    end
end

