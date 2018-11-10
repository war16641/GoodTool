function [K,F]=HBFILEREAD()
%读取ansys hbmat命令生成的总体刚度矩阵
%输出：刚度矩阵 对称阵；力列向量
fidin=fopen('file.txt');
numline=0;%记录tline属于哪一行
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
    for k=1:data2(hang+1)-data2(hang)%这一行有的个数
        K(hang,data3(data2(hang)+k-1))=data4(data2(hang)+k-1);
    end
end

    
K=BC2DCZ(K);

end