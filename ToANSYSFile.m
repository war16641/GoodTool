function ToANSYSFile()
%将excel中的数据 输出txt文件 以便ansys读取
data=xlsread('dz.xlsx','A1:B2048');%要打开的文件名
fid=fopen('dizhenbo.TXT','w');
[m,n]=size(data);
clc
for k1=1:m
    fprintf(fid,'%5.3f %+9.7f\r\n',data(k1,1),data(k1,2));%ansys 中 (f6.3,f10.7)
end
fclose(fid);
end

% function ToANSYSFile()
% %将excel中的数据 输出txt文件 以便ansys读取
% data=xlsread('dz.xlsx','A1:B4002');%要打开的文件名
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
%         fprintf(fid,'%+011.4E ',data(k1,k2));%单个数据全长11 加上末尾空格 在ansys中读入F12.0
%     end
% end
% fclose(fid);
% end