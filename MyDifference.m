function [dX,ddX]=MyDifference(X,order,dt)
%�������ɢ���ݵĵ���
%��ַ��� ���޵�Ԫ�� �� P477
%��Ҫ������X������β���� ��һ�� ����������β�˵�Ķ��׵���Ϊ0���൱��ֱ����չ
%order�������� dtʱ������Ĭ��Ϊ1
if nargin==1
    order=1;
    dt=1;%Ĭ��һ�׵� dtΪ1
elseif nargin==2
    dt=1;
end
X=VectorDirection(X);
num=length(X);

%����β һ�����ݵ�
t1=X(1)-(X(2)-X(1));
t2=X(end)+X(end)-X(end-1);
X=[t1;X;t2];

%���� һ�׵�
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