function dt=ReadAnsysPrvar(filename,numofcol)
%读取ANSYS prvar 生成的文件 numofcol是列数
dbstop if error
fid=fopen(filename);
fid=omitlines(fid,6);%ansys 输出文件 前6行是表头
gesi='';
for it=1:numofcol
    gesi=[gesi '%f '];
end
gesi=[gesi '%[^\n\r]'];
dt=[];
while(1)
    ln=fgetl(fid);
    if isempty(ln)
        continue;
    end
    if ln==-1
        break;
    end
    c=textscan(ln,gesi,'delimiter',' ','MultipleDelimsAsOne',1);
    c(:,end)=[];
    c=cell2mat(c);
    dt=[dt;c];
    
end
end
function fid=omitlines(fid,line)
for k=1:line
    fgetl(fid);
end
end