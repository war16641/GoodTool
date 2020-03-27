function [dX,ddX]=MyDifference(X,order,dt)
%差分求离散数据的导数
%差分方法 有限单元法 王 P477
%需要对数据X补充首尾数据 各一个 方法：让首尾端点的二阶导横为0，相当于直线拓展
%order导数阶数 dt时间间隔，默认为1
if nargin==1
    order=1;
    dt=1;%默认一阶导 dt为1
elseif nargin==2
    dt=1;
end
X=VectorDirection(X);
num=length(X);

%补首尾 一个数据点
t1=X(1)-(X(2)-X(1));
t2=X(end)+X(end)-X(end-1);
X=[t1;X;t2];

%求差分 一阶导
dX=zeros(num,1);
for i=2:length(X)-1
    dX(i-1)=(-X(i-1)+X(i+1))/2/dt;
end
    
if order==2
    ddX=zeros(num,1);
    for i=2:length(X)-1
        ddX(i-1)=(X(i-1)-2*X(i)+X(i+1))/dt^2;
    end
end
end