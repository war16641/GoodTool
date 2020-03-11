%线性插值法  从LinearInterpolation改过来 改变了输入的endpoint格式
%goal 是目标x
%endpoint是两个端点的坐标 x1 y1;x2 y2
function r=LinearInterpolation1(goal,endpoint)
% k=(endpoint(2,2)-endpoint(2,1))/(endpoint(1,2)-endpoint(1,1));
% % [m,n]=size(goal);
% r=endpoint(2,1)+k*(goal-endpoint(1,1));
p=polyfit(endpoint(:,1),endpoint(:,2),1);
r=polyval(p,goal);
end