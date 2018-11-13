classdef HANDLE_CLASS_MANAGER_UNIQUE<HCM.HANDLE_CLASS_MANAGER
    %����ϵ��handleclass���� �����ǻ���ģ���Ա�ʶ����
    
    properties
        identifiers cell%����ӵı�ʶ��
        flag_overwrite logical%ָ���Ƿ񸲸�ͬ������
    end
    
    methods
        function obj = HANDLE_CLASS_MANAGER_UNIQUE(classname,identifier)
            %UNTITLED15 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj=obj@HCM.HANDLE_CLASS_MANAGER(classname,identifier);
            obj.identifiers={};
            obj.flag_overwrite=obj.OVERWRITE_FALSE;%Ĭ�ϲ�����ͬ������
        end
        function Add(obj,varargin)
            %��дadd�� ��֤������
            %ʹ��eval�����¶��� ���캯��Ϊclassname 
            %����Ĳ���������һ���Ѿ�ʵ�����Ķ���
            %         Ҳ������ָ����ʼ������ ��Ҫ�Բ����������д���
            
            %����Ĳ�����һ���Ѿ�ʵ�����Ķ���
            if 1==length(varargin)
                if isa(varargin{1},obj.classname)
                    %�жϻ���
                    idadd=obj.GetIdentifier(varargin{1},obj.identifier);
                    [r,i]=IsIn(idadd,obj.identifiers);
                    if r==true
                        %����
                        warning('MATLAB:mywarning','�˶�������');
                        %����ow�ж��Ƿ񸲸�
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

                    else%δ��
                        obj.Append(varargin{1});
                        return;
                    end
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
            idadd=HANDLE_CLASS_MANAGER.GetIdentifier(tmp,obj.identifier);
            [r,i]=IsIn(idadd,obj.identifiers);
            if r==true
                %����
                warning('MATLAB:mywarning','�˶�������');
                %����ow�ж��Ƿ񸲸�
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
            else%δ��
                obj.Append(tmp);
                
                return;
            end

        end
        function Append(obj,newobj)%��д
            obj.objects=[ obj.objects newobj];
            obj.identifiers=[obj.identifiers,obj.GetIdentifier(newobj,obj.identifier)];
            obj.num=obj.num+1;
        end        
        function Insert(obj,newobj,index)%��дinsert���� ��Ϊ�漰��idtentifier
            obj.objects=[obj.objects(1:index) newobj obj.objects(index+1:end)];
            obj.identifiers=[obj.identifiers(1:index) obj.GetIdentifier(newobj,obj.identifier) obj.identifiers(index+1:end)];
            obj.num=obj.num+1;
        end



    end
    properties(Constant,Hidden)
        OVERWRITE_TRUE=1%ö�ٱ��� �����Ƿ񸲸�ͬ������
        OVERWRITE_FALSE=0
        
    end    
end

