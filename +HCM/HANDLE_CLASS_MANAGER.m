classdef HANDLE_CLASS_MANAGER<handle
    %����ϵ��handleclass����
    %Ҫ�󱻹���������name��������handle��
    %����ʵ����Ӻͷ����ض�����
    
    
    properties
        objects%������� ��������
        num double%�������
        classname char%������� �ַ���
        identifier char%����ı�ʶ�� �ַ���
        flag_rewrite logical%ָ�����Ƿ�ʽ
    end
    
    methods
        function obj = HANDLE_CLASS_MANAGER(classname,identifier)
            %����ʱ ��ָ�������������
            obj.objects = [];
            obj.num=0;
            obj.classname=classname;
            obj.identifier=identifier;
            obj.flag_rewrite=obj.REWRITE_FALSE;%Ĭ�ϸ��Ƿ�ʽΪ����
        end
        function Add(obj,varargin)
            %ʹ��eval�����¶��� ���캯��Ϊclassname 
            %ʵ���ǵ���append ����
            %����Ĳ���������һ���Ѿ�ʵ�����Ķ���
            %         Ҳ������ָ����ʼ������ ��Ҫ�Բ����������д���
            
            %����Ĳ�����һ���Ѿ�ʵ�����Ķ���
            if 1==length(varargin)
                if isa(varargin{1},obj.classname)
                    obj.Append(varargin{1});
                    return;
                end
            end
            
            %ָ����ʼ������ 
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
            %����һ������ ֱ�Ӹ���id 
            r=obj.objects(arg);
        
        end
        function r=GetByIdentifier(obj,arg)%���ݱ�ʶ������
            for it=1:obj.num
                if isequal(arg,obj.GetIdentifier(obj.objects(it),obj.identifier))
                    r=obj.objects(it);
                    return;
                end
            end
            warning('δ�ҵ�,����һ���վ���')
            r=[];
            return;
        end
        function Append(obj,newobj)%ĩβ����һ��
            obj.objects=[ obj.objects newobj];
            obj.num=obj.num+1;
        end
        function Insert(obj,newobj,index)%��index֮�����һ��
            obj.objects=[obj.objects(1:index) newobj obj.objects(index+1:end)];
            obj.num=obj.num+1;
        end
        function Overwrite(obj,newobj,index)%��index������һ������
            %rewrite �����Ƿ�ʽ
            %0 �����µ� �����ɵ�
            %1 ���� �ɵ� ��ɺ��µ�����һģһ��

            if obj.flag_rewrite==obj.REWRITE_FALSE
                obj.objects(index)=newobj;
            elseif obj.flag_rewrite==obj.REWRITE_TRUE
                obj.objects(index).copy(newobj)%ִ����������Ҫ��copy����
            else
                error('��');
            end
        end
        function disp(obj)%�Զ������
            disp(['handle����������ͣ�' class(obj)]);
            disp(['�������' obj.classname]);
            disp(['��������ʶ����' obj.identifier]);
            disp(['�������������' num2str(obj.num)]);
            if length(obj)>1||obj.num==0
                %warning('����������Ϊ1���ݲ�֧�����');
                return;
            end
            obj.objects.disp();
        end


    end
    properties(Constant,Hidden)
        REWRITE_TRUE=1%ö�ٱ��� ���Ƹ��Ƿ�ʽ
        REWRITE_FALSE=0
        
    end
    methods(Static)
        function id=GetIdentifier(x,identifier)%���ض���ı�ʶ��
            id=eval(['x.' identifier ';']);
        end
    end
   
end

