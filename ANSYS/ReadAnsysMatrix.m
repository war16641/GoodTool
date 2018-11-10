function [K,M,C]=ReadAnsysMatrix()
%һ����ͬʱ������������
if nargout==1
    [K,~]=HBFILEREAD('stiff.txt');
elseif nargout==2[K,~]=HBFILEREAD('stiff.txt');
[M,~]=HBFILEREAD('mass.txt');
elseif nargout==3
    [K,~]=HBFILEREAD('stiff.txt');
[M,~]=HBFILEREAD('mass.txt');
[C,~]=HBFILEREAD('damp.txt');
end

end
function [K,F]=HBFILEREAD(filename)
%��ȡansys hbmat�������ɵ�����նȾ���
%������նȾ��� �Գ�����������
fidin=fopen(filename);
numline=0;%��¼tline������һ��
header=zeros(1,5);

numline=numline+1;
tline=fgetl(fidin);

numline=numline+1;
tline=fgetl(fidin);

cdstr=StrSplit(tline,' ');
for k=1:5
    header(k)=str2num(cdstr{k});
end
K=zeros(header(5),header(5));
F=zeros(header(5),1);

numline=numline+1;
tline=fgetl(fidin);
numline=numline+1;
tline=fgetl(fidin);
numline=numline+1;
tline=fgetl(fidin);

data2=zeros(1,header(2));
data3=zeros(1,header(3));
data4=zeros(1,header(4));
for k=1:header(2)
    numline=numline+1;
    tline=fgetl(fidin);
    data2(k)=str2double(tline);
end
for k=1:header(3)
    numline=numline+1;
    tline=fgetl(fidin);
    data3(k)=str2double(tline);
end
for k=1:header(4)
    numline=numline+1;
    tline=fgetl(fidin);
    t=strfind(tline,'D');
    tline(t)='E';
    data4(k)=str2double(tline);
end
for k=1:header(5)
    numline=numline+1;
    tline=fgetl(fidin);
    t=strfind(tline,'D');
    tline(t)='E';
    F(k)=str2double(tline);
end

for hang=1:header(2)-1
    for k=1:data2(hang+1)-data2(hang)%��һ���еĸ���
        K(hang,data3(data2(hang)+k-1))=data4(data2(hang)+k-1);
    end
end

    
K=BC2DCZ(K);

end