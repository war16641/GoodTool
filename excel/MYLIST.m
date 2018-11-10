classdef MYLIST <handle
    %坑爹的matlab listbox 没有内置listbox的基本功能 还要老子来写
    %   此处显示详细说明
    
    properties
        items
        itemsdata
        uilb%存放实际的listbox
    end
    
    methods
        function obj = MYLIST(lb)
            %UNTITLED 构造此类的实例
            %   此处显示详细说明
            obj.items=lb.Items;
            obj.itemsdata=1:length(obj.items);
            obj.uilb=lb;
            obj.Updata();
        end
        
        function print(obj)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            disp(obj.items);
            disp(obj.itemsdata)
        end
        function Append(obj,txt)
            %尾部添加元素 只能是字符串 或字符串细胞
            if ischar(txt)
                txt={txt};
            end
            if isempty(obj.items)%空的
                obj.items=txt;
                obj.itemsdata=1:length(txt);
            else
                obj.items=[obj.items txt];
                obj.itemsdata=1:length(obj.items);
            end
            
            obj.Updata();
        end
        function Delete(obj,index)
            %删除一个元素
            obj.items(index)=[];
            obj.itemsdata=1:length(obj.items);
        end
        function DeleteSelection(obj)
            %删除选择的元素
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
            %返回选择的字符串或字符串细胞
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
            %从字符串细胞中载入items 可以为空
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
        function Clear(obj)%清空s
            obj.items={};
            obj.itemsdata=[];
            obj.Updata();
        end
    end
end

