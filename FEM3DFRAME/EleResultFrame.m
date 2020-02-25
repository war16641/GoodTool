classdef EleResultFrame<handle
    %UNTITLED �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        rf ResultFrame
        force VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%��Ԫ�� �ڵ�Ե�Ԫ���� �ֲ����� ��һ���ǵ�Ԫid �ڶ���n*6��ֵ����
        %�������ǽڵ�Ե�Ԫ����
        deform VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%��Ԫ���� �ֲ����� ��һ���ǵ�Ԫid
        eng VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%��Ԫ����
    end
    
    methods
        function obj = EleResultFrame(rf)
            obj.rf=rf;
            obj.force=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.deform=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.eng=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
        end
        
        function Make(obj)
            %uΪ�ڵ�λ�� ��������
            ele=obj.rf.rst.lc.f.manager_ele;
            eng_summation=[0 0 0];%�ṹ��������
            for it=1:ele.num
                e=ele.Get('index',it);
                ndnum=length(e.nds);%�õ�Ԫ�ڵ�����
                switch ndnum
                    case 1%�����ڵ� ������
                        u_t=obj.rf.ndrst.Get('displ',e.nds(1),'all','vel');%��ȡ�ٶ�
                        [force,deform,eng]=e.GetEleResult({[],u_t,[]});
                        obj.force.Append(e.id,force);
                        obj.deform.Append(e.id,deform);
                        obj.eng.Append(e.id,eng);
                        eng_summation=eng_summation+eng;
                    case 2%���ڵ� ����
                        %ȡ���ڵ��λ��
                        ui=obj.rf.ndrst.Get('displ',e.nds(1),'all');
                        uj=obj.rf.ndrst.Get('displ',e.nds(2),'all');%�ر�ע�� ��������˽ڵ���֡��noderesultframe�� ���Ҫ�ȱ�֤��������Ѿ�׼������
                        [force,deform,eng]=e.GetEleResult([ui;uj]);
                        obj.force.Append(e.id,force);
                        obj.deform.Append(e.id,deform);
                        obj.eng.Append(e.id,eng);
                        eng_summation=eng_summation+eng;
                    otherwise
                        error('matlab:myerror','û������ô��ڵ�ĵ�Ԫ��')
                end
            end
            obj.rf.engrst=eng_summation;%���ṹ������д��rf��
            obj.force.Check();
            obj.deform.Check();
        end
        function r=Get(obj,varargin)
            % 'deform' eleid    freedom
            % 'force'  eleid    'i'        freedom
            %                   'j'
            %                   'ij'
            %'eng' eleid
            varargin=Hull(varargin);%ȥ�������cell�� 
            switch varargin{1}(1)
                case 'd'%����
                    eleid=varargin{2};
                    freedom=obj.FreedomInterpreter(varargin{3});
                    tmp=obj.deform.Get('id',eleid);
                    r=tmp(freedom);
                case 'f'%��Ԫ��
                    eleid=varargin{2};
                    freedom=obj.FreedomInterpreter(varargin{4});
                    eleend=varargin{3};
                    if strcmp(eleend,'i')
                        hang=1;
                    elseif strcmp(eleend,'j')
                        hang=2;
                    elseif strcmp(eleend,'ij')
                        hang=[1 2];
                    else
                        error('matlab:myerror','δ֪���͡�')
                    end
                    tmp=obj.force.Get('id',eleid);
                    r=tmp(hang,freedom);
                case 'e'%����
                    eleid=varargin{2};
                    r=obj.eng.Get('id',eleid);
                otherwise
                    error('matlab:myerror','δ֪���͡�')
            end
        end
        function LoadFromState(obj)
            lc=obj.rf.rst.lc;
            for it=1:lc.f.manager_ele.num
                [e,eleid]=lc.f.manager_ele.Get('index',it);%��ȡ��Ԫid
                obj.force.Add(eleid,e.state.force_);
                obj.deform.Add(eleid,e.state.deform_);
                obj.eng.Add(eleid,e.state.eng);
                obj.rf.engrst=obj.rf.engrst+e.state.eng;%���½ṹ��������
%                 if length(e.nds)==1%���ڵ㵥Ԫ
%                     obj.force.Add(eleid,zeros(6,1));
%                     obj.deform.Add(eleid,zeros(6,1));
%                     obj.eng.Add(eleid,e.state.eng);
%                 elseif length(e.nds)==2%˫�ڵ㵥Ԫ
%                     obj.force.Add(eleid,e.state.force_);
%                     obj.deform.Add(eleid,e.state.deform_);
%                     obj.eng.Add(eleid,e.state.eng);
%                 else
%                     error('sd');
%                 end
            end
        end
    end
    methods(Static)
        function freedom=FreedomInterpreter(x)%���ɶȽ�����
            if isa(x,'char')
                switch x
                    case 'ux'
                        freedom=1;
                    case 'uy'
                        freedom=2;
                    case 'uz'
                        freedom=3;
                    case 'rx'
                        freedom=4;
                    case 'ry'
                        freedom=5;
                    case 'rz'
                        freedom=6;
                    case 'all'
                        freedom=1:6;
                    otherwise
                        error('matlab:myerror','δ֪���ɶ�')
                end
            elseif isa(x,'double')
                %���ﻹ����д ��֤ ������1~6֮��
                freedom=x;
            else
                error('matlab:myerror','δ֪���ɶ�')
            end
        end
    end
end

