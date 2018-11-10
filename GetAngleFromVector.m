function angle=GetAngleFromVector(x,y)
%通过一个二维向量 获取此向量与x轴正向的夹角 角度从x轴转向y轴为正
if x==0&&y==0
    angle=0;warning('无效');
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