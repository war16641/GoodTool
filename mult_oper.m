function varargout=mult_oper(func,inputvars,varargin)
%{
对inputvars中每一个变量执行func运算，参数为varargin
inputvars必须为cell
实例：
[a,b]=mult_oper(@sin,{pi/6,pi/2})
%}
assert(isa(inputvars,'cell'),'类型错误');
nargoutchk(length(inputvars),length(inputvars));%输出个数必须与inputvars长度一致
for i=1:length(inputvars)
    varargout{i}=func(inputvars{i},varargin{:});
end
end