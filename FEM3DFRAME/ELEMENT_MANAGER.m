classdef ELEMENT_MANAGER<VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED
    %��Ԫ��������Ҫʹ���Զ�����ż�1�Ĺ���
    
    properties
        maxnum
    end
    
    methods
        function obj = ELEMENT_MANAGER()
            obj=obj@VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.maxnum=0;
        end
        
        function r = get.maxnum(obj)
            %����maxnum��get���� ͬʱ������ڲ�����maxnum
            if obj.num==0%������
                obj.maxnum=0;
                r=0;
                return;
            end
            obj.maxnum=obj.object{end,1};
            r=obj.maxnum;
            return;
        end
        function Add(obj,varargin)
            %����ELEMENT3DFRAME�ǳ������ ����ʹ��һ�Ѳ���ʵ�� ֻ����ʵ���õĶ������
            
            if length(varargin)~=1
                error('MATLAB:myerror','��ʹ��ʵ�����Ķ������')
            end
            newobj=varargin{1};
            success=obj.Add@VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED(newobj.id,newobj);
            if 0==success
                error('matlab:myerror','�˵�Ԫid�Ѵ���')
            end
                       
        end
    end
end

