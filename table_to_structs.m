function structs=table_to_structs(T)
%��tableת��һά�ṹ������
structs=[];
vns=T.Properties.VariableNames;
for i=1:size(T,1)
    t=struct();
    for i2=1:length(vns)
        t.(vns{i2})=T{i,i2};
    end
    structs=[structs t];
end
end