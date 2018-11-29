function dt=ReadTxtWithMatrixFormat(filename,fmt,lineomit,width)%读取矩阵形式的存储的数据文件并转化为向量 矩阵可能最后差几个数

fid=fopen(filename,'r');
fid=omitlines(fid,lineomit);
dt=[];
switch char(fmt)
    case 'split'%使用分割符分割的
        while(1)
            ln=fgetl(fid);
            if isempty(ln)
                continue;
            end
            if ln==-1
                break;
            end
            substr=Split(ln,' ');%默认用空格分割 有的数据可能是以tab分割的
            c=str2double(substr);
            if sum(isnan(c))>0
                error('有非法格式数据')
            end
            dt=[dt c];
            
        end
        dt=dt';%转为列向量
        fclose(fid);
    case 'fixedwidth'%固定宽度
        gesi=['%' num2str(width) 'f'];
        hangcounter=1;%记录读取的行数
        while(1)
            ln=fgetl(fid);
            if isempty(ln)
                continue;
            end
            if ln==-1
                break;
            end
            c=textscan(ln,gesi);%textscan函数得到的是列数据细胞
            if isempty(c) 
                disp(ln);
                warning(['数据异常 位于' num2str(lineomit+hangcounter) '行'])
                continue;
            end
            if ~isempty(c)
                if length(ln)/(length(c{1})*width)>1.2 %总字符个数太多
                    disp(ln);
                    warning(['数据异常 位于' num2str(lineomit+hangcounter) '行'])
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