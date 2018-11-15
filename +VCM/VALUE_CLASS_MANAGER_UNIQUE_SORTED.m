classdef VALUE_CLASS_MANAGER_UNIQUE_SORTED<VCM.VALUE_CLASS_MANAGER
    %不允许重复的id 并保持数组升序排列
    properties
        
    end
    
    methods
        function obj = VALUE_CLASS_MANAGER_UNIQUE_SORTED()
            obj=obj@VCM.VALUE_CLASS_MANAGER();
        end
        function [success,isoverwrite]=Add(obj,id,newobj,overwrite)
            %success 是否添加成功
            %isoverwrite 是否覆盖添加
            %overwrite指定：如果遇到id存在是否覆盖
            success=0;
            isoverwrite=0;
            if nargin==3
                overwrite=0;%默认不覆盖
            end
            [index,after]=obj.FindId(id);
            if index==0%没有id
                obj.Insert(after,id,newobj);%插入一个
                success=1;
                isoverwrite=0;
            else%已有
                if 1==overwrite
                    obj.Overwrite('index',index,newobj);%覆盖
                    disp(['覆盖' id])%这一句只是提示 可以不用输出
                    success=1;
                    isoverwrite=1;
                    return;
                end
                success=0;
                isoverwrite=0;
%                 disp('此id已有')%这一句只是提示 可以不用输出

            end
        end
        function [index,after]=FindId(obj,id)%判断id是否在数组中 如果不存在就返回0
            %after返回的是 当index=0时 最接近id的较小值
            if obj.num==0%数组中无数据
                index=0;
                after=0;
                return;
            end
            rg=[1 obj.num];%潜在的范围
            after=-1;%默认值
            if isa(id,'double')
                if id<=obj.num&&id>0
                    %尝试直接用序号=id判断
                    r=obj.CompareSize(id,obj.object{id,1});
                    if r(1)=='e'
                        index=id;
                        return;
                    end
                end
            end
            
            %检查是否前面是否比目标值小 后面是否比目标值大
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
            if r1(1)=='b'%首比目标还大
                index=0;
                after=0;
                return;
            end
            if r2(1)=='s'%尾比目标还小
                index=0;
                after=obj.num;
                return;
            end            
%             if ~(r1(1)=='s'&&r2(1)=='b')%目标在首尾之外
%                 index=0;
%                 return;
%             end
            
           %二分法查找
           while 1
               
               if rg(2)-rg(1)==1%上下界相连 这时不用2分法直接拿这两个比 没有也就找不到le 
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
              
%                if rg(1)==rg(2)%首等于尾
%                    index=0;
%                    return;%退出循环
%                end

               
               %拿出中间的数
               mid=round(sum(rg)/2);
               r=obj.CompareSize(id,obj.object{mid,1});
               switch r(1)
                   case 'b'%目标比中间值大
                       rg(1)=mid;
                       continue;
                   case 's'%目标比中间值小
                       rg(2)=mid;
                       continue;
                   case 'e'%目标等于
                       index=mid;
                       return;
               end
           end
           
        end
        function [o,id]=Get(obj,type,arg1)
            %type是'index'和'id'
            %o 返回对象 没有返回空矩阵
            %id是对应的id 没有返回空矩阵
            switch type(1:2)
                case 'in'%通过索引
                    o=obj.object{arg1,2};
                    o=o{1};
                    id=obj.object{arg1,1};
                    return;
                case 'id'%通过id 算法较慢
                    index=obj.FindId(arg1);
                    if index~=0
                        o=obj.object{index,2};
                        o=o{1};
                        id=obj.object{index,1};
                        return;
                    end
                    id=[];
                    o=[];
                    return;
                otherwise
                    error('未知类型')
            end
        end
        function Check(obj)%检查 有无重复id 是否是升序 数量是否对
            ids=obj.object(:,1);
            if isa(ids{1},'double')
                ids=cell2mat(ids);
            end
            [~,ia,~]=unique(ids);
            if length(ia)~=obj.num
                error('有重复id')
            end
            
            if 1==obj.num%一个不用检查
                return;
            end
            for it=1:obj.num-1
                r=obj.CompareSize(obj.object{it,1},obj.object{it+1,1});
                if r(1)~='s'
                    error('不是升序')
                end
            end
            
            if obj.num~=size(obj.object,1)
                error('数量不对')
            end
            
        end
    end
    methods(Static)
        function r=CompareSize(a,b)%比较两个的大小
            %a b可以是数值或者字符或者字符串
            %r返回big equal small 指的是a
            if isa(a,'double')&&isa(b,'double')%都是数
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
            
            %如果是string 转化为char
            if isa(a,'string')
                a=char(a);
            end
             if isa(b,'string')
                b=char(b);
            end
                       
            if isa(a,'char')&&isa(b,'char')
                if length(a)==1&&length(b)==1%都是字符
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
                else%字符串 按照unicode比较两个字符串的大小
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
                            continue;%比较下一个字符
                        end
                    end
                    
                    %前面的是一样的
                    if len1==len2
                        r='euqal';
                        return;%字符串一样
                    elseif len1>len2%s1较短
                        r='big';
                        return;
                    else %s2较短
                        r='small';
                        return;
                    end
                end
            end
            
            error('未知类型')
        end
    end
end

