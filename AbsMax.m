function [r,i]=AbsMax(A,flag)
[~,i]=max(abs(A));
r=A(i);
if nargin==2&&flag==1%·µ»Ø¾ø¶ÔÖµ
    r=abs(r);
end
end