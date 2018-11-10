classdef EarthquakWave<handle
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        tn%时间列向量
        accn%加速度列向量
        unit%加速度单位
        note%添加注释用
    end
    
    methods
        function obj = EarthquakWave(tn0,accn0,unit,note)
            %UNTITLED2 构造此类的实例
            %   此处显示详细说明
            if nargin==2;
                unit='m/s^2';
                note='';
            elseif nargin==3;
                note='';
            end
            obj.tn=ColumnVector(tn0);
            obj.accn=ColumnVector(accn0);
            obj.unit=unit;
            obj.note=note;
        end
        
        function Show(obj)
            %以图窗的形式 展示数据
            for it=1:length(obj)
                figure;
                plot(obj(it).tn,obj(it).accn);
                xlabel('time(s)');ylabel(['acceleration(' obj(it).unit  ')']);title(obj(it).note);
            end
            %             if length(obj)~=1
            %                 for it=1:length(obj)
            %                     figure;
            %                     plot(obj(it).tn,obj(it).accn);
            %                     xlabel('time(s)');ylabel(['acceleration(' obj(it).unit  ')']);title(obj(it).note);
            %                 end
            %                 break;
            %             end
            %             figure;
            %             plot(obj.tn,obj.accn);
            %             xlabel('time(s)');ylabel(['acceleration(' obj.unit  ')']);title(obj.note);
        end
        function disp(obj)
            [m,n]=size(obj);
            disp([num2str(m) '*' num2str(n) '个' class(obj)]);
            for it=1:length(obj)
                disp(['类型=' class(obj(it))]);
                disp(['内含' num2str(length(obj(it).tn)) '个点']);
                disp(['note=' obj(it).note] );
                disp(['unit=' obj(it).unit] );
            end
            
        end
    end
    
    methods(Static)%静态方法 可用的单位
        function units=ValidUnit()
            units.m='m/s^2';
            units.cm='cm/s^2';
            units.g='g';
        end
    end
end

