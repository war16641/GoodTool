function [m j1 j2 j3]=CalculateCuboidMassProperty(x,y,z,rou)
%计算长方体的质量和绕x y z的转动惯量
%x y z是三个方向上的尺寸
%rou是密度
m=x*y*z*rou;
j1=m/12*(y^2+z^2);
j2=m/12*(x^2+z^2);
j3=m/12*(y^2+x^2);
disp(['承台质量=' num2str(round(m)) '转动惯量=' num2str(round(j1)) ',' num2str(round(j2)) ',' num2str(round(j3))  ])
end