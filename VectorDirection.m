function r=VectorDirection(x,dir)
%ָ������x�ķ���
[m,n]=size(x);

%�վ���ֱ�ӷ���
if m==0||n==0
    r=x;
    return;
end

%m n�б���һ��1
if 1~=m&&1~=n
    error('����������')
end

if nargin==1
    dir='col';%Ĭ��������
end

r=x;

switch(dir)
    case 'col'%������
        if m==1
            r=x';
            return;
        end
    case 'row'%������
        if n==1
            r=x';
            return;
        end        
    otherwise
        error('d')
end



end