function angle=GetAngleFromVector(x,y)
%ͨ��һ����ά���� ��ȡ��������x������ļн� �Ƕȴ�x��ת��y��Ϊ��
if x==0&&y==0
    angle=0;warning('��Ч');
    return;
end
ratio=y/x;
angle=atan(abs(ratio));
if x>0&&y>=0
    return;
elseif x<=0&&y>0
    angle=pi-angle;
    return;
elseif x<0&&y<=0
    angle=angle+pi;
    return;
elseif x>=0&&y<0
    angle=-angle;
    return;
else 
    error('404');
end
end