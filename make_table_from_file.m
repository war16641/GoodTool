function T=make_table_from_file(filename,format_str,numlineomitted,variable_name_line,delimiter)
% filename�ĸ�ʽ��
% ��һ�п����Ǳ��������Էָ������� variable_name_lineָ����û����һ��
% ʣ�µ��������У������÷ָ�������
% format_strָ����ʽ����"%s,%d,%d,%f,%f,%f,%f,%f"������Ƿָ�����Ҳ���÷ָ�������
% delimiter �ָ���
%���ر�
%ע�⣺�ļ��в�Ҫ���ֿձ���ֵ������ᵼ�����ݴ�λ���������Ϊ��������ݶ���ǰ��������ϣ���Ϊ'MultipleDelimsAsOne',1��
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
num_variable=format_str.count(delimiter)+1;%��������
if variable_name_line%�б�����
    tg="%s";
%     for i=2:num_variable
%         tg=tg+",%s";
%     end
    ln=fgetl(fid);
    if isempty(ln)
        error('��δ���ֱ�������')
    end
    c=textscan(ln,tg,'delimiter',delimiter,'MultipleDelimsAsOne',1);
    nms=Hull(c);
end
%��ʼ����
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
        error('�޴�����')
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
    c=textscan(ln,fm,'delimiter',delimiter, 'TextType', 'string','MultipleDelimsAsOne',1);%����û���ÿһ�е����ݸ�ʽ�Բ���
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
