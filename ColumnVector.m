function r=VectorDirection(x)
%������ת��Ϊ������
[m,n]=size(x);
if m==1
    r=x';
elseif n==1
    r=x;
else
    error('Ϊ���󣬲���ת��Ϊ������')
end
end