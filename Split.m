function substr=Split(str,ch)
%�ַ������
%ch�ָ��� �����һ������
substr={};
qidian=1;
for it=1:length(str)
    if str(it)==ch
        if qidian==it%�������ַָ���
            qidian=qidian+1;
        else%�ָ�
            substr=[substr str(qidian:it-1)];
            qidian=it+1;
        end
    else
        
    end
end
end