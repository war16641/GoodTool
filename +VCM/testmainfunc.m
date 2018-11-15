function tests=testmainfunc()
%测试函数
tests=functiontests(localfunctions);
end
function test1(testcase)
dbstop if error
load("F:\我的文档\MATLAB\GoodTool\+VCM\dt.mat");
disp('测试VCMUS')
vcm=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
for it=1:size(dt,1)
    vcm.Add(dt(it,1),dt(it,2));
end
goal=-100:1e4;%要查询的目标
goalfindtime=zeros(1,length(goal));%记录查找每一个目标的值
findcounter=0;%找到的数
tic;
disp('开始查找')
for it=1:length(goal)
    g=goal(it);
    tic;
    i=vcm.FindId(g);
    if i~=0
        findcounter=findcounter+1;
        if g~=vcm.object{i,1}
            error('没找对')
        end
    end
    t=toc;
    goalfindtime(it)=t;
end
disp(['查找结束' ])
toc
if findcounter~=vcm.num
    error('漏了')
end
vcm.Check();
figure
plot(goal,goalfindtime);

disp('测试VCM')
vcm=VCM.VALUE_CLASS_MANAGER();
for it=1:size(dt,1)
    vcm.Add(dt(it,1),dt(it,2));
end
goal=-100:1e4;%要查询的目标
goalfindtime=zeros(1,length(goal));%记录查找每一个目标的值
findcounter=0;%找到的数
tic;
disp('开始查找')
for it=1:length(goal)
    g=goal(it);
    tic;
    i=vcm.FindId(g);
    if i~=0
        findcounter=findcounter+1;
        if g~=vcm.object{i,1}
            error('没找对')
        end
    end
    t=toc;
    goalfindtime(it)=t;
end
disp(['查找结束' ])
toc
if findcounter~=vcm.num
    error('漏了')
end
%vcm.Check();
figure
plot(goal,goalfindtime);
end
