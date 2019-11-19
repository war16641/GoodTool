function T=make_table_from_file(filename,format_str,numlineomitted,variable_name_line,delimiter)
% filename的格式：
% 第一行可以是变量名，以分隔符连接 variable_name_line指定有没有这一行
% 剩下的是数据行，数据用分隔符连接
% format_str指定格式比如"%s,%d,%d,%f,%f,%f,%f,%f"（这里，是分隔符）也是用分隔符连接
% delimiter 分隔符
%返回表
%注意：文件中不要出现空变量值，否则会导致数据错位，具体表现为后面的数据顶到前面的数据上（因为'MultipleDelimsAsOne',1）
if nargin==2
    numlineomitted=0;
    variable_name_line=0;
    delimiter=' ';
elseif nargin==3
    variable_name_line=0;
    delimiter=' ';
elseif nargin==4
    delimiter=' ';
end
fid=fopen(filename,'r');
fid=omitlines(fid,numlineomitted);
num_variable=format_str.count(delimiter)+1;%变量个数
if variable_name_line%有变量名
    tg="%s";
%     for i=2:num_variable
%         tg=tg+",%s";
%     end
    ln=fgetl(fid);
    if isempty(ln)
        error('并未发现变量名行')
    end
    c=textscan(ln,tg,'delimiter',delimiter,'MultipleDelimsAsOne',1);
    nms=Hull(c);
end
%初始化表
sz = [0 num_variable];
c=textscan(format_str,"%s",'delimiter',delimiter);
c=Hull(c);
varTypes={};
for i=1:length(c)
    if strcmp(c{i},'%d') ||strcmp(c{i},'%f')
        varTypes=[varTypes 'double'];
    elseif strcmp(c{i},'%s')
        varTypes=[varTypes 'string'];
    else
        error('无此类型')
    end
end
T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',nms);
fm=format_str.replace(delimiter,"");
while 1
    ln=fgetl(fid);
    if isempty(ln)
        continue;
    end
    if ln==-1
        break;
    end
    c=textscan(ln,fm,'delimiter',delimiter, 'TextType', 'string','MultipleDelimsAsOne',1);%这里没检查每一行的数据格式对不对
    T=[T;c];
end
fclose(fid);
end
function fid=omitlines(fid,line)
if 0==line
    return ;
end
for k=1:line
    fgetl(fid);
end
end
