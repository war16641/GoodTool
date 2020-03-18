classdef EarthquakWave<handle&matlab.mixin.Copyable
    %UNTITLED2 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        tn%ʱ��������
        accn%���ٶ�������
        unit%���ٶȵ�λ
        note%���ע����
        numofpoint%�����
        
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
                case 'acc'
                    dt=ReadTxt(filename,1,lineomit);
                    obj.accn=VectorDirection(dt);
                    obj.tn=[0:length(dt)-1]'*timeint;
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
                if isempty(obj(it).tn)
                    continue;
                end
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
        function [puzhi,Tn]=ResponseSpectra_Tn(obj,Tn,type,dampratio,flag_draw)
            %ָ����������
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
            if 4==nargin
                flag_draw=1;%Ĭ����ͼ
            elseif 5==nargin
            else
                error('δ֪��������')
            end
            
            m=1;
            pn=-m*obj.accn;
            period=VectorDirection(Tn,'row');
            num=length(Tn);
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
            
            %�����������ֵ
            if nargout~=0
                switch type
                    case 'sd'
                        puzhi=obj.spectralvalue_sd(:,2);
                        
                    case 'psv'
                        puzhi=obj.spectralvalue_psv(:,2);
                        
                    case 'psa'
                        puzhi=obj.spectralvalue_psa(:,2);
                        
                    otherwise
                        error('sdddd')
                end
                
            end
            
            
        end
        function [power,f]=PSD(obj,flag_draw)%������
            %ʹ�����ú���periodogram�����׹��ƣ���һ�ֹ��ơ�
            %�ҵ�ʹ�ù۲쾭�飺�˺������С���� �Դ˴�����Ĩ��������Ӱ�졣
            %ʹ��Ҫ��ʱ������һ���ǵȲ����� �����ڲ����������
            if nargin==1
                flag_draw=1;%Ĭ����ͼ
            end
            Fs=1/(obj.tn(2)-obj.tn(1));%��ǰ��������Ƶ��
            [power,f]=periodogram(obj.accn,ones(length(obj.accn),1),length(obj.accn),Fs); %ֱ�ӷ�
            if isequal(flag_draw,1)%��ͼ
                figure;
                plot(f,power);
                set(gca,'yscale','log');%��Ϊ��������
                xlabel('Ƶ��/Hz');
                ylabel('psd');
                title('psd');
            else
                %����ͼ
            end
        end
        function r=get.numofpoint(obj)
            r=length(obj.tn);
        end
        function StandardizeScale(obj)%��׼���߶� �����𲨵ķ�ֵ��Ϊ+1
            obj.SwitchUnit();
            tmp=AbsMax(obj.accn);
            obj.accn=obj.accn/tmp;
        end
        function AbandonHalf(obj)%����һ��ĵ�
            tmp=2:2:obj.numofpoint;
            obj.tn(tmp)=[];
            obj.accn(tmp)=[];
        end
        function ReservePoint(obj,n)%����ǰ��n����
            if n>obj.numofpoint
                return;
            end
            obj.tn=obj.tn(1:n);
            obj.accn=obj.accn(1:n);
        end
        function CutPoint(obj,n)%����ǰ��n����
            if n>obj.numofpoint
                return;
            end
            obj.tn(end-n+1:end)=[];
            obj.accn(1:n)=[];
        end
        function PointInterpolation(obj,numadd)%�����ڲ��
            [xx ,yy]=DataInterpolation(obj.tn,obj.accn,numadd);
            obj.tn=xx;
            obj.accn=yy;
        end
        function SelfCheck(obj)%�Լ� ��Ҫ�Ǽ��ʱ�������Ƿ��ǵȲ����� ��������
            if obj.numofpoint<=2
                return;
            end
            dis=obj.tn(2)-obj.tn(1);
            for it=3:obj.numofpoint
                if dis+obj.tn(it-1)~=obj.tn(it)
                    warning('ʱ�����в��ǵȲ�����')
                    break;
                end
            end
            for i=1:obj.numofpoint-1
                if obj.tn(i+1)<obj.tn(i)
                    warning('ʱ�����в��ǵ�������')
                    break;
                end
            end
        end
        function Write2File(obj,path,flag_writeinfo)%�ѵ���д���ĵ� ��ʱ����ٶ����е���ʽ
            %path �ļ�����·��
            %flag_writeinfo �Ƿ�д��note ��λ
            if nargin==2
                flag_writeinfo=0;%Ĭ�ϲ�д��
            end
            
            fid=fopen(path,'w');
            if flag_writeinfo==1
%                 fprintf(fid,[obj.note '\r\n']);
%                 fprintf(fid,[obj.unit '\r\n']);
                fprintf(fid,string(obj.note)+ "\r\n");
                fprintf(fid,string(obj.unit)+ "\r\n");
            end
            
            separator='\t';%�ָ���
            
            for it=1:obj.numofpoint
                fprintf(fid,[sprintf('%0.5f',obj.tn(it)) separator sprintf('%0.8e',obj.accn(it))  '\r\n']);
            end
            fclose(fid);
        end
        function r=GetSimilarValue(obj,x)
            %��ȡ��x������ֵ
            if x<obj.tn(1) || x>obj.tn(end)
                error('������Χ')
            end
            if abs(x-obj.tn(end))<1e-8
                r=obj.accn(end);
                return
            end
            %�ҵ�x���µ�
            for i=1:length(obj.tn)
                if x<obj.tn(i)
                    r=LinearInterpolation(x,[obj.tn(i-1) obj.tn(i);obj.accn(i-1) obj.accn(i)]);
                    return
                end
            end
            error('sd')
        end
        function FillZeros(obj,endtime)%���������� endtime�ǽ�����ʱ��
            if endtime<obj.tn(end)
                error('endtime�����Ŀǰ����ʱ��')
            end
            dt=obj.tn(end)-obj.tn(end-1);
            t=obj.tn(end):dt:endtime;
            t(1)=[];%ɾ����һ��
            t=[t' zeros(length(t),1)];
            obj.tn=[obj.tn;t(:,1)];
            obj.accn=[obj.accn;t(:,2)];
        end
        function DrawPower(obj,logscale)%��ʾ����
            %���ʶ������£�
            %f(t)���ź� ����=f(t)^2
            %https://www.docin.com/p-629871284.html
            %������ʱ���ϵ E(t)=int(f(x)^2,x-inf,t) ���Թ���=diff(E,t)=f(t)^2
            t=cumtrapz(obj.tn,obj.accn.^2);
            t1=t;
            t1(2:end)=t1(2:end)-t(1:end-1);%��λ���
            figure
            plot(obj.tn,t1);
            title('����')
            if nargin==2 && logscale==1
                set(gca,'yscale','log')
            end
            
        end
    end
    methods(Static)
        function o=MakeSin(f,A,tend,dt,A0)
            %fʱ��Ƶ��
            %A��ֵ
            %tend����ʱ��
            %dtʱ����
            if nargin==4
                A0=0;
            end
            tn=[0:dt:tend]';
            accn=A*sin(2*pi*f*tn)+A0;
            
            o=EarthquakWave(tn,accn,'m/s^2','���Ҳ�');
        end
        function o=MakeConstant(A,tend,dt)%���ɺ㶨��
            tn=[0:dt:tend]';
            accn=A*ones(length(tn),1);
            o=EarthquakWave(tn,accn,'m/s^2','�㶨��');
        end
        function o=MakeTri(f,A,tend,dt,A0)%�������ǲ�
            if nargin==4
                A0=0;
            end
            T=1/f;
            tn=0:dt:tend;
            accn=zeros(1,length(tn));
            for i=1:length(tn)
                t=mod(tn(i),T);
                if t<0.25*T
                    accn(i)=LinearInterpolation1(t,[0 0;0.25*T 1]);
                elseif t<0.75*T
                    accn(i)=LinearInterpolation1(t,[0.25*T 1;0.75*T -1]);
                else
                    accn(i)=LinearInterpolation1(t,[0.75*T -1;T 0]);
                end
            end
            accn=accn*A+A0;
            o=EarthquakWave(tn,accn,'m/s^2','���ǲ�');
        end
        
        function obj=LoadFromFile1(note,unit,filename,fmt,lineomit,width,timeint)
            %width ָ���������ݵĳ���
            %timeint ָ��ʱ����
            obj=EarthquakWave();
            switch char(fmt)
                case 'acc'
                    dt=ReadTxt(filename,1,lineomit);
                    obj.accn=VectorDirection(dt);
                    obj.tn=[0:length(dt)-1]'*timeint;
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
        
    end
    
    
end

