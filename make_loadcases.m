function T=make_loadcases(varargin)%�����걸�����鹤����
%��������Ϊfield,values�� ���޶���
%fieldΪ�ֶ��� valuesΪȡֵ����������ֵ���������ַ�����

assert(~mod(nargin,2),'����Ϊż��������');


%������һ���ֶ�
T=[];
first_filed=varargin{1};
first_values=varargin{2};
for i=1:length(first_values)
    dic=struct();
    t=first_values(i);
    if isa(t,'cell')
        t=t{1};%���first_values���ַ����飬��Ҫ����������
    end
    dic.(first_filed)=t;%����ֶ�
    T=[T dic];%��ӽ���
end
if length(varargin)>2%���������ֶ�
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
            t=t{1};%���first_values���ַ����飬��Ҫ����������
        end
        nowTV.(first_filed)=t;%����ֶ�
        TVx=[TVx nowTV];%��ӽ���
    end
end
if length(varargin)>2%���������ֶ�
    TVout=script(TVx,varargin{3:end});
else
    TVout=TVx;
end
end