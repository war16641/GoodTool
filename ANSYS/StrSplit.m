function cdstr=StrSplit(str,sptr)
%split����
%������ ԭ�ַ������ָ���
%�������:ϸ�� ÿһ��ϸ����һ���ַ���
index=strfind(str,sptr);
indexlast=1;
cdstr={};
for k=1:length(index)
    if index(k)>indexlast
        t=str(indexlast:index(k)-1);
        cdstr=[cdstr t];
        indexlast=index(k)+1;
    elseif index(k)==indexlast
        indexlast=indexlast+1;
    end
end
if indexlast<=length(str)
    cdstr=[cdstr str(indexlast:end)];
end
end