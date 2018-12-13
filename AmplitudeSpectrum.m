function [P,Pha,f]=AmplitudeSpectrum(vn,Fs)%���ֵ�� ��λ��
%vn ���� ���ݵ�
%fs ����Ƶ��
%P ��ֵ
%pha ��ʼ��λ
%f Ƶ��
L=length(vn);
if mod(L,2)==1
    L=L-1;%����һ�����ݵ� ���ż��
    vn=vn(1:L);
end
Y=fft(vn);
P=abs(Y/L);%���ֵ ˫����
P=P(1:L/2);
P=2*P;%������

f=(0:L-1)*Fs/L;%��Ƶ�� ˫���׵�
f=f(1:L/2);%�����׵�


Pha=angle(Y)+pi/2;%��ʼ��λ�� ˫����
Pha=Pha(1:L/2)/pi*180;%������

%����Ϊ��ͼ
figure
subplot(2,1,1);
plot(f,P);
xlabel('Ƶ��/Hz');
ylabel('��ֵ')

subplot(2,1,2);
plot(f,Pha);
xlabel('Ƶ��/Hz');
ylabel('��ʼ��λ/��')

end

%����Ϊ���Դ���
% Fs = 600;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
% L = 1500;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% S = 0.7*sin(2*pi*50*t+pi/4) + sin(2*pi*120*t);
% X = S + 2*randn(size(t));
% AmplitudeSpectrum(S,Fs)