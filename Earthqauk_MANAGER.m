classdef Earthqauk_MANAGER<HCM.HANDLE_CLASS_MANAGER
    %UNTITLED3 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        
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
    end
end

