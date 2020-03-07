function T=make_loadcases(varargin)%制作完备的试验工况表
%参数输入为field,values对 不限对数
%field为字段名 values为取值，可以是数值向量或者字符串组

assert(~mod(nargin,2),'必须为偶数个参数');


%制作第一个字段
T=[];
first_filed=varargin{1};
first_values=varargin{2};
for i=1:length(first_values)
    dic=struct();
    t=first_values(i);
    if isa(t,'cell')
        t=t{1};%如果first_values是字符串组，需要剥除花括号
    end
    dic.(first_filed)=t;%添加字段
    T=[T dic];%添加进组
end
if length(varargin)>2%还有其他字段
    T=script(T,varargin{3:end});
end
end
function TVout=script(TV,varargin)
TVx=[];
first_filed=varargin{1};
first_values=varargin{2};
for i=1:length(TV)
    nowTV=TV(i);
    for ii=1:length(first_values)
        t=first_values(ii);
        if isa(t,'cell')
            t=t{1};%如果first_values是字符串组，需要剥除花括号
        end
        nowTV.(first_filed)=t;%添加字段
        TVx=[TVx nowTV];%添加进组
    end
end
if length(varargin)>2%还有其他字段
    TVout=script(TVx,varargin{3:end});
else
    TVout=TVx;
end
end