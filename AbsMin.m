function [r,i]=AbsMin(A,flag)
[~,i]=min(abs(A));
r=A(i);
if nargin==2&&flag==1%���ؾ���ֵ
    r=abs(r);
end
end