function tests=testmainfunc()
%���Ժ���
tests=functiontests(localfunctions);
end
function test1(testcase)
dbstop if error
load("F:\�ҵ��ĵ�\MATLAB\GoodTool\+VCM\dt.mat");
disp('����VCMUS')
vcm=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
for it=1:size(dt,1)
    vcm.Add(dt(it,1),dt(it,2));
end
goal=-100:1e4;%Ҫ��ѯ��Ŀ��
goalfindtime=zeros(1,length(goal));%��¼����ÿһ��Ŀ���ֵ
findcounter=0;%�ҵ�����
tic;
disp('��ʼ����')
for it=1:length(goal)
    g=goal(it);
    tic;
    i=vcm.FindId(g);
    if i~=0
        findcounter=findcounter+1;
        if g~=vcm.object{i,1}
            error('û�Ҷ�')
        end
    end
    t=toc;
    goalfindtime(it)=t;
end
disp(['���ҽ���' ])
toc
if findcounter~=vcm.num
    error('©��')
end
vcm.Check();
figure
plot(goal,goalfindtime);

disp('����VCM')
vcm=VCM.VALUE_CLASS_MANAGER();
for it=1:size(dt,1)
    vcm.Add(dt(it,1),dt(it,2));
end
goal=-100:1e4;%Ҫ��ѯ��Ŀ��
goalfindtime=zeros(1,length(goal));%��¼����ÿһ��Ŀ���ֵ
findcounter=0;%�ҵ�����
tic;
disp('��ʼ����')
for it=1:length(goal)
    g=goal(it);
    tic;
    i=vcm.FindId(g);
    if i~=0
        findcounter=findcounter+1;
        if g~=vcm.object{i,1}
            error('û�Ҷ�')
        end
    end
    t=toc;
    goalfindtime(it)=t;
end
disp(['���ҽ���' ])
toc
if findcounter~=vcm.num
    error('©��')
end
%vcm.Check();
figure
plot(goal,goalfindtime);
end
