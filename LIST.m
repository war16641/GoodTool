classdef LIST<handle
    %UNTITLED 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        cells MYCELL%列向量
        num%记录个数
    end
    
    methods
        function obj = LIST(inputArg1,inputArg2)
            %构造此类的实例
            if nargin==0
                obj.num=0;
            else
                error('错误的参数个数')
            end
        end
        
        function Append(obj,s1,s2)
            %添加一条记录
            %   此处显示详细说明
            if nargin==2
                if isa(s1,'MYCELL')
                    obj.cells=[obj.cells;s1];
                    obj.num=obj.num+1;
                else
                    error('错误类型');
                end
            elseif nargin==3
                if isa(s2,'cell')&&isa(s1,'char')
                    t=MYCELL(s1,s2);
                    obj.cells=[obj.cells;t];
                    obj.num=obj.num+1;
                else
                    error('错误类型');
                end
            else
                error('参数错误');
            end
            
        end
        function Switch(obj,i,j)
            %参数检查
            if (~IsInteger(i))||(~IsInteger(j))
                warning('参数错误');
                return;
            elseif i<=0 || j<=0 ||i>obj.num||j>obj.num
                warning('参数错误');
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
                warning('未执行删除操作')
            end
            
            
        end
        function MoveUp(obj,i)
                        %参数检查
            if (~IsInteger(i))
                warning('参数错误');
                return;
            elseif i<=1 ||i>obj.num
                warning('参数错误');
                return;
            end
            obj.Switch(i,i-1);
        end
        function MoveDown(obj,i)
            %参数检查
            if (~IsInteger(i))
                warning('参数错误');
                return;
            elseif i<=0 ||i>=obj.num
                warning('参数错误');
                return;
            end
            obj.Switch(i,i+1);            
        end
    end
end

