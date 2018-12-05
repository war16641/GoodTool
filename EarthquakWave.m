classdef EarthquakWave<handle
    %UNTITLED2 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        tn%时间列向量
        accn%加速度列向量
        unit%加速度单位
        note%添加注释用
        numofpoint%点个数
        
        spectralvalue_sd%sd谱值 第一列表示周期 第二列表示谱值
        spectralvalue_psv
        spectralvalue_psa
    end
    
    methods
        function obj = EarthquakWave(tn0,accn0,unit,note)
            %unit 使用string
            %   此处显示详细说明
            if nargin==0%无参数
                obj.tn=[];
                obj.accn=[];
                obj.unit="m/s^2";%默认是m/s^2
                obj.note='';
                obj.spectralvalue_sd=[];%谱值变为0
                obj.spectralvalue_psa=[];
                obj.spectralvalue_psv=[];
                return;
            elseif nargin==2
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
            obj.spectralvalue_sd=[];%谱值变为0
            obj.spectralvalue_psa=[];
            obj.spectralvalue_psv=[];
        end
        function LoadFromFile(obj,note,unit,filename,fmt,lineomit,width,timeint)
            %width 指定单个数据的长度
            %timeint 指定时间间隔
            switch char(fmt)
                case 'time&acc'
                    dt=ReadTxt(filename,2,lineomit);
                    obj.tn=dt(:,1);
                    obj.accn=dt(:,2);

                case 'matrix1'%矩阵形式的地震波文件 需要把矩阵转化为列向量 格式使用分隔符
                    dt=ReadTxtWithMatrixFormat(filename,'split',lineomit);
                    obj.tn=[0:length(dt)-1]'*timeint;
                    obj.accn=dt;
                case 'matrix2'%矩阵形式的地震波文件 需要把矩阵转化为列向量 格式使用固定宽度
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
            %将单位化为标准单位
            if strcmp("m/s^2",obj.unit)
                return;
            end
            switch char(obj.unit)
                case 'gal'
                    obj.unit="m/s^2";
                    obj.accn=obj.accn/100;
                case 'g'
                    obj.unit="m/s^2";
                    obj.accn=obj.accn*9.816;%默认重力加速度为9.816m/s^2
                otherwise
                    error('sd');
            end
        end
        function Show(obj)
            %以图窗的形式 展示数据
            for it=1:length(obj)
                figure;
                plot(obj(it).tn,obj(it).accn);
                xlabel('time(s)');ylabel(['acceleration(' char(obj(it).unit)  ')']);title(obj(it).note);
            end
        end
        function disp(obj)
            [m,n]=size(obj);
            disp([num2str(m) '*' num2str(n) '个' class(obj)]);
            disp(' ')
            for it=1:length(obj)
                disp(['类型=' class(obj(it))]);
                disp(['内含' num2str(length(obj(it).tn)) '个点']);
                disp(['note=' char(obj(it).note)] );
                if isempty(obj(it).tn)
                    continue;
                end
                disp(['unit=' char(obj(it).unit)] );
                disp(['时间间隔（可能）=' num2str(obj(it).tn(2)-obj(it).tn(1))]);%时间序列可能不是等差数列
                disp(['结束时间=' num2str(obj(it).tn(end))]);
                disp(['峰值加速度=' num2str(AbsMax(obj(it).accn))]);
                disp(' ')
            end
            
        end
        function ResponseSpectra(obj,periodstart,periodend,type,dampratio,num,flag_draw)
            %获取反应谱
            % type 可选sd psv psa
            %dampratio阻尼比
            %num 是反应谱点个数
            %flag_draw表示是否要做图
            %检查单位是标准单位
            if ~strcmp("m/s^2",obj.unit)
                %error('单位不对，只能是m/s^2')
                obj.SwitchUnit();
            end
            if 5==nargin
                num=200;
                flag_draw=1;%默认做图
            elseif 6==nargin
                flag_draw=1;%默认做图
            elseif 7==nargin
                
            else
                error('未知参数类型')
            end
            
            m=1;
            pn=-m*obj.accn;
            period=linspace(periodstart,periodend,num);
            %准备数据格式
            switch type
                case 'sd'
                    obj.spectralvalue_sd=[period' zeros(num,1)];%相对位移谱
                case 'psv'
                    obj.spectralvalue_psv=[period' zeros(num,1)];%拟相对速度谱
                case 'psa'
                    obj.spectralvalue_psa=[period' zeros(num,1)];%拟加速度反应谱
                otherwise
                    error('sdddd')
            end
            
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
                        obj.spectralvalue_sd(it,2)=AbsMax(v,1);%相对位移谱
                    case 'psv'
                        obj.spectralvalue_psv(it,2)=AbsMax(dv,1);%拟相对速度谱
                    case 'psa'
                        obj.spectralvalue_psa(it,2)=AbsMax(ddv'+obj.accn,1);%拟加速度反应谱
                    otherwise
                        error('sdddd')
                end
                it=it+1;
            end
            
            if 1==flag_draw%要做图
                switch type
                    case 'sd'
                        figure
                        plot(obj.spectralvalue_sd(:,1),obj.spectralvalue_sd(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('周期/s');ylabel('谱值')
                    case 'psv'
                        figure
                        plot(obj.spectralvalue_psv(:,1),obj.spectralvalue_psv(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('周期/s');ylabel('谱值')
                    case 'psa'
                        figure
                        plot(obj.spectralvalue_psa(:,1),obj.spectralvalue_psa(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('周期/s');ylabel('谱值')
                    otherwise
                        error('sdddd')
                end
            
            end


        end
        function ResponseSpectra_Tn(obj,Tn,type,dampratio,flag_draw)
            %指定周期序列
            %获取反应谱
            % type 可选sd psv psa
            %dampratio阻尼比
            %num 是反应谱点个数
            %flag_draw表示是否要做图
            %检查单位是标准单位
            if ~strcmp("m/s^2",obj.unit)
                %error('单位不对，只能是m/s^2')
                obj.SwitchUnit();
            end
            if 4==nargin
                flag_draw=1;%默认做图
            elseif 5==nargin
            else
                error('未知参数类型')
            end
            
            m=1;
            pn=-m*obj.accn;
            period=Tn;
            num=length(Tn);
            %准备数据格式
            switch type
                case 'sd'
                    obj.spectralvalue_sd=[period' zeros(num,1)];%相对位移谱
                case 'psv'
                    obj.spectralvalue_psv=[period' zeros(num,1)];%拟相对速度谱
                case 'psa'
                    obj.spectralvalue_psa=[period' zeros(num,1)];%拟加速度反应谱
                otherwise
                    error('sdddd')
            end
            
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
                        obj.spectralvalue_sd(it,2)=AbsMax(v,1);%相对位移谱
                    case 'psv'
                        obj.spectralvalue_psv(it,2)=AbsMax(dv,1);%拟相对速度谱
                    case 'psa'
                        obj.spectralvalue_psa(it,2)=AbsMax(ddv'+obj.accn,1);%拟加速度反应谱
                    otherwise
                        error('sdddd')
                end
                it=it+1;
            end
            
            if 1==flag_draw%要做图
                switch type
                    case 'sd'
                        figure
                        plot(obj.spectralvalue_sd(:,1),obj.spectralvalue_sd(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('周期/s');ylabel('谱值')
                    case 'psv'
                        figure
                        plot(obj.spectralvalue_psv(:,1),obj.spectralvalue_psv(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('周期/s');ylabel('谱值')
                    case 'psa'
                        figure
                        plot(obj.spectralvalue_psa(:,1),obj.spectralvalue_psa(:,2));
                        title([type '-' char(obj.note)]);
                        xlabel('周期/s');ylabel('谱值')
                    otherwise
                        error('sdddd')
                end
            
            end


        end
        function [power,f]=PSD(obj,flag_draw)%功率谱
            %使用内置函数periodogram求功率谱估计，是一种估计、
            %我的使用观察经验：此函数会放小功率 以此代价来抹除噪声的影响。
            %使用要求：时间序列一定是等差数列 函数内部不会检查这个
            if nargin==1
                flag_draw=1;%默认做图
            end
            Fs=1/(obj.tn(2)-obj.tn(1));%用前两个数求频率
            [power,f]=periodogram(obj.accn,ones(length(obj.accn),1),length(obj.accn),Fs); %直接法
            if isequal(flag_draw,1)%做图
                figure;
                plot(f,power);
                set(gca,'yscale','log');%改为对数坐标
                xlabel('频率/Hz');
                ylabel('psd');
                title('psd');
            else
                %不做图
            end
        end
        function r=get.numofpoint(obj)
            r=length(obj.tn);
        end
        function StandardizeScale(obj)%标准化尺度 将地震波的峰值设为+1
            obj.SwitchUnit();
            tmp=AbsMax(obj.accn);
            obj.accn=obj.accn/tmp;
        end
        function AbandonHalf(obj)%舍弃一半的点
            tmp=2:2:obj.numofpoint;
            obj.tn(tmp)=[];
            obj.accn(tmp)=[];
        end
        function ReservePoint(obj,n)%保留前面n个点
            if n>obj.numofpoint
                return;
            end
            obj.tn=obj.tn(1:n);
            obj.accn=obj.accn(1:n);
        end
    end
    methods(Static)
        function o=MakeSin(f,A,tend,dt,A0)
            %f时间频率
            %A幅值
            %tend结束时间
            %dt时间间隔
            if nargin==4
                A0=0;
            end
            tn=[0:dt:tend]';
            accn=A*sin(2*pi*f*tn)+A0;
            
            o=EarthquakWave(tn,accn,'m/s^2','正弦波');
        end
        function o=MakeConstant(A,tend,dt)%生成恒定波
            tn=[0:dt:tend]';
            accn=A*ones(length(tn),1);
            o=EarthquakWave(tn,accn,'m/s^2','恒定波');
        end
    end
    
    
end

