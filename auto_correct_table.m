function T=auto_correct_table(T)
%�Զ�����table
%�������ݣ�����������ɵ�cell������Ϊ��ɾ���
names=fieldnames(T);
for i=1:length(names)
    name=string(names{i});
    if name=='Row' || name=='Properties'||name=='Variables'%�⼸���ֶ�����table�̶����õ� ��ʵ�������޹�
        continue;
    end
    col=T.(name);
    if isa(col,'cell')
        if isnumeric(col{1})%��������ɵ�cell
            T.(name)=cell2mat(col);
        end
    end
end
end