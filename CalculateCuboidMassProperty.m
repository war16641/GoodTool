function [m j1 j2 j3]=CalculateCuboidMassProperty(x,y,z,rou)
%���㳤�������������x y z��ת������
%x y z�����������ϵĳߴ�
%rou���ܶ�
m=x*y*z*rou;
j1=m/12*(y^2+z^2);
j2=m/12*(x^2+z^2);
j3=m/12*(y^2+x^2);
disp(['��̨����=' num2str(round(m)) 'ת������=' num2str(round(j1)) ',' num2str(round(j2)) ',' num2str(round(j3))  ])
end