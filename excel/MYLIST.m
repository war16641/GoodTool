classdef MYLIST <handle
    %�ӵ���matlab listbox û������listbox�Ļ������� ��Ҫ������д
    %   �˴���ʾ��ϸ˵��
    
    properties
        items
        itemsdata
        uilb%���ʵ�ʵ�listbox
    end
    
    methods
        function obj = MYLIST(lb)
            %UNTITLED ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.items=lb.Items;
            obj.itemsdata=1:length(obj.items);
            obj.uilb=lb;
            obj.Updata();
        end
        
        function print(obj)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            disp(obj.items);
            disp(obj.itemsdata)
        end
        function Append(obj,txt)
            %β�����Ԫ�� ֻ�����ַ��� ���ַ���ϸ��
            if ischar(txt)
                txt={txt};
            end
            if isempty(obj.items)%�յ�
                obj.items=txt;
                obj.itemsdata=1:length(txt);
            else
                obj.items=[obj.items txt];
                obj.itemsdata=1:length(obj.items);
            end
            
            obj.Updata();
        end
        function Delete(obj,index)
            %ɾ��һ��Ԫ��
            obj.items(index)=[];
            obj.itemsdata=1:length(obj.items);
        end
        function DeleteSelection(obj)
            %ɾ��ѡ���Ԫ��
            for it=obj.uilb.Value(end:-1:1)
                obj.Delete(it);
            end
            obj.Updata();
        end
        function MoveUp(obj)
            if length(obj.uilb.Value)~=1
                return;
            end
            if obj.uilb.Value==1
                return;
            end
            obj.Switch(obj.uilb.Value-1,obj.uilb.Value);
            obj.uilb.Value=obj.uilb.Value-1;
            obj.Updata();
        end
        function MoveDown(obj)
            if length(obj.uilb.Value)~=1
                return;
            end
            if obj.uilb.Value==length(obj.items)
                return;
            end
            obj.Switch(obj.uilb.Value+1,obj.uilb.Value);
            obj.uilb.Value=obj.uilb.Value+1;
            obj.Updata();
        end
        function r=GetSelection(obj)
            %����ѡ����ַ������ַ���ϸ��
            r=[];
            if ~isempty(obj.uilb.Value)
                r=obj.items(obj.uilb.Value);
                return;
            end
            
        end
        function r=GetFirstSelection(obj)
            r=[];
            if ~isempty(obj.uilb.Value)
                r=obj.items(obj.uilb.Value(1));
                return;
            end
        end
        function LoadFromCell(obj,c)
            %���ַ���ϸ��������items ����Ϊ��
            if isempty(c)
                obj.items={};
                obj.itemsdata=[];
                obj.Updata();
                return;
            end
            
            obj.items=c;
            obj.itemsdata=1:length(c);
            obj.Updata();
        end
        function Updata(obj)
            obj.uilb.Items=obj.items;
            obj.uilb.ItemsData=obj.itemsdata;
        end
        function Switch(obj,i,j)
            t=obj.items{i};
            obj.items{i}=obj.items{j};
            obj.items{j}=t;
        end
        function Clear(obj)%���s
            obj.items={};
            obj.itemsdata=[];
            obj.Updata();
        end
    end
end

