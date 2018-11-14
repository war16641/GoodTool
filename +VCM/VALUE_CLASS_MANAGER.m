classdef VALUE_CLASS_MANAGER<handle
    %值类管理器
    %管理对象object是n*2的cell 第一列是id 第二列是值类
    
    properties
        object cell%管理对象
        num double
    end
    
    methods
        function obj = VALUE_CLASS_MANAGER()
            obj.num=0;
            obj.object={};
        end
        
        function Add(obj,id,newobj)
            obj.Append(id,newobj);
        end
        function o=Get(obj,type,arg1)
            %type是'index'和'id'
            switch type(1:2)
                case 'in'%通过索引
                    o=obj.object{arg1,2};
                    return;
                case 'id'%通过id 算法较慢
                    for it=1:obj.num
                        if arg1==obj.object{it,1}
                            o=obj.object{it,2};
                            return;
                        end
                    end
                    error('未找到')
                otherwise
                    error('未知类型')
            end
        end
        

    end
    methods(Access=protected)
        function Append(obj,id,newobj)
            obj.object=[obj.object;{id,{newobj}}];
            obj.num=obj.num+1;
        end
        function Insert(obj,index,id,newobj)
            %在insert之后插入一个
            obj.objects=[obj.objects(1:index,:) ;{id,newobj}; obj.objects(index+1:end)];
            obj.num=obj.num+1;
        end
        function Overwrite(obj,type,arg1,newobj)
            %type可以是 'index' 和'id'
            switch type(1:2)
                case 'in'%通过索引
                    obj.object(arg1,2)={newobj};
                    return;
                case 'id'%通过id 算法较慢
                    for it=1:obj.num
                        if arg1==obj.object{it,1}
                            obj.object(it,2)={newobj};
                            return;
                        end
                    end
                    error('未找到')
                otherwise
                    error('未知类型')
            end
        end
    end
end

