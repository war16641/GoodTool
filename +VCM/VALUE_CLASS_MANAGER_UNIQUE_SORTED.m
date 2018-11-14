classdef VALUE_CLASS_MANAGER_UNIQUE_SORTED<VCM.VALUE_CLASS_MANAGER
    %�������ظ���id ������������������
    properties
        
    end
    
    methods
        function obj = VALUE_CLASS_MANAGER_UNIQUE_SORTED()
            obj=obj@VCM.VALUE_CLASS_MANAGER();
        end
        function Add(obj,id,newobj,overwrite)
            %overwriteָ�����������id�����Ƿ񸲸�
            if nargin==3
                overwrite=0;%Ĭ�ϲ�����
            end
            [index,after]=obj.FindId(id);
            if index==0%û��id
                obj.Insert(after,id,newobj);%����һ��
            else%����
                if 1==overwrite
                    obj.Overwrite('index',index,newobj);%����
                end
                disp('��id����')%��һ��ֻ����ʾ ���Բ������
            end
        end
        function [index,after]=FindId(obj,id)%�ж�id�Ƿ��������� ��������ھͷ���0
            %after���ص��� ��index=0ʱ ��ӽ�id�Ľ�Сֵ
            if obj.num==0%������������
                index=0;
                after=0;
                return;
            end
            rg=[1 obj.num];%Ǳ�ڵķ�Χ
            after=-1;%Ĭ��ֵ
            if id<=obj.num&&id>0
                %����ֱ�������=id�ж�
                r=obj.CompareSize(id,obj.object{id,1});
                if r(1)=='e'
                    index=id;
                    return;
                end
            end
            
            %����Ƿ�ǰ���Ƿ��Ŀ��ֵС �����Ƿ��Ŀ��ֵ��
            r1=obj.CompareSize(obj.object{1,1},id);
            r2=obj.CompareSize(obj.object{end,1},id);
            if r1(1)=='e'
                index=1;
                return;
            end
            if r1(2)=='e'
                index=obj.num;
                return;
            end
            if r1(1)=='b'%�ױ�Ŀ�껹��
                index=0;
                after=0;
                return;
            end
            if r2(1)=='s'%β��Ŀ�껹С
                index=0;
                after=obj.num;
                return;
            end            
%             if ~(r1(1)=='s'&&r2(1)=='b')%Ŀ������β֮��
%                 index=0;
%                 return;
%             end
            
           %���ַ�����
           while 1
               
               if rg(2)-rg(1)==1%���½����� ��ʱ����2�ַ�ֱ������������ û��Ҳ���Ҳ���le 
                   if isequal(id,obj.object{rg(1),1})
                       index=rg(1);
                       return;
                   end
                   if isequal(id,obj.object{rg(2),1})
                       index=rg(2);
                       return;
                   end
                   index=0;
                   after=rg(1);
                   return;
               end
              
%                if rg(1)==rg(2)%�׵���β
%                    index=0;
%                    return;%�˳�ѭ��
%                end

               
               %�ó��м����
               mid=round(sum(rg)/2);
               r=obj.CompareSize(id,obj.object{mid,1});
               switch r(1)
                   case 'b'%Ŀ����м�ֵ��
                       rg(1)=mid;
                       continue;
                   case 's'%Ŀ����м�ֵС
                       rg(2)=mid;
                       continue;
                   case 'e'%Ŀ�����
                       index=mid;
                       return;
               end
           end
           
        end
        function o=Get(obj,type,arg1)
            %type��'index'��'id'
            switch type(1:2)
                case 'in'%ͨ������
                    o=obj.object{arg1,2};
                    return;
                case 'id'%ͨ��id �㷨����
                    index=obj.FindId(arg1);
                    if index~=0
                        o=obj.object{index,2};
                        return;
                    end
                    o=[];
                    return;
                otherwise
                    error('δ֪����')
            end
        end
    end
    methods(Static)
        function r=CompareSize(a,b)%�Ƚ������Ĵ�С
            %a b��������ֵ�����ַ������ַ���
            %r����big equal small ָ����a
            if isa(a,'double')&&isa(b,'double')%������
                if a>b
                    r='big';
                    return;
                elseif a<b
                    r='small';
                    return;
                else
                    r='equal';
                    return;
                end
            end
            
            %�����string ת��Ϊchar
            if isa(a,'string')
                a=char(a);
            end
             if isa(b,'string')
                b=char(b);
            end
                       
            if isa(a,'char')&&isa(b,'char')
                if length(a)==1&&length(b)==1%�����ַ�
                    if a>b
                        r='big';
                        return;
                    elseif a<b
                        r='small';
                        return;
                    else
                        r='equal';
                        return;
                    end
                else%�ַ��� ����unicode�Ƚ������ַ����Ĵ�С
                    len1=length(a);
                    len2=length(b);
                    for it=1:min([len1 len2])
                        if a(it)>b(it)
                            r='big';
                            return;
                        elseif a(it)<b(it)
                            r='small';
                            return;
                        else
                            continue;%�Ƚ���һ���ַ�
                        end
                    end
                    
                    %ǰ�����һ����
                    if len1==len2
                        r='euqal';
                        return;%�ַ���һ��
                    elseif len1>len2%s1�϶�
                        r='big';
                        return;
                    else %s2�϶�
                        r='small';
                        return;
                    end
                end
            end
            
            error('δ֪����')
        end
    end
end
