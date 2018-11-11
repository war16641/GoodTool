function dt=ReadTxtWithMatrixFormat(filename,fmt,lineomit,width)%��ȡ������ʽ�Ĵ洢�������ļ���ת��Ϊ���� ��������������

fid=fopen(filename,'r');
fid=omitlines(fid,lineomit);
dt=[];
switch char(fmt)
    case 'split'%ʹ�÷ָ���ָ��
        while(1)
            ln=fgetl(fid);
            if isempty(ln)
                continue;
            end
            if ln==-1
                break;
            end
            substr=Split(ln,' ');%Ĭ���ÿո�ָ� �е����ݿ�������tab�ָ��
            c=str2double(substr);
            if sum(isnan(c))>0
                error('�зǷ���ʽ����')
            end
            dt=[dt c];
            
        end
        dt=dt';%תΪ������
        fclose(fid);
    case 'fixedwidth'%�̶����
        gesi=['%' num2str(width) 'f'];
        while(1)
            ln=fgetl(fid);
            if isempty(ln)
                continue;
            end
            if ln==-1
                break;
            end
            c=textscan(ln,gesi);%textscan�����õ�����������ϸ��
            dt=[dt ;c{1}];
            
        end
        fclose(fid);
    otherwise
        error('sd')
end

end
function fid=omitlines(fid,line)
if 0==line
    return ;
end
for k=1:line
    fgetl(fid);
end
end