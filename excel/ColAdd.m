function ColAdd(xlsname,sheetori,s1,sheetadd,s2,collink,coladd,sheetafter)
%�����ֶ�
%xlsname excel�ļ���
%sheetori ԭʼ���ݱ�
%s1 �˱���ʵ������ʼ��
%sheetadd ���ӵ��ֶα� s2 ������ʼ��
%collink ԭʼ���ݱ�������ֶα� ���ӵ��ֶ���
%coladd  �ַ���ϸ�� ��Ҫ���ӵ��ֶ��� ���������ӱ���
if nargin==7
    sheetafter='�����';
end
[~,~,raw]=xlsread(xlsname,sheetori);
colnames1=raw(1,:);
data1=raw(s1:end,:);
[~,~,raw]=xlsread(xlsname,sheetadd);
colnames2=raw(1,:);
data2=raw(s2:end,:);
numcolori=length(colnames1);
numcoladd=length(coladd);
numdata=size(data1,1);%��������
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