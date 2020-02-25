classdef Result<handle
    %UNTITLED �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        lc LoadCase
        pointer ResultFrame%��ǰ��ָ�� get�ķ���ֵ��Դ��pointerָ��Ľ��֡
        timeframe
        nontimeframe
    end
    
    methods
        function obj = Result(lc)
            obj.lc=lc;
            obj.timeframe=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.nontimeframe=VCM.VALUE_CLASS_MANAGER();
        end
        function SetPointer(obj,frametype,framename)
            %frametype ��ȡ'time' 'nontime'
            if nargin==1%ûָ��frametype,framename
                if obj.nontimeframe.num~=0
                    obj.pointer=obj.nontimeframe.Get('index',1);%����Ĭ��ָ�� Ϊ ��ʱ��֡�ĵ�һ��
                elseif obj.timeframe.num~=0
                    obj.pointer=obj.timeframe.Get('index',1);%����Ĭ��ָ�� Ϊ ʱ��֡�ĵ�һ��
                else
                    error('û�н��֡')
                end
                return;
            end
            switch frametype(1)
                case 't'%ʱ��
                    obj.pointer=obj.timeframe.Get('id',framename);
                case 'n'%��ʱ��
                    obj.pointer=obj.nontimeframe.Get('id',framename);
                otherwise
                    error('sd')
            end
        end
        function AddNontime(obj,framename,vector_f,vectro_u)
            tmp=ResultFrame(framename,obj,vector_f,vectro_u);
            obj.nontimeframe.Add(framename,tmp);
        end
        function AddTime(obj,idname,varargin)%��ӻ������֣�ʱ�� ����������Ľ��֡
            %idname ��ʱ�̹����б�ʾʱ�� �����񹤿��б�ʾ����
            tmp=ResultFrame(idname,obj,varargin);
            obj.timeframe.Add(idname,tmp);
        end
        function AddByState(obj,framename,type)
            tmp=ResultFrame(framename,obj);
            tmp.LoadFromState();
            switch type
                case 'time'
                    obj.timeframe.Add(framename,tmp,0);
                case 'nontime'
                    obj.nontimeframe.Add(framename,tmp);
                otherwise
                    error('sd')
            end
        end
        function r = Get(obj,varargin)
            %rst_type node ���� ele
            %rst_type='node'    type='force' 'displ'
             %                             id �ڵ�id
             %                             dir ����
            r=obj.pointer.Get(varargin);


        end
        function [r,tn]=GetTimeHistory(obj,t1,t2,varargin)%��ȡʱ�̽��
            if t1<0||isempty(t1)
                t1=0;
            end
            if t2>obj.timeframe.Get('index',obj.timeframe.num)||isempty(t2)
                t2=obj.timeframe.Get('index',obj.timeframe.num);
            end
            [ind1,index1]=obj.timeframe.FindId(t1);
            [ind2,index2]=obj.timeframe.FindId(t2);%������ʼ�ͽ���������
            if index1==0
                index1=1;
            end
            index1=max([ind1 index1]);
            index2=max([ind2 index2]);
            numline=index2-index1+1;%���֡����
            r=[];
            tn=[];
            for it=index1:index2
                tmp=obj.timeframe.Get('index',it);
                r1=tmp.Get(varargin);
                r=[r;r1];
                tn=[tn;tmp.framename];
            end
        end
    end
end

