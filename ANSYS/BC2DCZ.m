function r=BC2DCZ(A)
%�������Ǿ��󲹳�ɶԳ���
len=size(A,1);
r=A;
for k=2:len
    for k1=1:k-1
        r(k,k1)=A(k1,k);
    end
end
end