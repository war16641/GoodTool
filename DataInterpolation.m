function [xx yy]=DataInterpolation(x,y,numadd)
%x y 向量 元素数据
%numadd 每一段内插的点数 线性内插
%xx yy 列向量
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