function r=VectorDirection(x)
%将向量转化为列向量
[m,n]=size(x);
if m==1
    r=x';
elseif n==1
    r=x;
else
    error('为矩阵，不能转化为列向量')
end
end