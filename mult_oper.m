function varargout=mult_oper(func,inputvars,index_of_varible,varargin)
%{
对inputvars中每一个变量执行func运算，index_of_varible为变量在func中参数的第几个位置，参数为varargin
inputvars必须为cell
实例：
[a,b]=mult_oper(@sin,{pi/6,pi/2},1)
%}
assert(isa(inputvars,'cell'),'类型错误');
assert(isa(index_of_varible,'numeric'),'类型错误');
nargoutchk(length(inputvars),length(inputvars));%输出个数必须与inputvars长度一致
for i=1:length(inputvars)
    cellin=insert_cell(varargin,inputvars{i},index_of_varible);
    varargout{i}=func(cellin{:});
end
end

function r=insert_cell(oldcell,newvar,index)
r={oldcell{1:index-1} newvar oldcell{index:end}};
end