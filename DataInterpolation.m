function [xx yy]=DataInterpolation(x,y,numadd)
%x y ���� Ԫ������
%numadd ÿһ���ڲ�ĵ��� �����ڲ�
%xx yy ������
xx=[];
yy=[];
for it=1:length(x)-1
    t=linspace(x(it),x(it+1),2+numadd);
    t(end)=[];
    r=LinearInterpolation(t,[x(it) x(it+1);y(it) y(it+1)]);
    xx=[xx t];
    yy=[yy r];
end
xx=[xx x(end)];yy=[yy y(end)];
xx=xx';
yy=yy';
end