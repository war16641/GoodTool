function tb=structs_to_table(sts)
%把struct结构形成的一维数组 组成table
parlen=length(fieldnames(sts));
parnames=fieldnames(sts);
tb=table();
for i1=1:parlen
    tb.(parnames{i1})=[sts.(parnames{i1})]';
end
end