classdef MYCELL<handle
    %这个类是cell + 字符串
    
    %
    %   此处显示详细说明
    
    properties
        label%标签
        c% cell每一行成为一条记录，其个数不定，但每一条记录的个数是相等的
        num%记录的数量
    end
    
    methods
        function obj = MYCELL(l,s)
            %UNTITLED2 构造此类的实例
            %   此处显示详细说明
            if nargin==0
                obj.c={};
                obj.num=0;
            elseif nargin==1
                obj.c={};
                obj.num=0;
                obj.label=l;
            elseif nargin==2%从细胞中载入
                %参数检查
                if (~isa(l,'char'))||(~isa(s,'cell'))
                    error('参数错误');
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
            %擦除所有记录 保留标签
            obj.c={};
            obj.num=0;
        end
        function Switch(obj,i,j)
            %交换两行记录
            %参数检查
            if (~IsInteger(i))||(~IsInteger(j))
                warning('参数错误');
                return;
            elseif i<=0 || j<=0 ||i>obj.num||j>obj.num
                warning('参数错误');
                return;
            end
            
            t=obj.c(i,:);
            obj.c(i,:)=obj.c(j,:);
            obj.c(j,:)=t;
        end
        function MoveUp(obj,i)
            %将一条记录上移
            %参数检查
            if (~IsInteger(i))
                warning('参数错误');
                return;
            elseif i<=1 ||i>obj.num
                %warning('参数错误');
                return;
            end
            obj.Switch(i,i-1);
        end
        function MoveDown(obj,i)
            %将一条记录上移
            %参数检查
            if (~IsInteger(i))
                warning('参数错误');
                return;
            elseif i<=0 ||i>=obj.num
                %warning('参数错误');
                return;
            end
            obj.Switch(i,i+1);
        end   
        function DeleteOne(obj,i)
            %删除一条数据
            obj.c(i,:)=[];
            obj.num=obj.num-1;
        end
    end
end

