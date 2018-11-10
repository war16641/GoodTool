function flhz_old(xlsname,sheet,startrow,classifyname,control,sheetname)
%���ֻ����һ����������
%ģ��excel��ķ�����ܹ��� 
%xlsname ��excel�ļ��� sheet����
%startraw�����ݿ�ʼ�� ������ͷ ��λ �����ӵ�һ�������ݵ�������
%classifyname �����ֶ�
%control ������Ϣ n*2��ϸ�� ��һ�����ֶ��� �ڶ����Ƕ�Ӧ����
%sheetname �ǽ������Ľ�����½�������ķ�ʽ���
dbstop if error
[~,~,raw]=xlsread(xlsname,sheet);
colnames=raw(1,:);
data=raw(startrow:end,:);%ȥ����ͷ����ʵ����
unique1=GetUnique(classifyname,colnames,data);
%unique1cell=mat2cell(unique1);
classifyindex=GetColIndexByName(classifyname,colnames);%�����ֶ� ��Ӧ��index
returnpart={};%���صĽ��ϸ��
for it=1:length(unique1)
    returnpart1={};%���unique�µ�returnpart һ��
    part=GetPart(classifyname,unique1(it),colnames,data);
    %����control��Ϣ �����Ҫ��ֵ ���ֶ�
    for it1=1:size(data,2)%��ÿһ���ֶ���
        if it1==classifyindex
            returnpart1=[returnpart1,unique1(it)];%Ϊ�����ֶ���
            continue;
        end
        [flag,t]=IsIn(colnames{it1},control(:,1));
        
        if flag%��control����Ҫ��
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
                    error("�޴�����")
            end
            continue;%��ɴ��ֶ�������
        else
            returnpart1=[returnpart1,'�޲���'];%��control���ֶ� �Կ��ַ�������
            continue;
        end
    end
    returnpart=[returnpart;returnpart1];
end

xlswrite(xlsname,[colnames;returnpart],sheetname);
end

function r=GetPart(colname,value,colnames,data)%��ȡ������ ����ĳһ���ֶ�������ĳ������value����������
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
if isnumeric(lie{1})%�õ�һ�������жϴ��������ǲ����� �����ַ���
    lie=cell2mat(lie);
end
r=unique(lie);
end
