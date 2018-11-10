function flhz(xlsname,sheet,startrow,classifyname,control,sheetname)
%模拟excel表的分类汇总功能
%xlsname 是excel文件名 sheet表名
%startraw是数据开始行 不含表头 单位 行数从第一行有内容的行起算
%classifyname 类别字段 字符串组成的行细胞 将数据按行细胞字段的顺序排序
%control 控制信息 n*2的细胞 第一列是字段名 第二列是对应操作
%sheetname 是将处理后的结果以新建工作表的方式输出

numcontrol=size(control,1);%控制信息的行数

dbstop if error
[~,~,raw]=xlsread(xlsname,sheet);
colnames=raw(1,:);
data=raw(startrow:end,:);%去除表头的真实数据
tab=cell2table(data);%生成表

t=length(classifyname);
classifyindex=zeros(1,t);
for it=1:t
    classifyindex(it)=GetColIndexByName(classifyname{it},colnames);%变量名转为变量索引
end
controlindex=zeros(1,numcontrol);
for it=1:numcontrol
    controlindex(it)=GetColIndexByName(control{it,1},colnames);%变量名转为变量索引
end

sortparam={};%生成排序函数的第2参数
for it=1:t
    sortparam=[sortparam tab.Properties.VariableNames(classifyindex(it))];
end
tab=sortrows(tab,sortparam);%排序

%进行分类汇总
lastclass=tab(1,classifyindex);
lastclass=table2cell(lastclass);%上一行的类别
num1=0;%已经使用到的数据行
returnpart={};
for it=2:size(tab,1)
    thisclass=tab(it,classifyindex);thisclass=table2cell(thisclass);
    if ~Comparelcass(lastclass,thisclass)||it==size(tab,1)%不相同 或者 最后一组
        tab1=tab(num1+1:it-1,:);%取得此类别数据
        if it==size(tab,1)
            tab1=tab(num1+1:it,:);%取得此类别数据
        end
        num1=it-1;
        returnpart1=lastclass;
        for k=1:numcontrol%根据控制信息进行汇总
            tab2=tab1(:,controlindex(k));
            tab2=table2array(tab2);
            switch control{k,2}%汇总方式可以根据需要手动修改
                case 'max'
                    returnpart1=[returnpart1,max(tab2)];
                case 'min'
                    returnpart1=[returnpart1,min(tab2)];
                case 'absmax'
                    returnpart1=[returnpart1,AbsMax(tab2)];
                case 'absmin'
                    returnpart1=[returnpart1,AbsMin(tab2)];
                case 'count'
                    returnpart1=[returnpart1,length(tab2)];
                otherwise
                    error("无此类型")
            end
        end
        returnpart=[returnpart;returnpart1];
        lastclass=thisclass;
    end
end

t=[classifyname control(:,1)'];
xlswrite(xlsname,[t;returnpart],sheetname);
end

function r=Comparelcass(lastclass,thisclass)%比较两个类别是否为同类别
t=length(lastclass);
for it=1:t
    if ~IsIn(lastclass{it},thisclass{it})
        r=0;return;
    end
end
r=1;%相同返回1
end
