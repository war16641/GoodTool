function flhz_x(xlsname,sheet,rowformat,classifyname,control,sheetname,flag_controltxt)
%���Դ�ע����
%ģ��excel��ķ�����ܹ���
%xlsname ��excel�ļ��� sheet����
%rowformat�����ݷ���˵�� 3*1cell  ��һ���Ǳ����������� �ڶ���ע�͵�����������ע��ʱΪ���� ��������������ʼ�� �����ӵ�һ�������ݵ�������
%classifyname ����ֶ� �ַ�����ɵ���ϸ�� �����ݰ���ϸ���ֶε�˳������
%control ������Ϣ n*2��ϸ�� ��һ�����ֶ��� �ڶ����Ƕ�Ӧ����
%sheetname �ǽ������Ľ�����½�������ķ�ʽ���
%flag_controltxt �Ƿ����������Ϣ ����ڵڶ���

numcontrol=size(control,1);%������Ϣ������
startrow=rowformat{3};%������ʼ��
varrow=rowformat{1};%��������
dbstop if error
[~,~,raw]=xlsread(xlsname,sheet);
colnames=raw(varrow,:);%�������ַ�����
data=raw(startrow:end,:);%ȥ����ͷ����ʵ����
tab=cell2table(data);%���ɱ�

t=length(classifyname);
classifyindex=zeros(1,t);
for it=1:t
    classifyindex(it)=GetColIndexByName(classifyname{it},colnames);%������תΪ��������
end
controlindex=zeros(1,numcontrol);
for it=1:numcontrol
    controlindex(it)=GetColIndexByName(control{it,1},colnames);%������תΪ��������
end

sortparam={};%�����������ĵ�2����
for it=1:t
    sortparam=[sortparam tab.Properties.VariableNames(classifyindex(it))];
end
tab=sortrows(tab,sortparam);%����

%���з������
lastclass=tab(1,classifyindex);
lastclass=table2cell(lastclass);%��һ�е����
num1=0;%�Ѿ�ʹ�õ���������
returnpart={};
for it=2:size(tab,1)
    thisclass=tab(it,classifyindex);thisclass=table2cell(thisclass);
    if ~Comparelcass(lastclass,thisclass)||it==size(tab,1)%����ͬ ���� ���һ��
        tab1=tab(num1+1:it-1,:);%ȡ�ô��������
        num1=it-1;
        returnpart1=lastclass;
        for k=1:numcontrol%���ݿ�����Ϣ���л���
            tab2=tab1(:,controlindex(k));
            tab2=table2array(tab2);
            switch control{k,2}%���ܷ�ʽ���Ը�����Ҫ�ֶ��޸�
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
                    error("�޴�����")
            end
        end
        returnpart=[returnpart;returnpart1];
        lastclass=thisclass;
    end
end

t=[classifyname control(:,1)'];%��������

notetxt={};%ע����
if ~isempty(rowformat{2})%��ע������Ϣ
    notetxtorigin=raw(rowformat{2},:);%ԭʼ ����ע����
    noteindex=[classifyindex controlindex];
    notetxt=notetxtorigin(:,noteindex);
end
% for it=1:numcontrol
%     noteindex=[noteindex GetColIndexByName(control{it,1},colnames)];
% end

%������Ϣ��
controltxt={};
for it=1:length(classifyname)
    controltxt=[controltxt '���'];
end
controltxt=[controltxt control(:,2)'];
if nargin==7&&flag_controltxt==1
    xlswrite(xlsname,[t;controltxt;notetxt;returnpart],sheetname);
else
    xlswrite(xlsname,[t;notetxt;returnpart],sheetname);
end

end

function r=Comparelcass(lastclass,thisclass)%�Ƚ���������Ƿ�Ϊͬ���
t=length(lastclass);
for it=1:t
    if ~IsIn(lastclass{it},thisclass{it})
        r=0;return;
    end
end
r=1;%��ͬ����1
end
