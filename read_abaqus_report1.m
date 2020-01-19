function db=read_abaqus_report1(filename,prename)
%读取abaqus生成的rpt文件
%生成struct 返回
if nargin==1
    prename='';%前缀名
end
db=struct();
db.name=prename;
fid=fopen(filename,'r');
last_name="";%最新的变量名
last_data=[];%最新的数据
while(1)
    ln=fgetl(fid);
%     if isempty(ln)
%         continue;
%     end
    if ln==-1
        break;
    end
    t=regexp(ln,'^\s+$');
    if ~isempty(t) || isempty(ln)%空白行
        if ~isempty( last_data)%有数据
%             assignin('base',nm,last_data);%向工作空间添加变量
            str1="db."+string(last_name)+"=last_data;";
            eval(str1);
        end
        last_data=[];
    else%不是空白行
        t=textscan(ln,'%f%f','delimiter',' ','MultipleDelimsAsOne',1);
        if length(t{1})~=0%有数据 添加
            last_data=[last_data;[t{1},t{2}]];
        else
            t=textscan(ln,'%s%s','delimiter',' ','MultipleDelimsAsOne',1);
            last_name=t{2}{1};%更新名字
        end
    end
    
end
fclose(fid);
end