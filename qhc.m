function r=qhc(xv)
%���� ����ϵ ͨ��x�����󻡳� ���ҵ�xΪ��
persistent hc
syms t
if isempty(hc)
    syms x
    y=-0.0103858*(-x-36)^2+13.46;
    dy=diff(y);
    jfs=sqrt(1+dy^2);
    
    hc=int(jfs,x,0,t);
    hc=vpa(hc,10);
end
r=subs(hc,t,xv);
r=vpa(r,8);
end