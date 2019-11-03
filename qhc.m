function r=qhc(xv)
%后退 坐标系 通过x坐标求弧长 向右的x为正
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