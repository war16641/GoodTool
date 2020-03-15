classdef AutoArrangeFigure<handle
    %自动调整图窗位置
    properties
        m
        n

        width
        height%单个figure的宽高
        
        i
        m1
        n1 %当前位置
    end
    
    methods 
        function obj=AutoArrangeFigure(m,n)
            obj.m=m;
            obj.n=n;
            obj.i=0;
            obj.width=1920/m;
%             obj.height=1080/n;
            obj.height=900/n;
            obj.m1=0;
            obj.n1=1;
        end
        function h=make_next_figure(obj)
            obj.i=obj.i+1;
            if obj.m1+1>obj.m
                obj.m1=1;
                obj.n1=obj.n1+1;
            else
                obj.m1=obj.m1+1;
            end
            if obj.n1>obj.n
                obj.n1=1;
            end
            h=figure('position',[ obj.width*(obj.m1-1), obj.height*(obj.n1-1) ,obj.width, obj.height]);
        end
    end
end