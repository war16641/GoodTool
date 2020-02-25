
classdef FEM3DFRAME <handle
    %UNTITLED3 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        node NODE
        manager_mat %���Ϲ�����
        manager_sec %���������
        manager_ele %��Ԫ������
        manager_lc %����������

        flag_nl%��ʶ��������Ƿ��Ƿ�����Ĭ �������Ե�0
        
        
        K double%�ṹ�նȾ��� 
        
    end
    
    methods
        function obj = FEM3DFRAME()
            obj.node=NODE(obj);
            obj.manager_mat=HCM.HANDLE_CLASS_MANAGER_UNIQUE_SORTED('MATERIAL','name');
            obj.manager_sec=HCM.HANDLE_CLASS_MANAGER_UNIQUE_SORTED('SECTION','name');
            obj.manager_ele=ELEMENT_MANAGER();
            obj.manager_lc=HCM.HANDLE_CLASS_MANAGER_UNIQUE('LoadCase','name');
            obj.flag_nl=0;
        end
        

        function LoadFromMatrix(obj,nodeinfo,eleinfo,et)
            for it=1:size(nodeinfo,1)
                obj.AddNode(nodeinfo(it,2),nodeinfo(it,3));
            end
            for it=1:size(eleinfo,1)
                obj.AddEle(et,[eleinfo(it,2) eleinfo(it,3) eleinfo(it,4) ]);
            end
        end
        function LoadFormANSYS(obj,dbpath)%��ansys db�ļ�������
            %dbpath��·�����ļ���
            %˼·������ansys������ļ� ������ͼ��� ����ڵ�͵�Ԫ��Ϣ 
            %����ansys
            
            ansysele='F:\ansys\eleinfo.txt';%ansys�Ľڵ㵥Ԫ�ļ�Ĭ�ϱ���·��
            ansysnd='F:\ansys\nodeinfo.txt';
            %����ģ������ansys������
            fid=fopen('template.txt','r');
            mycodepath='F:\ansys\ansyscodebyFEM2D.txt';
            fid1=fopen(mycodepath,'w');
            lnid=0;
            while(1)
                ln=fgetl(fid);
                lnid=lnid+1;
                if isempty(ln)
                    continue;
                end
                if ln==-1
                    break;
                end
                if lnid==3%��д��һ��
                    ln=['resume,' dbpath ',,,0'];
                end
                fprintf(fid1,'%s\r\n',ln);
            end
            fclose('all');
            %����ansys
            order=['"D:\prosoftware\ansys19\ANSYS Inc\ANSYS Student\v190\ansys\bin\winx64\ANSYS190.exe" -b -i ' mycodepath ' -o f:\ansys\tes.out' ];
            system(order);
            %��ȡ��fem��
            ndmt=ReadTxt(ansysnd,4,0);
            elemt=ReadTxt(ansysele,5,0);
            obj.node.LoadFromMatrix(ndmt(:,1:3));
            %���뵥Ԫʱ�������3�ڵ㻹���Ľڵ�
            if elemt(1,4)==elemt(1,5)%����
                obj.element.LoadFromMatrix(elemt(:,2:end-1),'triangle',obj.mat.mats);
            else%4��
                obj.element.LoadFromMatrix(elemt(:,2:end),'quadrangle',obj.mat.mats);
            end
            
  
        end


                
    end
end

