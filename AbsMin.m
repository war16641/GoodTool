function [r,i]=AbsMin(A,flag)
[~,i]=min(abs(A));
r=A(i);
if nargin==2&&flag==1%·µ»Ø¾ø¶ÔÖµ
    r=abs(r);
end
end