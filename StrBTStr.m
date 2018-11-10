function [bigger,equal]=StrBTStr(s1,s2)
%按照unicode比较两个字符串的大小
len1=length(s1);
len2=length(s2);
for it=1:min([len1 len2])
    if s1(it)>s2(it)
        bigger=true;
        equal=false;
        return;
    elseif s1(it)<s2(it)
        bigger=false;
        equal=false;
        return;
    else
        continue;%比较下一个字符
    end
end

%前面的是一样的
if len1==len2
    bigger=false;
    equal=true;
    return;%字符串一样
elseif len1>len2%s1较短
    bigger=true;
    equal=false;
    return;
else %s2较短
    bigger=false;
    equal=false;
    return;
end
end