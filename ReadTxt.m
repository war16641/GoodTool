function dt=ReadTxt(filename,numofcol,numlineomitted)
%∂¡»°Txt
dbstop if error
fid=fopen(filename,'r');
fid=omitlines(fid,numlineomitted);
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