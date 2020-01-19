function read_abaqus_report(filename,prename)
%��ȡabaqus���ɵ�rpt�ļ�
%�ڹ����ռ����ɱ���
%Ҫ��abaqus��xydata�����ֹ������matlab����������
if nargin==1
    prename='';%ǰ׺��
end
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
            if length(prename)~=0
                nm=[prename '_' last_name];
            end
            assignin('base',nm,last_data);%�����ռ���ӱ���
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