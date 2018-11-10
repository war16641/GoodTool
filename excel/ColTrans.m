function ColTrans(xlsname,sheetori,s1,sheettr,s2,colori,coltr)
%�ֶζ�Ӧ��ϵת��
%xlsname excel�ļ���
%sheetori ��ת�� ����
%s1 �˱���ʵ������ʵ��
%sheettr ת����ϵ�� s2 ������ʼ��
%colori coltr ��ת���ֶ��� �� ת�����ֶ���
dbstop if error
[~,~,raw]=xlsread(xlsname,sheetori);
colnames1=raw(1,:);
data1=raw(s1:end,:);
[~,~,raw]=xlsread(xlsname,sheettr);
colnames2=raw(1,:);
data2=raw(s2:end,:);
i1=GetColIndexByName(colori,colnames1);
i2=GetColIndexByName(colori,colnames2);
i3=GetColIndexByName(coltr,colnames2);
for it=1:size(data1,1)
    thisv=data1{it,i1};
    [flag,in]=IsIn(thisv,data2(:,i2));
    if 1==flag
        data1(it,i1)=data2(in,i3);
        continue;
    else
        %error("404")%�Ҳ����ͱ���
        data1{it,i1}=0;%�Ҳ�����0����
    end
end
colnames1(i1)=colnames2(i3);
xlswrite(xlsname,[colnames1;data1],'�����');
end