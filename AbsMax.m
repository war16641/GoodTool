function [r,i]=AbsMax(A,flag)
[~,i]=max(abs(A));
r=A(i);
if nargin==2&&flag==1%���ؾ���ֵ
    r=abs(r);
end
end