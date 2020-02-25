classdef NodeResultFrame<handle

    
properties
        rf ResultFrame
        force VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%�ڵ���(���Խڵ����) solve���� ��һ���ǽڵ��� �ڶ�����6*1 double
        displ VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%�ڵ�λ��
        displ_t VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%�ڵ��ٶ�
        displ_tt VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED%�ڵ���ٶ�
    end
    
    methods
        function obj = NodeResultFrame(rf)
            obj.rf=rf;
            obj.force=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.displ=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.displ_t=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.displ_tt=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
        end
        function Make(obj,varargin)%�ӽڵ����ͽڵ�λ������������������force��displ
            if obj.force.num~=0||obj.displ.num~=0
                error('matlab:myerror','����ڵ���ʱ�����нڵ�����')
            end
            %Ԥ����
            varargin=Hull(varargin);
            if length(varargin)==2
                vector_f=varargin{1};
                vectro_u=varargin{2};
                t=length(vector_f);%��ָ���ٶȺͼ��ٶ�ʱ ��Щ������Ϊ0
                vector_u_t=zeros(t,1);
                vector_u_tt=zeros(t,1);
            elseif length(varargin)==4
                vector_f=varargin{1};
                vectro_u=varargin{2};
                vector_u_t=varargin{3};
                vector_u_tt=varargin{4};
            else
                error('δ֪����')
            end
            node=obj.rf.rst.lc.f.node;
            for it=1:node.ndnum
                [~,id]=node.nds.Get('index',it);
                xuhao=node.GetXuhaoByID(id);
                obj.displ.Append(id,vectro_u(xuhao:xuhao+5)');
                obj.force.Append(id,vector_f(xuhao:xuhao+5)');%��Ϊ֪���ڵ����������� ����ֱ��append����add
                obj.displ_t.Append(id,vector_u_t(xuhao:xuhao+5)');
                obj.displ_tt.Append(id,vector_u_tt(xuhao:xuhao+5)');
            end
            obj.displ.Check();
            obj.force.Check();
        end


        function r=Get(obj,varargin)%��ȡ���
            %type force����displ
            %id �ڵ��� 'all'
            %dir ��������� 1~6 ���� ux uy uz rx ry rz ���� [1 3] ���� 'all'
            %���һ������ָ�� λ�� �ٶ� ���ٶ� '' 'vel' 'acc'
            varargin=Hull(varargin);%ȥ�������cell�� 
            type=varargin{1};
            id=varargin{2};
            dir=varargin{3};
            %��dir��������
            dir=EleResultFrame.FreedomInterpreter(dir);
            if length(varargin)==3%û��ָ�����һ������
                tar=obj.displ;%Ĭ��λ��
            elseif length(varargin)==4
                switch varargin{4}
                    case ''
                        tar=obj.displ;
                    case 'vel'
                        tar=obj.displ_t;
                    case 'acc'
                        tar=obj.displ_tt;
                    otherwise
                        error('sd');
                end
            else
                error('δ֪����')
            end
            
            %����
            switch type(1)
                case 'f'
                    if ~isequal(id,'all')
                        tmp=obj.force.Get('id',id);
                        r=tmp(dir);
                    else
                        r=zeros(1,obj.displ.num*length(dir));
                        for it=1:obj.force.num
                            tmp=obj.force.Get('id',it);
                            r((it-1)*length(dir)+1:it*length(dir))=tmp(dir);
                        end
                    end
                    
                case 'd'
                    if ~isequal(id,'all')
                        tmp=tar.Get('id',id);
                        r=tmp(dir);
                    else%��ȡ���нڵ�
                        r=zeros(1,obj.displ.num*length(dir));
                        for it=1:obj.displ.num
                            tmp=tar.Get('id',it);
                            r((it-1)*length(dir)+1:it*length(dir))=tmp(dir);
                        end
                    end
                    
                    
                    
                otherwise
                    error('matlab:myerror','δ֪���ɶ�')
            end
            
        end
        function LoadFromState(obj)
            lc=obj.rf.rst.lc;
            
            for it=1:lc.f.node.nds.num
                [~,ndid]=lc.f.node.nds.Get('index',it);%��ȡ�ڵ���
                xh=lc.f.node.GetXuhaoByID(ndid);%��ȡ�ڵ��Ӧ�ľ������
                
                %д��λ�ƽ��
                tmp=lc.u(xh:xh+5);
                tmp=tmp';
                obj.displ.Add(ndid,tmp);
                %д�������
                tmp=lc.f_ele(xh:xh+5);
                tmp=tmp';
                obj.force.Add(ndid,tmp);
                %д���ٶ�
                tmp=lc.du(xh:xh+5);
                tmp=tmp';
                obj.displ_t.Add(ndid,tmp);
                %д����ٶ�
                tmp=lc.ddu(xh:xh+5);
                tmp=tmp';
                obj.displ_tt.Add(ndid,tmp);
            end
        end

    end
    methods(Access=private)

    end

end
