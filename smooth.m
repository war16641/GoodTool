function r=smooth(x,n)
%对序列x平滑化处理 
%方法：取当期点附近2n+1个点的评价值
%n可以是0 不得超过length(x)的半
%始终返回列向量
num=length(x);
assert(ceil(num/2)>n,'n不得超过length(x)的半');
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