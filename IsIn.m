function [r,index]=IsIn(a,A)%�ж���� a�ǲ���ΪA����A�е�һ��Ԫ��
classa=class(a);
classA=class(A);
index=0;
%��AΪ�� 
if isempty(A)
    r=false();
    return;
end
if strcmp(classA,'cell')&&isnumeric(A{1})%��������ɵ�ϸ��ת��Ϊ����
    A=cell2mat(A);
    classA=class(A);
end
if strcmp(classa,'double') && strcmp(classA,'double')%������
    for it=1:length(A)
        if A(it)==a
            r=logical(1);
            index=it;
            return;
        end
    end
    r=logical(0);
    return;
end
if strcmp(classa,'char') &&strcmp(classA,'char')%�����ַ������ַ���
    if length(a)==1%a���ַ�
        if sum(a==A)>=1
            r=1;
            index=find(a==A);
            return;
        else
            r=0;
            return ;
        end
    end
    %a A�����ַ���
    if strcmp(a,A)
        index=1;
        r=logical(1);
        return;
    end
    r=logical(0);
    return;
end
if strcmp(classa,'char') &&strcmp(classA,'cell')&&strcmp(class(A{1}),'char')%a���ַ��� A���ַ���ϸ��
    for it=1:length(A)
        if strcmp(a,A{it})
            index=it;
            r=logical(1);return;
        end
    end
    r=logical(0);return;
end
error("δ֪a A����");
end