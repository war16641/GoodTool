function r=smooth(x,n)
%������xƽ�������� 
%������ȡ���ڵ㸽��2n+1���������ֵ
%n������0 ���ó���length(x)�İ�
%ʼ�շ���������
num=length(x);
assert(ceil(num/2)>n,'n���ó���length(x)�İ�');
r=zeros(num,1);
for it=n+1:num-n
    r(it)=mean(x(it-n:it+n));
end
w=-1;
for it=1:n
    w=w+1;
    r(it)=mean(x(it-(w):it+(w)));
end
w=n;
for it=num-n+1:num
    w=w-1;
    r(it)=mean(x(it-(w):it+(w)));
    
end
end