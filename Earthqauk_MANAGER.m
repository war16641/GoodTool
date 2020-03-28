classdef Earthqauk_MANAGER<HCM.HANDLE_CLASS_MANAGER
    %UNTITLED3 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        peakvalue %各个地震波的峰值加速度
    end
    
    methods
        function obj = Earthqauk_MANAGER()
            obj=obj@HCM.HANDLE_CLASS_MANAGER('EarthquakWave','note');
        end
        
        function LoadFromFile(obj,filenamecell,namecell,lineomit)%从文件中载入一系列地震波
            %filenamecell 字符串细胞
            %namecell 地震波的note 字符串细胞
            %lineomit 跳过的行数
            for it=1:length(filenamecell)
                dt=ReadTxt(filenamecell{it},2,lineomit);
                tmp=EarthquakWave(dt(:,1),dt(:,2),'m/s^2',namecell{it});%默认文件格式是第一列时间 第二列加速度 单位m/s^2
                obj.Add(tmp);
            end
%             for it=1:length(filenamecell)
%                 dt=ReadTxt(filenamecell{it},2,lineomit);
%                 tmp=EarthquakWave(dt(:,1),dt(:,2),'m/s^2',namecell{it});%默认文件格式是第一列时间 第二列加速度 单位m/s^2
%                 obj.Add(tmp);
%             end



        end
        function LoadFromFile1(obj,filenamecell,varargin)
            %filenamecell 字符串细胞
            %varargin输入给EarthquakWave.LoadFromFile1后续的参数
            for it=1:length(filenamecell)
                ew=EarthquakWave.LoadFromFile1('fromfile','m/s^2',filenamecell{it},varargin{:});
                obj.Add(ew);
            end
        end
        function CompareResponseSpectra(obj,periodstart,periodend,type,dampratio,num)%比较反应谱
            %periodstart
            %periodend
            %type反应谱类型
            %dampratio
            %num谱值数
            
            %检查type的值
            vs=["sd","psv","psa"];
            validatestring(string(type),vs);
            
            figure;
            hold on;
            le={};
            
            %计算谱值
            for it=1:obj.num
                le=[le obj.objects(it).note];
                obj.objects(it).ResponseSpectra(periodstart,periodend,char(type),dampratio,num,0);
                %做图
                switch char(type)
                    case 'sd'
                        plot(obj.objects(it).spectralvalue_sd(:,1),obj.objects(it).spectralvalue_sd(:,2));
                    case 'psv'
                        plot(obj.objects(it).spectralvalue_psv(:,1),obj.objects(it).spectralvalue_sd(:,2));
                    case 'psa'
                        plot(obj.objects(it).spectralvalue_psa(:,1),obj.objects(it).spectralvalue_sd(:,2));
                    otherwise
                        error('sdddd')
                end
            end
            title(type)
            xlabel('周期/s');ylabel('谱值')
            legend(le)
       
        end
        function ComparePSD(obj,ax)
            if nargin==1
                figure;
                axes;
                hold on
            else
                axes(ax);
                hold on;
            end
            
            le={};
            for it=1:obj.num
                [p,f]=obj.objects(it).PSD(0);
                plot(f,p);
                le=[le obj.objects(it).note];
            end
            title('PSD');
            xlabel('频率/Hz');
            legend(le)
            set(gca,'yscale','log');%改为对数坐标
        end
        function Compare(obj)%比较时程
            figure;
            hold on
            le={};
            for it=1:obj.num
                plot(obj.objects(it).tn,obj.objects(it).accn);
                le=[le obj.objects(it).note];
            end
            title('时程加速度');
            xlabel('时间');
            legend(le);
        end
        function r=get.peakvalue(obj)
            r=zeros(obj.num,1);
            for it=1:obj.num
                r(it)=obj.GetByIndex(it).peakpoint(2);
            end
        end
    end
end

