function r=MakeSymmetricMatrix(A)
%������һ��ĶԳ���(�������������������) ����ɶԳ���
len=size(A,1);
r=A;
for k1=1:len-1%�к�
    for k2=k1+1:len%�к�
        if r(k1,k2)==0
            r(k1,k2)=r(k2,k1);
        elseif A(k2,k1)==0
            r(k2,k1)=r(k1,k2);
        else
            error('�Խ������߶���ֵ')
        end
    end
end
end