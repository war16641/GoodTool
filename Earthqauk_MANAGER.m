classdef Earthqauk_MANAGER<HCM.HANDLE_CLASS_MANAGER
    %UNTITLED3 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        
    end
    
    methods
        function obj = Earthqauk_MANAGER()
            obj=obj@HCM.HANDLE_CLASS_MANAGER('EarthquakWave','note');
        end
        
        function LoadFromFile(obj,filenamecell,namecell,lineomit)%���ļ�������һϵ�е���
            %filenamecell �ַ���ϸ��
            %namecell ���𲨵�note �ַ���ϸ��
            %lineomit ����������
            for it=1:length(filenamecell)
                dt=ReadTxt(filenamecell{it},2,lineomit);
                tmp=EarthquakWave(dt(:,1),dt(:,2),'m/s^2',namecell{it});%Ĭ���ļ���ʽ�ǵ�һ��ʱ�� �ڶ��м��ٶ� ��λm/s^2
                obj.Add(tmp);
            end
%             for it=1:length(filenamecell)
%                 dt=ReadTxt(filenamecell{it},2,lineomit);
%                 tmp=EarthquakWave(dt(:,1),dt(:,2),'m/s^2',namecell{it});%Ĭ���ļ���ʽ�ǵ�һ��ʱ�� �ڶ��м��ٶ� ��λm/s^2
%                 obj.Add(tmp);
%             end



        end
        function CompareResponseSpectra(obj,periodstart,periodend,type,dampratio,num)%�ȽϷ�Ӧ��
            %periodstart
            %periodend
            %type��Ӧ������
            %dampratio
            %num��ֵ��
            
            %���type��ֵ
            vs=["sd","psv","psa"];
            validatestring(string(type),vs);
            
            figure;
            hold on;
            le={};
            
            %������ֵ
            for it=1:obj.num
                le=[le obj.objects(it).note];
                obj.objects(it).ResponseSpectra(periodstart,periodend,char(type),dampratio,num,0);
                %��ͼ
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
            xlabel('����/s');ylabel('��ֵ')
            legend(le)
       
        end
    end
end

