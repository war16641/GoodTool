classdef MyWaitbar<handle
    %这个类主要是弥补自带的waitbar拖慢效率的问题
    %这个类是waitbar的更新并不是x一变化就更新 而是采用counter计数
    
    properties
        title
        text
        h%图窗句柄
        x%进度
        
        counter%计数器
        maxcouter%当计数达到这个值时 更新h 并是计数为0
    end
    
    methods
        function obj = MyWaitbar(text,title)
            if nargin==1%未指定title
                title='mywaitbar';
            end
            obj.h=waitbar(0,text,'name',title);
            obj.maxcouter=50;
            obj.counter=0;
        end
        
%         function set.text(obj,text)
%             wait(obj.x,obj.h,text);
%             obj.text=text;
%         end
        function set.x(obj,x)
            
            obj.x=x;
            obj.counter=obj.counter+1;
            if obj.counter>=obj.maxcouter
                waitbar(obj.x,obj.h,obj.text);
                obj.counter=0;
            end
        end
        function Close(obj)
            close(obj.h);
        end
    end
end

