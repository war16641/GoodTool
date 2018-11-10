function ColTrans(xlsname,sheetori,s1,sheettr,s2,colori,coltr)
%字段对应关系转换
%xlsname excel文件名
%sheetori 被转换 表名
%s1 此表真实数据其实行
%sheettr 转换关系表 s2 数据起始行
%colori coltr 被转换字段名 和 转换后字段名
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
        %error("404")%找不到就报错
        data1{it,i1}=0;%找不到用0代替
    end
end
colnames1(i1)=colnames2(i3);
xlswrite(xlsname,[colnames1;data1],'处理后');
end