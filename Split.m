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
end