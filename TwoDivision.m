function r=TwoDivision(fun_handle,con,tol,a,b)
%���ַ������
    function r=fun(xx)
        r=fun_handle(xx)-con;
    end
p=-1;
while (fun(a)*fun(b) <=0) && (abs(a-b)>tol)
    c=(a+b)/2;
    if fun(c)*fun(b)<=0
        a=c;
        p=p+1;
    else
        p=p+1;
        b=c;
    end
end
% sprintf('���ִ���Ϊ:%d',p)
% sprintf('�������Ϊ:%f,%f,���Ϊ:%f',a,b,(a+b)/2 )
r=(a+b)/2 ;
end


