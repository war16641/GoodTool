function ToANSYSFile()
%��excel�е����� ���txt�ļ� �Ա�ansys��ȡ
data=xlsread('dz.xlsx','A1:B2048');%Ҫ�򿪵��ļ���
fid=fopen('dizhenbo.TXT','w');
[m,n]=size(data);
clc
for k1=1:m
    fprintf(fid,'%5.3f %+9.7f\r\n',data(k1,1),data(k1,2));%ansys �� (f6.3,f10.7)
end
fclose(fid);
end

% function ToANSYSFile()
% %��excel�е����� ���txt�ļ� �Ա�ansys��ȡ
% data=xlsread('dz.xlsx','A1:B4002');%Ҫ�򿪵��ļ���
% fid=fopen('dizhenbo.TXT','w');
% [m,n]=size(data);
% clc
% for k1=1:m
%     for k2=1:n
%         if k2==n
%             fprintf(fid,'%+011.4E',data(k1,k2));
%             fprintf(fid,'\r\n');
%             continue;
%         end
%         fprintf(fid,'%+011.4E ',data(k1,k2));%��������ȫ��11 ����ĩβ�ո� ��ansys�ж���F12.0
%     end
% end
% fclose(fid);
% end