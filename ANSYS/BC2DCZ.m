function r=BC2DCZ(A)
%将上三角矩阵补充成对称阵
len=size(A,1);
r=A;
for k=2:len
    for k1=1:k-1
        r(k,k1)=A(k1,k);
    end
end
end