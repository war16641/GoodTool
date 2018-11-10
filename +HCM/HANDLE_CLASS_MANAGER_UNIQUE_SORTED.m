classdef HANDLE_CLASS_MANAGER_UNIQUE_SORTED<HCM.HANDLE_CLASS_MANAGER_UNIQUE
    %管理系列handleclass的类 且类是互斥的（针对标识符）且是有序的(升序)
    
    
    properties
        
    end
    
    methods
        function obj = HANDLE_CLASS_MANAGER_UNIQUE_SORTED(classname,identifier)
            %UNTITLED17 构造此类的实例
            %   此处显示详细说明
            obj=obj@HCM.HANDLE_CLASS_MANAGER_UNIQUE(classname,identifier);
        end
        function Add(obj,varargin)
            %重写add类 保证互斥性
            %使用eval生产新对象 构造函数为classname 
            %输入的参数可以是一个已经实例化的对象
            %         也可以是指定初始化参数 需要对不定参数进行处理
            
            %输入的参数是一个已经实例化的对象
            if 1==length(varargin)
                if isa(varargin{1},obj.classname)
                    %判断互斥
                    idadd=HCM.HANDLE_CLASS_MANAGER.GetIdentifier(varargin{1},obj.identifier);
                    [r,i]=IsIn(idadd,obj.identifiers);
                    if r==true
                        %已有
                        warning('MATLAB:mywarning','此对象已有');
                        %根据ow判断是否覆盖
                        switch(obj.flag_overwrite)
                            case obj.OVERWRITE_TRUE
                                obj.Overwrite(varargin{1},i);
                                return;
                            case obj.OVERWRITE_FALSE
                                return;
                            otherwise
                                error('sd')
                                return;
                        end                   

                    else%未有
                        pos=obj.GetPos(idadd);
                        obj.Insert(varargin{1},pos);
                        return;
                    end
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
            idadd=HCM.HANDLE_CLASS_MANAGER.GetIdentifier(tmp,obj.identifier);
            [r,i]=IsIn(idadd,obj.identifiers);
            if r==true
                %已有
                warning('MATLAB:mywarning','此对象已有');
                %根据ow判断是否覆盖
                switch(obj.flag_overwrite)
                    case obj.OVERWRITE_TRUE
                        obj.Overwrite(tmp,i);
                        return;
                    case obj.OVERWRITE_FALSE
                        return;
                    otherwise
                        error('sd')
                        return;
                end
            else%未有
                pos=obj.GetPos(idadd);
                obj.Insert(tmp,pos);
                return;
            end

        end        
        function pos=GetPos(obj,id)
            %获取新对象（id）应插入的位置 在这个值后
            if length(obj.identifiers)==0%无标识符时 返回0
                pos=0;
                return;
            end
            if isa(id,'double')%标识符是数字
                for it=1:length(obj.identifiers)
                    if obj.identifiers{it}>id
                        pos=it-1;
                        return;
                    end
                end
                pos=length(obj.identifiers);
                return;
            elseif isa(id,'char')%字符串
                for it=1:length(obj.identifiers)
                    if StrBTStr(obj.identifiers{it},id)
                        pos=it-1;
                        return;
                    end
                end
                pos=length(obj.identifiers);
                return;
            end
            error('未知类型')

        end

    end
    
end

