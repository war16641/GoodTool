function ColAdd(xlsname,sheetori,s1,sheetadd,s2,collink,coladd,sheetafter)
%增加字段
%xlsname excel文件名
%sheetori 原始数据表
%s1 此表真实数据起始行
%sheetadd 增加的字段表 s2 数据起始行
%collink 原始数据表和增加字段表 连接的字段名
%coladd  字符串细胞 需要增加的字段名 必须在增加表中
if nargin==7
    sheetafter='处理后';
end
[~,~,raw]=xlsread(xlsname,sheetori);
colnames1=raw(1,:);
data1=raw(s1:end,:);
[~,~,raw]=xlsread(xlsname,sheetadd);
colnames2=raw(1,:);
data2=raw(s2:end,:);
numcolori=length(colnames1);
numcoladd=length(coladd);
numdata=size(data1,1);%数据行数
data=[data1 cell(numdata,numcoladd)];
i1=GetColIndexByName(collink,colnames1);
i2=GetColIndexByName(collink,colnames2);
indexadd=zeros(length(coladd),1);
for it=1:length(coladd)
    [~,in]=IsIn(coladd{it},colnames2);
    indexadd(it)=in;
end

for it=1:numdata
    thisv=data1{it,i1};
    [flag,in]=IsIn(thisv,data2(:,i2));
    if 1==flag
        data(it,numcolori+1:end)=data2(in,indexadd);
        continue;
    else
        error("")
    end
end
colnames=[colnames1 colnames2(indexadd)];
xlswrite(xlsname,[colnames;data],sheetafter);
end