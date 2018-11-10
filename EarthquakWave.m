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
            %unit 使用string
            %   此处显示详细说明
            if nargin==2
                unit="m/s^2";%默认是m/s^2
                note='';
            elseif nargin==3
                validStrings = ["m/s^2","gal","g"];
                validatestring(unit,validStrings);
                note='';
            end
            obj.tn=VectorDirection(tn0);
            obj.accn=VectorDirection(accn0);
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
                disp(['note=' char(obj(it).note)] );
                disp(['unit=' char(obj(it).unit)] );
            end
            
        end
        function [period,peakv]=ResponseSpectra(obj,periodstart,periodend,type,dampratio,num)
            %获取反应谱
            % type 可选sd psv psa
            %dampratio阻尼比
            %num 是反应谱点个数
            
            %检查单位是标准单位
            if ~strcmp("m/s^2",obj.unit)
                error('单位不对，只能是m/s^2')
            end
            if 7==nargin
                num=200;
            end
            
            m=1;
            pn=-m*obj.accn;
            period=linspace(periodstart,periodend,num);
            peakv=zeros(1,num);
            it=1;
            for period1=period
                k=4*pi^2*m/period1^2;
                %c=2*m*w*0.00;% 0.01阻尼比
                [~,v,dv,ddv]=SegmentalPrecision1_SDOF(k,m,obj.tn,pn,'ratio',dampratio,0,0);
                %peakacc(it)=k*max(v)/m;
                %peakacc(it)=max(v);
                %peakacc(it)=max(dv);
                
                switch type
                    case 'sd'
                        peakv(it)=AbsMax(v,1);%相对位移谱
                    case 'psv'
                        peakv(it)=AbsMax(dv,1);%拟相对速度谱
                    case 'psa'
                        peakv(it)=AbsMax(ddv'+obj.accn,1);%拟加速度反应谱
                    otherwise
                        error('sdddd')
                end
                it=it+1;
            end
            figure
            plot(period,peakv);
            title(type);
            xlabel('周期/s');ylabel('谱值')
        end
    end
    
    
    
end

