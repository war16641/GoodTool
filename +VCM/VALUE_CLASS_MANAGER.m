classdef VALUE_CLASS_MANAGER<handle
    %ֵ�������
    %�������object��n*2��cell ��һ����id �ڶ�����ֵ��
    %������������ڴ�ռ�ý�С������ ����С��ֵ����
    
    properties
        object cell%�������
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
            %type��'index'��'id'
            %δ�ҵ����ؿվ���
            switch type(1:2)
                case 'in'%ͨ������
                    o=obj.object{arg1,2};
                    return;
                case 'id'%ͨ��id �㷨����
                    for it=1:obj.num
                        if arg1==obj.object{it,1}
                            o=obj.object{it,2};
                            return;
                        end
                    end
                    o=[];
                    return;
                otherwise
                    error('δ֪����')
            end
        end
        function [index]=FindId(obj,id)%�ж�id�Ƿ��������� ��������ھͷ���0
            %��������
            for it=1:obj.num
                if isequal(id,obj.object{it,1})
                    index=it;
                    return;
                end
                index=0;
            end
        end
        
    end
    methods(Access=protected)
        function Append(obj,id,newobj)
            obj.object=[obj.object;{id,{newobj}}];
            obj.num=obj.num+1;
        end
        function Insert(obj,index,id,newobj)
            %��insert֮�����һ��
            obj.object=[obj.object(1:index,:) ;{id,newobj}; obj.object(index+1:end,:)];
            obj.num=obj.num+1;
        end
        function Overwrite(obj,type,arg1,newobj)
            %type������ 'index' ��'id'
            switch type(1:2)
                case 'in'%ͨ������
                    obj.object(arg1,2)={newobj};
                    return;
                case 'id'%ͨ��id �㷨����
                    for it=1:obj.num
                        if arg1==obj.object{it,1}
                            obj.object(it,2)={newobj};
                            return;
                        end
                    end
                    error('δ�ҵ�')
                otherwise
                    error('δ֪����')
            end
        end
    end
end

