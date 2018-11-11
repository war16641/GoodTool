classdef EarthquakWave<handle
    %UNTITLED2 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        tn%ʱ��������
        accn%���ٶ�������
        unit%���ٶȵ�λ
        note%���ע����
        
        spectralvalue_sd%sd��ֵ ��һ�б�ʾ���� �ڶ��б�ʾ��ֵ
        spectralvalue_psv
        spectralvalue_psa
    end
    
    methods
        function obj = EarthquakWave(tn0,accn0,unit,note)
            %unit ʹ��string
            %   �˴���ʾ��ϸ˵��
            if nargin==0%�޲���
                obj.tn=[];
                obj.accn=[];
                obj.unit="m/s^2";%Ĭ����m/s^2
                obj.note='';
                obj.spectralvalue_sd=[];%��ֵ��Ϊ0
                obj.spectralvalue_psa=[];
                obj.spectralvalue_psv=[];
                return;
            elseif nargin==2
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
            obj.spectralvalue_sd=[];%��ֵ��Ϊ0
            obj.spectralvalue_psa=[];
            obj.spectralvalue_psv=[];
        end
        function LoadFromFile(obj,note,unit,filename,fmt,lineomit,width,timeint)
            %width ָ���������ݵĳ���
            %timeint ָ��ʱ����
            switch char(fmt)
                case 'time&acc'
                    dt=ReadTxt(filename,2,lineomit);
                    obj.tn=dt(:,1);
                    obj.accn=dt(:,2);

                case 'matrix1'%������ʽ�ĵ����ļ� ��Ҫ�Ѿ���ת��Ϊ������ ��ʽʹ�÷ָ���
                    dt=ReadTxtWithMatrixFormat(filename,'split',lineomit);
                    obj.tn=[0:length(dt)-1]'*timeint;
                    obj.accn=dt;
                case 'matrix2'%������ʽ�ĵ����ļ� ��Ҫ�Ѿ���ת��Ϊ������ ��ʽʹ�ù̶����
                    dt=ReadTxtWithMatrixFormat(filename,'fixedwidth',lineomit,width);
                    obj.tn=[0:length(dt)-1]'*timeint;
                    obj.accn=dt;                    
                otherwise
                    error('sd')
            end

            validStrings = ["m/s^2","gal","g"];
            validatestring(string(unit),validStrings);
            obj.unit=unit;
            obj.note=note;
            
        end
        function SwitchUnit(obj)
            %����λ��Ϊ��׼��λ
            if strcmp("m/s^2",obj.unit)
                return;
            end
            switch char(obj.unit)
                case 'gal'
                    obj.unit="m/s^2";
                    obj.accn=obj.accn/100;
                case 'g'
                    obj.unit="m/s^2";
                    obj.accn=obj.accn*9.816;%Ĭ���������ٶ�Ϊ9.816m/s^2
                otherwise
                    error('sd');
            end
        end
        function Show(obj)
            %��ͼ������ʽ չʾ����
            for it=1:length(obj)
                figure;
                plot(obj(it).tn,obj(it).accn);
                xlabel('time(s)');ylabel(['acceleration(' char(obj(it).unit)  ')']);title(obj(it).note);
            end
        end
        function disp(obj)
            [m,n]=size(obj);
            disp([num2str(m) '*' num2str(n) '��' class(obj)]);
            disp(' ')
            for it=1:length(obj)
                disp(['����=' class(obj(it))]);
                disp(['�ں�' num2str(length(obj(it).tn)) '����']);
                disp(['note=' char(obj(it).note)] );
                disp(['unit=' char(obj(it).unit)] );
                disp(['ʱ���������ܣ�=' num2str(obj(it).tn(2)-obj(it).tn(1))]);%ʱ�����п��ܲ��ǵȲ�����
                disp(['����ʱ��=' num2str(obj(it).tn(end))]);
                disp(['��ֵ���ٶ�=' num2str(AbsMax(obj(it).accn))]);
                disp(' ')
            end
            
        end
        function ResponseSpectra(obj,periodstart,periodend,type,dampratio,num,flag_draw)
            %��ȡ��Ӧ��
            % type ��ѡsd psv psa
            %dampratio�����
            %num �Ƿ�Ӧ�׵����
            %flag_draw��ʾ�Ƿ�Ҫ��ͼ
            %��鵥λ�Ǳ�׼��λ
            if ~strcmp("m/s^2",obj.unit)
                %error('��λ���ԣ�ֻ����m/s^2')
                obj.SwitchUnit();
            end
            if 5==nargin
                num=200;
                flag_draw=1;%Ĭ����ͼ
            elseif 6==nargin
                flag_draw=1;%Ĭ����ͼ
            elseif 7==nargin
                
            else
                error('δ֪��������')
            end
            
            m=1;
            pn=-m*obj.accn;
            period=linspace(periodstart,periodend,num);
            %׼�����ݸ�ʽ
            switch type
                case 'sd'
                    obj.spectralvalue_sd=[period' zeros(num,1)];%���λ����
                case 'psv'
                    obj.spectralvalue_psv=[period' zeros(num,1)];%������ٶ���
                case 'psa'
                    obj.spectralvalue_psa=[period' zeros(num,1)];%����ٶȷ�Ӧ��
                otherwise
                    error('sdddd')
            end
            
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
                        obj.spectralvalue_sd(it,2)=AbsMax(v,1);%���λ����
                    case 'psv'
                        obj.spectralvalue_psv(it,2)=AbsMax(dv,1);%������ٶ���
                    case 'psa'
                        obj.spectralvalue_psa(it,2)=AbsMax(ddv'+obj.accn,1);%����ٶȷ�Ӧ��
                    otherwise
                        error('sdddd')
                end
                it=it+1;
            end
            
            if 1==flag_draw%Ҫ��ͼ
                switch type
                    case 'sd'
                        figure
                        plot(obj.spectralvalue_sd(:,1),obj.spectralvalue_sd(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('����/s');ylabel('��ֵ')
                    case 'psv'
                        figure
                        plot(obj.spectralvalue_psv(:,1),obj.spectralvalue_psv(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('����/s');ylabel('��ֵ')
                    case 'psa'
                        figure
                        plot(obj.spectralvalue_psa(:,1),obj.spectralvalue_psa(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('����/s');ylabel('��ֵ')
                    otherwise
                        error('sdddd')
                end
            
            end


        end
        
    end
    methods(Static)
 
    end
    
    
end

