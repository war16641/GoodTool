function structs=table_to_structs(T)
%��tableת��һά�ṹ������
%����ʹ�����ú���table2strcut
structs=[];
vns=T.Properties.VariableNames;
for i=1:size(T,1)
    t=struct();
    for i2=1:length(vns)
        tp=T{i,i2};
        if isa(tp,'cell') && length(tp)==1 %�ַ�������table����1*1 cell��ʽ����
            tp=tp{1}; %ȥ��cell��
        end
        t.(vns{i2})=tp;
    end
    structs=[structs t];
end
end