classdef ScatterWithTips<handle
    %ʹɢ��ͼ�����Զ�����ʾ���ݱ�ǩ
    % ��Դ��https://zhidao.baidu.com/question/809091143326523852.html
    %���������ַ���и����ڽ�������Ϊ�����ĸ߼��÷���set(dcm_obj,'UpdateFcn',{@dcmcallback,L});
    %��ʱ������о�
    
    properties
        x double
        y double
        labels cell
    end
    
    methods
        function obj = ScatterWithTips(x,y,labels)
            %UNTITLED25 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
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
%             %METHOD1 �˴���ʾ�йش˷�����ժҪ
%             %   �˴���ʾ��ϸ˵��
%             dcm_obj = datacursormode(event_obj.Target.Parent.Parent);
%             info=getCursorInfo(dcm_obj);
%             ind = info.DataIndex;
%             txt=sca.z{ind};
%         end
                function txt = showtip(obj,empt,event_obj)
            %METHOD1 �˴���ʾ�йش˷�����ժҪ
            %   �˴���ʾ��ϸ˵��
            dcm_obj = datacursormode(event_obj.Target.Parent.Parent);
            info=getCursorInfo(dcm_obj);
            ind = info.DataIndex;
            txt=obj.labels{ind};
        end
        

    end
    
    methods(Static)

    end
end

