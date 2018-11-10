classdef HANDLE_CLASS_MANAGER_UNIQUE_SORTED<HCM.HANDLE_CLASS_MANAGER_UNIQUE
    %����ϵ��handleclass���� �����ǻ���ģ���Ա�ʶ�������������(����)
    
    
    properties
        
    end
    
    methods
        function obj = HANDLE_CLASS_MANAGER_UNIQUE_SORTED(classname,identifier)
            %UNTITLED17 ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj=obj@HCM.HANDLE_CLASS_MANAGER_UNIQUE(classname,identifier);
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
                    idadd=HCM.HANDLE_CLASS_MANAGER.GetIdentifier(varargin{1},obj.identifier);
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
                        pos=obj.GetPos(idadd);
                        obj.Insert(varargin{1},pos);
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
            idadd=HCM.HANDLE_CLASS_MANAGER.GetIdentifier(tmp,obj.identifier);
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
                pos=obj.GetPos(idadd);
                obj.Insert(tmp,pos);
                return;
            end

        end        
        function pos=GetPos(obj,id)
            %��ȡ�¶���id��Ӧ�����λ�� �����ֵ��
            if length(obj.identifiers)==0%�ޱ�ʶ��ʱ ����0
                pos=0;
                return;
            end
            if isa(id,'double')%��ʶ��������
                for it=1:length(obj.identifiers)
                    if obj.identifiers{it}>id
                        pos=it-1;
                        return;
                    end
                end
                pos=length(obj.identifiers);
                return;
            elseif isa(id,'char')%�ַ���
                for it=1:length(obj.identifiers)
                    if StrBTStr(obj.identifiers{it},id)
                        pos=it-1;
                        return;
                    end
                end
                pos=length(obj.identifiers);
                return;
            end
            error('δ֪����')

        end

    end
    
end

