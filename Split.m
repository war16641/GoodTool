function substr=Split(str,ch)
%字符串拆分
%ch分隔符 多个按一个处理
substr={};
qidian=1;
for it=1:length(str)
    if str(it)==ch
        if qidian==it%连续出现分隔符
            qidian=qidian+1;
        else%分割
            substr=[substr str(qidian:it-1)];
            qidian=it+1;
        end
    else
        
    end
end

%处理最后一个数据
if qidian~=length(str)+1%还有最后一个数据
    substr=[substr str(qidian:length(str))];
end


end