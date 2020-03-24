function T=auto_correct_table(T)
%自动修正table
%修正内容：数字数组组成的cell，修正为组成矩阵
names=fieldnames(T);
for i=1:length(names)
    name=string(names{i});
    if name=='Row' || name=='Properties'||name=='Variables'%这几个字段名是table固定内置的 与实际内容无关
        continue;
    end
    col=T.(name);
    if isa(col,'cell')
        if isnumeric(col{1})%是数字组成的cell
            T.(name)=cell2mat(col);
        end
    end
end
end