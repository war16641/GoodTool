function r=MakeSymmetricMatrix(A)
%将输入一半的对称阵(上三角阵或者下三角阵) 补充成对称阵
len=size(A,1);
r=A;
for k1=1:len-1%行号
    for k2=k1+1:len%列号
        if r(k1,k2)==0
            r(k1,k2)=r(k2,k1);
        elseif A(k2,k1)==0
            r(k2,k1)=r(k1,k2);
        else
            error('对角线两边都有值')
        end
    end
end
end