function [tn,v,dv,ddv]=SegmentalPrecision1_SDOF(k,m,tn,pn,type,value,v0,dv0)
%采用分段精确法 simpson法则计算粘滞阻尼下的 一般动力荷载下的 单自由度下的 初始时刻无位移无速度的 反应
%算法参见 克拉夫书 p75页
% k是刚度
% m是质量
% tn是时刻 等差数列 向量
% pn是对应tn的外荷载力 向量
deltat=tn(2)-tn(1);
w=sqrt(k/m);
N=length(tn);
v=zeros(1,N);dv=v;ddv=v;
v(1)=v0;dv(1)=dv0;
if strcmp('value',type)%定义阻尼值
    c=value;
    xi=c/2/m/w;
elseif strcmp('ratio',type)%定义阻尼比
    c=2*m*w*value;
    xi=value;
else
    error('');
end
syms t
for it=2:N
    p1=pn(it-1);
    n=(pn(it)-pn(it-1))/(tn(it)-tn(it-1));
    [v(it),dv(it),ddv(it)]=SecondOrderDifferentialEquation_Linear(k,m,c,p1,n,v(it-1),dv(it-1),tn(it)-tn(it-1));
end

end

% function [tn,v,dv,ddv]=SegmentalPrecision1_SDOF(k,m,tn,pn,type,value,v0,dv0)
% %采用分段精确法 simpson法则计算粘滞阻尼下的 一般动力荷载下的 单自由度下的 初始时刻无位移无速度的 反应
% %算法参见 克拉夫书 p75页
% % k是刚度
% % m是质量
% % tn是时刻 等差数列 向量
% % pn是对应tn的外荷载力 向量
% deltat=tn(2)-tn(1);
% w=sqrt(k/m);
% N=length(tn);
% v=zeros(1,N);dv=v;ddv=v;
% v(1)=v0;dv(1)=dv0;
% if 'value'==type%定义阻尼值
%     c=value;
%     xi=c/2/m/w;
% elseif 'ratio'==type%定义阻尼比
%     c=2*m*w*value;
%     xi=value;
% else
%     error('');
% end
% syms t
% for it=2:N
%     p1=pn(it-1);
%     n=(pn(it)-pn(it-1))/(tn(it)-tn(it-1));
%     vepr=SecondOrderDifferentialEquation_Linear(k,m,c,p1,n,v(it-1),dv(it-1));
%     dvepr=diff(vepr,t);
%     %ddvepr=diff(vepr,t,2);
%     v(it)=double(subs(vepr,t,tn(it)-tn(it-1)));
%     dv(it)=double(subs(dvepr,t,tn(it)-tn(it-1)));
%     %ddv(it)=double(subs(ddvepr,t,tn(it)-tn(it-1)));
%     ddv(it)=0;%不计算ddv
% end
% 
% end