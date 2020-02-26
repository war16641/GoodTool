function varargout=mult_oper(func,inputvars,varargin)
%{
��inputvars��ÿһ������ִ��func���㣬����Ϊvarargin
inputvars����Ϊcell
ʵ����
[a,b]=mult_oper(@sin,{pi/6,pi/2})
%}
assert(isa(inputvars,'cell'),'���ʹ���');
nargoutchk(length(inputvars),length(inputvars));%�������������inputvars����һ��
for i=1:length(inputvars)
    varargout{i}=func(inputvars{i},varargin{:});
end
end