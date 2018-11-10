function ColAdd_x(xlsname,sheetori,rowformat_ori,sheetadd,rowformat_add,collink,coladd,sheetafter)
%�����ֶ�
%���� ���Ӷ�ע���еĴ���
%xlsname excel�ļ���
%sheetori ԭʼ���ݱ�
%s1 �˱���ʵ������ʼ��
%sheetadd ���ӵ��ֶα� s2 ������ʼ��
%collink ԭʼ���ݱ�������ֶα� ���ӵ��ֶ���
%coladd  �ַ���ϸ�� ��Ҫ���ӵ��ֶ��� ���������ӱ���
%��ע���н��м�� 
if isempty(rowformat_ori{2})&&~isempty(rowformat_add{2})%����ӵı���ע���ж�ԭ��û�б���
    error('����ӵı���ע���ж�ԭ��û�б���');
end
if nargin==7
    sheetafter='�����';
end

%coladd��ʽ����
if isa(coladd,'char')
    coladd={coladd};
end

[~,~,raw1]=xlsread(xlsname,sheetori);
colnames1=raw1(rowformat_ori{1},:);
s1=rowformat_ori{3};%������ʼ��
data1=raw1(s1:end,:);
[~,~,raw2]=xlsread(xlsname,sheetadd);
colnames2=raw2(rowformat_add{1},:);
s2=rowformat_add{3};%������ʼ��
data2=raw2(s2:end,:);
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
%����ע���� 
if ~isempty(rowformat_ori{2})&&~isempty(rowformat_add{2})%�����ű���ע����
    noterow=[raw1(rowformat_ori{2},:) raw2(rowformat_add{2},indexadd)];
elseif ~isempty(rowformat_ori{2})&&isempty(rowformat_add{2})%��ԭ���� ��ӱ�û��
    noterow=[raw1(rowformat_ori{2},:)];
    t=cell(size(noterow,1),length(coladd));
    noterow=[noterow t];%���ӵı���ע����ȡΪ��ֵ
else isempty(rowformat_ori{2}) && isempty(rowformat_add{2});%��û��ע����
    noterow={};
end
xlswrite(xlsname,[colnames;noterow;data],sheetafter);
end