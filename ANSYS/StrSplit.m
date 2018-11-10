function cdstr=StrSplit(str,sptr)
%split函数
%参数是 原字符串；分隔符
%输出的是:细胞 每一个细胞含一个字符串
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