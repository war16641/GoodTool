classdef HANDLE_CLASS_MANAGER<handle
    %管理系列handleclass的类
    %要求被管理的类具有name属性且是handle类
    %此类实现添加和返回特定对象
    
    
    properties
        objects%类的数据 不定类型
        num double%类的数量
        classname char%类的类型 字符串
        identifier char%对象的标识符 字符串
        flag_rewrite logical%指定覆盖方式
    end
    
    methods
        function obj = HANDLE_CLASS_MANAGER(classname,identifier)
            %构造时 需指定管理类的类型
            obj.objects = [];
            obj.num=0;
            obj.classname=classname;
            obj.identifier=identifier;
            obj.flag_rewrite=obj.REWRITE_FALSE;%默认覆盖方式为挤出
        end
        function Add(obj,varargin)
            %使用eval生产新对象 构造函数为classname 
            %实际是调用append 函数
            %输入的参数可以是一个已经实例化的对象
            %         也可以是指定初始化参数 需要对不定参数进行处理
            
            %输入的参数是一个已经实例化的对象
            if 1==length(varargin)
                if isa(varargin{1},obj.classname)
                    obj.Append(varargin{1});
                    return;
                end
            end
            
            %指定初始化参数 
            ln='';
            if 1==length(varargin)
                ln=[obj.classname '(varargin{1});' ];
            else
                for it=1:length(varargin)-1
                    ln=[ln 'varargin{' num2str(it) '},'];
                end
                ln=[ '(' ln 'varargin{end});'];
                ln=[obj.classname ln];
            end
            tmp=eval(ln);
            obj.Append(tmp);
        end
        function r=GetByIndex(obj,arg)
            %返回一个对象 直接根据id 
            r=obj.objects(arg);
        
        end
        function r=GetByIdentifier(obj,arg)%根据标识符查找
            for it=1:obj.num
                if isequal(arg,obj.GetIdentifier(obj.objects(it),obj.identifier))
                    r=obj.objects(it);
                    return;
                end
            end
            warning('未找到,返回一个空矩阵')
            r=[];
            return;
        end
        function Append(obj,newobj)%末尾增加一个
            obj.objects=[ obj.objects newobj];
            obj.num=obj.num+1;
        end
        function Insert(obj,newobj,index)%在index之后插入一个
            obj.objects=[obj.objects(1:index) newobj obj.objects(index+1:end)];
            obj.num=obj.num+1;
        end
        function Overwrite(obj,newobj,index)%在index处覆盖一个对象
            %rewrite 代表覆盖方式
            %0 代表新的 挤掉旧的
            %1 代表 旧的 变成和新的属性一模一样

            if obj.flag_rewrite==obj.REWRITE_FALSE
                obj.objects(index)=newobj;
            elseif obj.flag_rewrite==obj.REWRITE_TRUE
                obj.objects(index).copy(newobj)%执行这个语句需要有copy函数
            else
                error('无');
            end
        end
        function disp(obj)%自定义输出
            disp(['handle类管理器类型：' class(obj)]);
            disp(['管理对象：' obj.classname]);
            disp(['管理对象标识符：' obj.identifier]);
            disp(['管理对象数量：' num2str(obj.num)]);
            if length(obj)>1||obj.num==0
                %warning('对象数量不为1，暂不支持输出');
                return;
            end
            obj.objects.disp();
        end


    end
    properties(Constant,Hidden)
        REWRITE_TRUE=1%枚举变量 控制覆盖方式
        REWRITE_FALSE=0
        
    end
    methods(Static)
        function id=GetIdentifier(x,identifier)%返回对象的标识符
            id=eval(['x.' identifier ';']);
        end
    end
   
end

