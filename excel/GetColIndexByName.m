function r=GetColIndexByName(colname,colnames)
for it=1:length(colnames)
    if strcmp(colname,colnames{it})
        r=it;
        return;
    end
end
error("û�ҵ�");
end