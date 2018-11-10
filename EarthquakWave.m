classdef EarthquakWave<handle
    %UNTITLED2 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        tn%ʱ��������
        accn%���ٶ�������
        unit%���ٶȵ�λ
        note%���ע����
    end
    
    methods
        function obj = EarthquakWave(tn0,accn0,unit,note)
            %unit ʹ��string
            %   �˴���ʾ��ϸ˵��
            if nargin==2
                unit="m/s^2";%Ĭ����m/s^2
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
            %��ͼ������ʽ չʾ����
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
            disp([num2str(m) '*' num2str(n) '��' class(obj)]);
            for it=1:length(obj)
                disp(['����=' class(obj(it))]);
                disp(['�ں�' num2str(length(obj(it).tn)) '����']);
                disp(['note=' char(obj(it).note)] );
                disp(['unit=' char(obj(it).unit)] );
            end
            
        end
        function [period,peakv]=ResponseSpectra(obj,periodstart,periodend,type,dampratio,num)
            %��ȡ��Ӧ��
            % type ��ѡsd psv psa
            %dampratio�����
            %num �Ƿ�Ӧ�׵����
            
            %��鵥λ�Ǳ�׼��λ
            if ~strcmp("m/s^2",obj.unit)
                error('��λ���ԣ�ֻ����m/s^2')
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
                %c=2*m*w*0.00;% 0.01�����
                [~,v,dv,ddv]=SegmentalPrecision1_SDOF(k,m,obj.tn,pn,'ratio',dampratio,0,0);
                %peakacc(it)=k*max(v)/m;
                %peakacc(it)=max(v);
                %peakacc(it)=max(dv);
                
                switch type
                    case 'sd'
                        peakv(it)=AbsMax(v,1);%���λ����
                    case 'psv'
                        peakv(it)=AbsMax(dv,1);%������ٶ���
                    case 'psa'
                        peakv(it)=AbsMax(ddv'+obj.accn,1);%����ٶȷ�Ӧ��
                    otherwise
                        error('sdddd')
                end
                it=it+1;
            end
            figure
            plot(period,peakv);
            title(type);
            xlabel('����/s');ylabel('��ֵ')
        end
    end
    
    
    
end

