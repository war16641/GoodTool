function [bigger,equal]=StrBTStr(s1,s2)
%����unicode�Ƚ������ַ����Ĵ�С
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
        continue;%�Ƚ���һ���ַ�
    end
end

%ǰ�����һ����
if len1==len2
    bigger=false;
    equal=true;
    return;%�ַ���һ��
elseif len1>len2%s1�϶�
    bigger=true;
    equal=false;
    return;
else %s2�϶�
    bigger=false;
    equal=false;
    return;
end
end