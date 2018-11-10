function r=VectorDirection(x,dir)
%指定向量x的方向
[m,n]=size(x);

%空矩阵直接返回
if m==0||n==0
    r=x;
    return;
end

%m n中必有一个1
if 1~=m&&1~=n
    error('并非是向量')
end

if nargin==1
    dir='col';%默认列向量
end

r=x;

switch(dir)
    case 'col'%列向量
        if m==1
            r=x';
            return;
        end
    case 'row'%行向量
        if n==1
            r=x';
            return;
        end        
    otherwise
        error('d')
end



end