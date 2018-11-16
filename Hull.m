function x=Hull(x)
%剥出外层的1*1 cell壳 直到x变成m*n的cell 或者内部不再是cell
if ~isa(x,'cell')
    warning('x不是cell')
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