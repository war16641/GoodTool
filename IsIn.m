function [r,index]=IsIn(a,A)%判断相等 a是不是为A或者A中的一个元素
classa=class(a);
classA=class(A);
index=0;
%若A为空 
if isempty(A)
    r=false();
    return;
end
if strcmp(classA,'cell')&&isnumeric(A{1})%将数字组成的细胞转换为矩阵
    A=cell2mat(A);
    classA=class(A);
end
if strcmp(classa,'double') && strcmp(classA,'double')%都是数
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
if strcmp(classa,'char') &&strcmp(classA,'char')%都是字符或者字符串
    if length(a)==1%a是字符
        if sum(a==A)>=1
            r=1;
            index=find(a==A);
            return;
        else
            r=0;
            return ;
        end
    end
    %a A都是字符串
    if strcmp(a,A)
        index=1;
        r=logical(1);
        return;
    end
    r=logical(0);
    return;
end
if strcmp(classa,'char') &&strcmp(classA,'cell')&&strcmp(class(A{1}),'char')%a是字符串 A是字符串细胞
    for it=1:length(A)
        if strcmp(a,A{it})
            index=it;
            r=logical(1);return;
        end
    end
    r=logical(0);return;
end
error("未知a A类型");
end