function RowFilter(xlsname,sheetname,rowformat,targetcolname,targetdata,operation,newsheetname)
%对数据行进行筛选
%rowformat 1*3细胞 第一个是字段名所在行 第二个是注释行的行数 第三个是数据起始行数 从有内容的第一行数起
%targetcolname 目标字段名 字符串细胞
%targetdata 目标值 可以为多行 列数与目标字段名一一对应
%operation 操作方式 reserve 保留  ； exclude 删除
%newsheetname 新建表名
[~,~,raw]=xlsread(xlsname,sheetname);
colnames=raw(rowformat{1},:);%变量名字符串细胞
startrow=rowformat{3};%数据起始行
data=raw(startrow:end,:);%去除表头的真实数据
num_of_target_col=length(targetcolname);%目标字段名的个数
target_col_index=zeros(num_of_target_col,1);%目标字段名的索引
for it=1:num_of_target_col
    target_col_index(it)=GetColIndexByName(targetcolname{it},colnames);
end
row_number_hit=[];%命中的行索引
for rownumber=1:size(data,1)
    current_row=data(rownumber,:);
    current_target_col_value=current_row(1,target_col_index);
    if IsRowInRows(current_target_col_value,targetdata)
        row_number_hit=[row_number_hit rownumber];
    end
end
switch operation
    case 'reserve'
        newdata=data(row_number_hit,:);
        headerdata=raw(1:startrow-1,:);
        xlswrite(xlsname,[headerdata;newdata],newsheetname);
    case 'exclude'
        t=1:size(data,1);
        t(row_number_hit)=[];
        newdata=data(t,:);
        headerdata=raw(1:startrow-1,:);
        xlswrite(xlsname,[headerdata;newdata],newsheetname);
    otherwise
        error('未知类型')
end
end

function r=IsRowInRows(row,rows)
%判断row是否为rows中的一行
%row rows均为细胞
if size(row,2)~=size(rows,2)
    error('列数不一致')
end
if size(row,1)~=1
    error('row只能是一行')
end
for it=1:size(rows,1)
    if isequal(row,rows(it,:))
        r=true;
        return
    end
end
r=false;
end