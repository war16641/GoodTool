function [v,dv,ddv]=SecondOrderDifferentialEquation_Linear(k,m,c,p1,n,v0,dv0,tend)
%n是N/s p1是N
if c^2>=4*m*k
    error('不是小阻尼')
end
r=(-c+sqrt(c^2-4*m*k))/2/m;
alpha=real(r);beta=imag(r);
c1=(v0*k^2 - p1*k + c*n)/k^2;
c2=-(k*n - dv0*k^2 + alpha*k^2*v0 + alpha*c*n - alpha*k*p1)/(beta*k^2);
if nargin==8%输出端点值
    v=exp(alpha*tend)*(c1*cos(beta*tend)+c2*sin(beta*tend))+(k*p1-c*n)/k^2+n/k*tend;
    dv=n/k + exp(alpha*tend)*(beta*c2*cos(beta*tend) - beta*c1*sin(beta*tend)) + alpha*exp(alpha*tend)*(c1*cos(beta*tend) + c2*sin(beta*tend));
    ddv=2*alpha*exp(alpha*tend)*(beta*c2*cos(beta*tend) - beta*c1*sin(beta*tend)) - exp(alpha*tend)*(beta^2*c1*cos(beta*tend) + beta^2*c2*sin(beta*tend)) + alpha^2*exp(alpha*tend)*(c1*cos(beta*tend) + c2*sin(beta*tend));
    return;
elseif nargin==7%输出解析式
    syms t
    v=exp(alpha*t)*(c1*cos(beta*t)+c2*sin(beta*t))+(k*p1-c*n)/k^2+n/k*t;
    dv=0;ddv=0;
else
    error('');
end

end