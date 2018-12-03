classdef MyWaitbar<handle
    %�������Ҫ���ֲ��Դ���waitbar����Ч�ʵ�����
    %�������waitbar�ĸ��²�����xһ�仯�͸��� ���ǲ���counter����
    
    properties
        title
        text
        h%ͼ�����
        x%����
        
        counter%������
        maxcouter%�������ﵽ���ֵʱ ����h ���Ǽ���Ϊ0
    end
    
    methods
        function obj = MyWaitbar(text,title)
            if nargin==1%δָ��title
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

