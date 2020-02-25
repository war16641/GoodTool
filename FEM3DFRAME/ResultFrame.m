classdef ResultFrame<handle
    %UNTITLED2 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        framename
        rst Result
        ndrst NodeResultFrame
        elerst EleResultFrame
        engrst%�ṹ������
    end
    
    methods
        function obj = ResultFrame(framename,rst,varargin)
            obj.framename=framename;
            obj.rst=rst;
            obj.engrst=[0 0 0];
            obj.ndrst=NodeResultFrame(obj);
            obj.elerst=EleResultFrame(obj);
%             obj.ndrst.Make(varargin);
%             obj.elerst.Make();
            
        end
        function r=Get(obj,varargin)

             % 'node'   'force'    nodeid   freedom
             % 'node'     'displ'   nodeid   freedom  ''
             %                                        'vel'
             %                                         'acc'
             %'ele'      'defrom'   eleid    freedom
             %           'force'    eleid    'i'        freedom
             %                               'j'
             %                               'ij'
             %'eng'
             varargin=Hull(varargin);%ȥ�������cell�� 
             rst_type=varargin{1};
             switch rst_type(1:2)
                 case 'no'%node
                     r=obj.ndrst.Get(varargin(2:end));%���ڲ㴫��
                 case 'el'%ele
                     r=obj.elerst.Get(varargin(2:end));%���ڲ㴫��
                 case 'en'%����
                     r=obj.engrst;
                 otherwise
                     error('sd')
             end
        end 
        function LoadFromState(obj)%��lc������
            obj.ndrst.LoadFromState();
            obj.elerst.LoadFromState();
        end
        

    end
end

