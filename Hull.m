function x=Hull(x)
%��������1*1 cell�� ֱ��x���m*n��cell �����ڲ�������cell
if ~isa(x,'cell')
    warning('x����cell')
    return;
end
while 1
    [m,n]=size(x);

    if isa(x{1},'cell')&&m==1&&n==1
        x=x{1};
    else
        break;
    end
end
end