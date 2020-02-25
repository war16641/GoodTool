classdef NODE<handle
    %����ฺ�����FEM2D�Ľڵ�
    
    properties
        f FEM3DFRAME%��������һ������Ԫ
        nds %��vcm���� ��һ����id �����������깹�ɵľ���

        nds_mapping %�ڵ�����նȾ����ӳ�� ��һ���ǽڵ��� �ڶ����ǽڵ�x���ɶȶ�Ӧ����� 
        nds_mapping_r %nds_mapping�ķ����� ��һ������� �ڶ����ǽڵ�
        maxnum%ʹ�õ������
        ndnum%�ڵ����
    end
    
    methods
        function obj = NODE(f)
            obj.f=f;
            obj.maxnum=0;
            obj.ndnum=0;
            obj.nds=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.nds_mapping=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            obj.nds_mapping_r=VCM.VALUE_CLASS_MANAGER_UNIQUE_SORTED();
            
        end
        function AddByCartesian(obj,id,x,y,z)
            if 0==id%��������һ
                id=obj.maxnum+1;
                obj.nds.Append(id,[x y z]);
                return;
            end
            obj.nds.Add(id,[x y z],1);
            

        end
        function v=get.maxnum(obj)
            if 0==obj.ndnum
                obj.maxnum=0;
                v=obj.maxnum;
                return;
            end
            obj.maxnum=obj.nds.object{end,1};
            v=obj.maxnum;
        end
        function v=get.ndnum(obj)
            obj.ndnum=size(obj.nds.object,1);
            v=obj.ndnum;
        end
        function flag=IsExist(obj,id)
            %�ж�ĳ���ڵ��Ƿ����
            i=obj.nds.FindId(id);
            if i==0%û�ҵ�
                flag=false;
                return;
            else
                flag=true;
                return;
            end
        end
        function xyz = GetCartesianByID(obj,id)
            xyz=obj.nds.Get('id',id);
            if isempty(xyz)
                error('δ�ҵ��ڵ�');
            end
            
        end
        function xuhao=GetXuhaoByID(obj,id)%ͨ��id��øնȾ����е���� �ýڵ�ux���ڵ����
          xuhao=obj.nds_mapping.Get('id',id);
          if isempty(xuhao)
              error('�޴˽ڵ�');
          end
        end
        function [id,index,label]=GetIdByXuhao(obj,xh)%ͨ���նȾ����е���Ż�ýڵ�id 
            %�Ƚ�xh�ŵ�ux�� ������index��label
            yushu=mod(xh,6);
            switch yushu
                case 1
                    label='ux';
                    index=1;
                case 2
                    label='uy';index=2;
                 case 3
                    label='uz';index=3;
                case 4
                    label='rx';index=4;
                case 5
                    label='ry';index=5;
                 case 0
                    label='rz';index=6;yushu=6;
            end
            
            %����id
            xh=xh-yushu+1;%������ƶ������ڵ��ux���ɶ���
            id=obj.nds_mapping_r.Get('id',xh);
            if isempty(id)
                error('δ�ҵ�')
            end
        end
        function SetupMapping(obj)%�����ڵ����ɶȶԸնȾ���(K)��ӳ�� 
            %�������ִ��Ӧ��solve�е���
            %�˺���ִ�к� ��Ӧ�ٶԽڵ���в�����
            
            %���ȼ���Ƿ��ѽ���mapping
            if obj.ndnum==obj.nds_mapping.num
                return;%�Ѿ�����
            elseif obj.nds_mapping.num==0%δ����
            else%������һ���������ġ�
                error('�Ѿ������˲�������ӳ��')
            end
            
            lastx=-5;
            for it=1:obj.ndnum
                lastx=lastx+6;
                obj.nds_mapping.Append(obj.nds.object{it,1},lastx);
                obj.nds_mapping_r.Append(lastx,obj.nds.object{it,1});
            end
            obj.nds_mapping.Check();
            obj.nds_mapping_r.Check();
        end
        function LoadFromMatrix(obj,mt)%�Ӿ��������� ��һ����id ������xy %��Ҫ����
            for it=1:size(mt,1)
                AddByCartesian(obj,mt(it,1),mt(it,2),mt(it,3));
            end
        end
        function r=DirBy2Node(obj,i,j)
            %���ش�i��j�ĵ�λ����
            xyz1=obj.GetCartesianByID(i);
            xyz2=obj.GetCartesianByID(j);
            r=xyz2-xyz1;
            r=r/norm(r);%��λ��
        end
        function d=Distance(obj,i,j)%���������ڵ�ľ���
            xyz1=obj.GetCartesianByID(i);
            xyz2=obj.GetCartesianByID(j);
            r=xyz2-xyz1;
            d=sqrt(sum(r.^2));
        end

    end
    methods(Static)
        
    end
end

