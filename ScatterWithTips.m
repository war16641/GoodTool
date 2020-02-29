classdef ScatterWithTips<handle
    %使散点图可以自定义显示数据标签
    % 来源：https://zhidao.baidu.com/question/809091143326523852.html
    %上面这个网址中有个关于将函数作为参数的高级用法：set(dcm_obj,'UpdateFcn',{@dcmcallback,L});
    %有时间可以研究
    
    properties
        x double
        y double
        labels cell
    end
    
    methods
        function obj = ScatterWithTips(x,y,labels)
            %UNTITLED25 构造此类的实例
            %   此处显示详细说明
            obj.x=x;
            obj.y=y;
            obj.labels=labels;
        end
        function fig=show(obj)
            fig=figure;
            plot(obj.x,obj.y,'.')
            dcm_obj = datacursormode(fig);
            set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on');
            set(dcm_obj,'UpdateFcn',@obj.showtip);
            
        end
%         function txt = showtip(obj,empt,event_obj,sca)
%             %METHOD1 此处显示有关此方法的摘要
%             %   此处显示详细说明
%             dcm_obj = datacursormode(event_obj.Target.Parent.Parent);
%             info=getCursorInfo(dcm_obj);
%             ind = info.DataIndex;
%             txt=sca.z{ind};
%         end
                function txt = showtip(obj,empt,event_obj)
            %METHOD1 此处显示有关此方法的摘要
            %   此处显示详细说明
            dcm_obj = datacursormode(event_obj.Target.Parent.Parent);
            info=getCursorInfo(dcm_obj);
            ind = info.DataIndex;
            txt=obj.labels{ind};
        end
        

    end
    
    methods(Static)

    end
end

