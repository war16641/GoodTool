function db=read_abaqus_report1(filename,prename)
%��ȡabaqus���ɵ�rpt�ļ�
%����struct ����
if nargin==1
    prename='';%ǰ׺��
end
db=struct();
db.name=prename;
fid=fopen(filename,'r');
last_name="";%���µı�����
last_data=[];%���µ�����
while(1)
    ln=fgetl(fid);
%     if isempty(ln)
%         continue;
%     end
    if ln==-1
        break;
    end
    t=regexp(ln,'^\s+$');
    if ~isempty(t) || isempty(ln)%�հ���
        if ~isempty( last_data)%������
%             assignin('base',nm,last_data);%�����ռ���ӱ���
            str1="db."+string(last_name)+"=last_data;";
            eval(str1);
        end
        last_data=[];
    else%���ǿհ���
        t=textscan(ln,'%f%f','delimiter',' ','MultipleDelimsAsOne',1);
        if length(t{1})~=0%������ ���
            last_data=[last_data;[t{1},t{2}]];
        else
            t=textscan(ln,'%s%s','delimiter',' ','MultipleDelimsAsOne',1);
            last_name=t{2}{1};%��������
        end
    end
    
end
fclose(fid);
end