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
        hangcounter=1;%��¼��ȡ������
        while(1)
            ln=fgetl(fid);
            if isempty(ln)
                continue;
            end
            if ln==-1
                break;
            end
            c=textscan(ln,gesi);%textscan�����õ�����������ϸ��
            if isempty(c) 
                disp(ln);
                warning(['�����쳣 λ��' num2str(lineomit+hangcounter) '��'])
                continue;
            end
            if ~isempty(c)
                if length(ln)/(length(c{1})*width)>1.2 %���ַ�����̫��
                    disp(ln);
                    warning(['�����쳣 λ��' num2str(lineomit+hangcounter) '��'])
                    continue;
                end
            end
            dt=[dt ;c{1}];
            
            hangcounter=hangcounter+1;
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