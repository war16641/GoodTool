function r=FindPeaks(x)
%Ѱ������x�ļ�ֵ��
x=ColumnVector(x);
y=[x(1) ;x(1:end-1)];
d=x-y;
r=[];
last=sign(d(1));
for it=2:length(x)
    this=sign(d(it));
    if this*last==-1
        r=[r;x(it)];
    end
    if this~=0
        last=this;
    end
end
if isempty(r)
    r=x(end);
    warning('��������')
end
end