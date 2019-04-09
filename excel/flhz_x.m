function flhz_x(xlsname,sheet,rowformat,classifyname,control,sheetname,flag_controltxt)
%可以带注释行
%模拟excel表的分类汇总功能
%xlsname 是excel文件名 sheet表名
%rowformat是数据分行说明 3*1cell  第一个是变量名的行数 第二个注释的行数（多行注释时为矩阵） 第三个是数据起始行 行数从第一行有内容的行起算
%classifyname 类别字段 字符串组成的行细胞 将数据按行细胞字段的顺序排序
%control 控制信息 n*2的细胞 第一列是字段名 第二列是对应操作
%sheetname 是将处理后的结果以新建工作表的方式输出
%flag_controltxt 是否输出控制信息 输出在第二行

numcontrol=size(control,1);%控制信息的行数
startrow=rowformat{3};%数据起始行
varrow=rowformat{1};%变量名行
dbstop if error
[~,~,raw]=xlsread(xlsname,sheet);
colnames=raw(varrow,:);%变量名字符串组
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
                case 'absmax1'
                    returnpart1=[returnpart1,AbsMax(tab2,1)];
                case 'absmin1'
                    returnpart1=[returnpart1,AbsMin(tab2,1)];  
                case 'count'
                    returnpart1=[returnpart1,length(tab2)];
                case 'mean'
                    returnpart1=[returnpart1,mean(tab2)];
                otherwise
                    error("无此类型")
            end
        end
        returnpart=[returnpart;returnpart1];
        lastclass=thisclass;
    end
end

t=[classifyname control(:,1)'];%变量名行

notetxt={};%注释行
if ~isempty(rowformat{2})%有注释行信息
    notetxtorigin=raw(rowformat{2},:);%原始 所有注释行
    noteindex=[classifyindex controlindex];
    notetxt=notetxtorigin(:,noteindex);
end
% for it=1:numcontrol
%     noteindex=[noteindex GetColIndexByName(control{it,1},colnames)];
% end

%操作信息行
controltxt={};
for it=1:length(classifyname)
    controltxt=[controltxt '类别'];
end
controltxt=[controltxt control(:,2)'];
if nargin==7&&flag_controltxt==1
    xlswrite(xlsname,[t;controltxt;notetxt;returnpart],sheetname);
else
    xlswrite(xlsname,[t;notetxt;returnpart],sheetname);
end

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
