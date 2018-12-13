function [P,Pha,f]=AmplitudeSpectrum(vn,Fs)%求幅值谱 相位谱
%vn 向量 数据点
%fs 采样频率
%P 幅值
%pha 初始相位
%f 频率
L=length(vn);
if mod(L,2)==1
    L=L-1;%舍弃一个数据点 变成偶数
    vn=vn(1:L);
end
Y=fft(vn);
P=abs(Y/L);%求幅值 双边谱
P=P(1:L/2);
P=2*P;%单边谱

f=(0:L-1)*Fs/L;%求频率 双边谱的
f=f(1:L/2);%单边谱的


Pha=angle(Y)+pi/2;%初始相位角 双边谱
Pha=Pha(1:L/2)/pi*180;%单边谱

%以下为做图
figure
subplot(2,1,1);
plot(f,P);
xlabel('频率/Hz');
ylabel('幅值')

subplot(2,1,2);
plot(f,Pha);
xlabel('频率/Hz');
ylabel('初始相位/°')

end

%以下为测试代码
% Fs = 600;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 1500;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% S = 0.7*sin(2*pi*50*t+pi/4) + sin(2*pi*120*t);
% X = S + 2*randn(size(t));
% AmplitudeSpectrum(S,Fs)