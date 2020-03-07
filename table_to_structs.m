function structs=table_to_structs(T)
%把table转成一维结构体数组
%建议使用内置函数table2strcut
structs=[];
vns=T.Properties.VariableNames;
for i=1:size(T,1)
    t=struct();
    for i2=1:length(vns)
        tp=T{i,i2};
        if isa(tp,'cell') && length(tp)==1 %字符串会在table中以1*1 cell形式保存
            tp=tp{1}; %去除cell套
        end
        t.(vns{i2})=tp;
    end
    structs=[structs t];
end
end