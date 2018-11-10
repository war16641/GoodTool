function flhz_old(xlsname,sheet,startrow,classifyname,control,sheetname)
%类别只能由一个变量决定
%模拟excel表的分类汇总功能 
%xlsname 是excel文件名 sheet表名
%startraw是数据开始行 不含表头 单位 行数从第一行有内容的行起算
%classifyname 分类字段
%control 控制信息 n*2的细胞 第一列是字段名 第二列是对应操作
%sheetname 是将处理后的结果以新建工作表的方式输出
dbstop if error
[~,~,raw]=xlsread(xlsname,sheet);
colnames=raw(1,:);
data=raw(startrow:end,:);%去除表头的真实数据
unique1=GetUnique(classifyname,colnames,data);
%unique1cell=mat2cell(unique1);
classifyindex=GetColIndexByName(classifyname,colnames);%分类字段 对应的index
returnpart={};%返回的结果细胞
for it=1:length(unique1)
    returnpart1={};%这个unique下的returnpart 一行
    part=GetPart(classifyname,unique1(it),colnames,data);
    %根据control信息 计算出要求值 按字段
    for it1=1:size(data,2)%对每一个字段名
        if it1==classifyindex
            returnpart1=[returnpart1,unique1(it)];%为分类字段名
            continue;
        end
        [flag,t]=IsIn(colnames{it1},control(:,1));
        
        if flag%在control中有要求
            partlie=cell2mat(part(:,it1));
            switch control{t,2}
                case 'max'
                    returnpart1=[returnpart1,max(partlie)];
                case 'min'
                    returnpart1=[returnpart1,min(partlie)];
                case 'absmax'
                    returnpart1=[returnpart1,AbsMax(partlie)];
                case 'absmin'
                    returnpart1=[returnpart1,AbsMin(partlie)];
                otherwise
                    error("无此类型")
            end
            continue;%完成此字段名操作
        else
            returnpart1=[returnpart1,'无操作'];%无control的字段 以空字符串填入
            continue;
        end
    end
    returnpart=[returnpart;returnpart1];
end

xlswrite(xlsname,[colnames;returnpart],sheetname);
end

function r=GetPart(colname,value,colnames,data)%获取数据行 满足某一个字段名等于某个数（value）或者数组
index=GetColIndexByName(colname,colnames);
r={};
for it=1:size(data,1)
    if IsIn(data{it,index},value)
        r=[r;data(it,:)];
    end
end
end
function r=GetUnique(colname,colnames,data)
index=GetColIndexByName(colname,colnames);
lie=data(:,index);
if isnumeric(lie{1})%用第一个数据判断此列数据是不是数 或者字符串
    lie=cell2mat(lie);
end
r=unique(lie);
end
