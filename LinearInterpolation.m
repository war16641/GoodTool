%���Բ�ֵ�� 
%goal ��Ŀ��x
%endpoint�������˵������ x1 x2;y1 y2
function r=LinearInterpolation(goal,endpoint)
k=(endpoint(2,2)-endpoint(2,1))/(endpoint(1,2)-endpoint(1,1));
% [m,n]=size(goal);
r=endpoint(2,1)+k*(goal-endpoint(1,1));
end