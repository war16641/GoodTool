function ColAdd_x(xlsname,sheetori,rowformat_ori,sheetadd,rowformat_add,collink,coladd,sheetafter)
%增加字段
%修正 增加对注释行的处理
%xlsname excel文件名
%sheetori 原始数据表
%s1 此表真实数据起始行
%sheetadd 增加的字段表 s2 数据起始行
%collink 原始数据表和增加字段表 连接的字段名
%coladd  字符串细胞 需要增加的字段名 必须在增加表中
%对注释行进行检查 
if isempty(rowformat_ori{2})&&~isempty(rowformat_add{2})%当添加的表有注释行而原表没有报错
    error('当添加的表有注释行而原表没有报错');
end
if nargin==7
    sheetafter='处理后';
end

%coladd格式调整
if isa(coladd,'char')
    coladd={coladd};
end

[~,~,raw1]=xlsread(xlsname,sheetori);
colnames1=raw1(rowformat_ori{1},:);
s1=rowformat_ori{3};%数据起始行
data1=raw1(s1:end,:);
[~,~,raw2]=xlsread(xlsname,sheetadd);
colnames2=raw2(rowformat_add{1},:);
s2=rowformat_add{3};%数据起始行
data2=raw2(s2:end,:);
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
%处理注释行 
if ~isempty(rowformat_ori{2})&&~isempty(rowformat_add{2})%当两张表都有注释行
    noterow=[raw1(rowformat_ori{2},:) raw2(rowformat_add{2},indexadd)];
elseif ~isempty(rowformat_ori{2})&&isempty(rowformat_add{2})%当原表有 添加表没有
    noterow=[raw1(rowformat_ori{2},:)];
    t=cell(size(noterow,1),length(coladd));
    noterow=[noterow t];%增加的变量注释行取为空值
else isempty(rowformat_ori{2}) && isempty(rowformat_add{2});%都没有注释行
    noterow={};
end
xlswrite(xlsname,[colnames;noterow;data],sheetafter);
end