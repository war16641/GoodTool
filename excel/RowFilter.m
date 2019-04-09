function RowFilter(xlsname,sheetname,rowformat,targetcolname,targetdata,operation,newsheetname)
%�������н���ɸѡ
%rowformat 1*3ϸ�� ��һ�����ֶ��������� �ڶ�����ע���е����� ��������������ʼ���� �������ݵĵ�һ������
%targetcolname Ŀ���ֶ��� �ַ���ϸ��
%targetdata Ŀ��ֵ ����Ϊ���� ������Ŀ���ֶ���һһ��Ӧ
%operation ������ʽ reserve ����  �� exclude ɾ��
%newsheetname �½�����
[~,~,raw]=xlsread(xlsname,sheetname);
colnames=raw(rowformat{1},:);%�������ַ���ϸ��
startrow=rowformat{3};%������ʼ��
data=raw(startrow:end,:);%ȥ����ͷ����ʵ����
num_of_target_col=length(targetcolname);%Ŀ���ֶ����ĸ���
target_col_index=zeros(num_of_target_col,1);%Ŀ���ֶ���������
for it=1:num_of_target_col
    target_col_index(it)=GetColIndexByName(targetcolname{it},colnames);
end
row_number_hit=[];%���е�������
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
        error('δ֪����')
end
end

function r=IsRowInRows(row,rows)
%�ж�row�Ƿ�Ϊrows�е�һ��
%row rows��Ϊϸ��
if size(row,2)~=size(rows,2)
    error('������һ��')
end
if size(row,1)~=1
    error('rowֻ����һ��')
end
for it=1:size(rows,1)
    if isequal(row,rows(it,:))
        r=true;
        return
    end
end
r=false;
end