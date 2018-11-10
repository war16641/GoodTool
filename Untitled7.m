x=linspace(0,20);
A=[0.05 -0.2 0.75 -0.51
   0.46 6.83 -15.65 8.44
   -0.11 0.68 -0.79 0.21];
len=length(x);
X=[x.^0 ;x;x.^2;x.^3];
Y=A*X;
figure;
plot(x,Y);
legend('1','2','3')