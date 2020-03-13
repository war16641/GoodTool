function varargout=mult_oper(func,inputvars,index_of_varible,varargin)
%{
��inputvars��ÿһ������ִ��func���㣬index_of_varibleΪ������func�в����ĵڼ���λ�ã�����Ϊvarargin
inputvars����Ϊcell
ʵ����
[a,b]=mult_oper(@sin,{pi/6,pi/2},1)
%}
assert(isa(inputvars,'cell'),'���ʹ���');
assert(isa(index_of_varible,'numeric'),'���ʹ���');
nargoutchk(length(inputvars),length(inputvars));%�������������inputvars����һ��
for i=1:length(inputvars)
    cellin=insert_cell(varargin,inputvars{i},index_of_varible);
    varargout{i}=func(cellin{:});
end
end

function r=insert_cell(oldcell,newvar,index)
r={oldcell{1:index-1} newvar oldcell{index:end}};
end