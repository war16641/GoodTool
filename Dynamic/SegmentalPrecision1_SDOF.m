function [tn,v,dv,ddv]=SegmentalPrecision1_SDOF(k,m,tn,pn,type,value,v0,dv0)
%���÷ֶξ�ȷ�� simpson�������ճ�������µ� һ�㶯�������µ� �����ɶ��µ� ��ʼʱ����λ�����ٶȵ� ��Ӧ
%�㷨�μ� �������� p75ҳ
% k�Ǹն�
% m������
% tn��ʱ�� �Ȳ����� ����
% pn�Ƕ�Ӧtn��������� ����
deltat=tn(2)-tn(1);
w=sqrt(k/m);
N=length(tn);
v=zeros(1,N);dv=v;ddv=v;
v(1)=v0;dv(1)=dv0;
if strcmp('value',type)%��������ֵ
    c=value;
    xi=c/2/m/w;
elseif strcmp('ratio',type)%���������
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
% %���÷ֶξ�ȷ�� simpson�������ճ�������µ� һ�㶯�������µ� �����ɶ��µ� ��ʼʱ����λ�����ٶȵ� ��Ӧ
% %�㷨�μ� �������� p75ҳ
% % k�Ǹն�
% % m������
% % tn��ʱ�� �Ȳ����� ����
% % pn�Ƕ�Ӧtn��������� ����
% deltat=tn(2)-tn(1);
% w=sqrt(k/m);
% N=length(tn);
% v=zeros(1,N);dv=v;ddv=v;
% v(1)=v0;dv(1)=dv0;
% if 'value'==type%��������ֵ
%     c=value;
%     xi=c/2/m/w;
% elseif 'ratio'==type%���������
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
%     ddv(it)=0;%������ddv
% end
% 
% end