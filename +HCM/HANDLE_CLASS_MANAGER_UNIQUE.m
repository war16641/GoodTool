classdef HANDLE_CLASS_MANAGER_UNIQUE<HCM.HANDLE_CLASS_MANAGER
    %管理系列handleclass的类 且类是互斥的（针对标识符）
    
    properties
        identifiers cell%已添加的标识符
        flag_overwrite logical%指定是否覆盖同名对象
    end
    
    methods
        function obj = HANDLE_CLASS_MANAGER_UNIQUE(classname,identifier)
            %UNTITLED15 构造此类的实例
            %   此处显示详细说明
            obj=obj@HCM.HANDLE_CLASS_MANAGER(classname,identifier);
            obj.identifiers={};
            obj.flag_overwrite=obj.OVERWRITE_FALSE;%默认不覆盖同名对象
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
                    idadd=obj.GetIdentifier(varargin{1},obj.identifier);
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
                        obj.Append(varargin{1});
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
            idadd=HANDLE_CLASS_MANAGER.GetIdentifier(tmp,obj.identifier);
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
                obj.Append(tmp);
                
                return;
            end

        end
        function Append(obj,newobj)%重写
            obj.objects=[ obj.objects newobj];
            obj.identifiers=[obj.identifiers,obj.GetIdentifier(newobj,obj.identifier)];
            obj.num=obj.num+1;
        end        
        function Insert(obj,newobj,index)%重写insert函数 因为涉及到idtentifier
            obj.objects=[obj.objects(1:index) newobj obj.objects(index+1:end)];
            obj.identifiers=[obj.identifiers(1:index) obj.GetIdentifier(newobj,obj.identifier) obj.identifiers(index+1:end)];
            obj.num=obj.num+1;
        end



    end
    properties(Constant,Hidden)
        OVERWRITE_TRUE=1%枚举变量 控制是否覆盖同名对象
        OVERWRITE_FALSE=0
        
    end    
end

