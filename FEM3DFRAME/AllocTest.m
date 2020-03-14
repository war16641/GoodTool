%runtests('AllocTest.m')
%r = runperf('AllocTest')
classdef AllocTest < matlab.perftest.TestCase   % ���ܲ��ԵĹ�������
    
    methods(Test)
        
        function test1(testcase)
            f=FEM3DFRAME();
            f.node.AddByCartesian(0,1,1,1);
            f.node.AddByCartesian(0,2,1,1);
            f.node.AddByCartesian(0,3,1,1);
            testcase.verifyTrue(f.node.ndnum==3,'��ӽڵ���󣨲�ָ��id)');
            testcase.verifyTrue(f.node.maxnum==3,'��ӽڵ���󣨲�ָ��id)');
            testcase.verifyTrue(f.node.nds.object{end,1}==3,'��ӽڵ���󣨲�ָ��id)');
            
            %ָ��id ���
            f.node.AddByCartesian(4,4,1,1);
            testcase.verifyTrue(f.node.ndnum==4,'��ӽڵ����ָ��id)');
            testcase.verifyTrue(f.node.maxnum==4,'��ӽڵ����ָ��id)');
            testcase.verifyTrue(f.node.nds.object{end,1}==4,'��ӽڵ����ָ��id)');
            
            %��������������
            f.node.AddByCartesian(10,10,1,1);
            testcase.verifyTrue(f.node.ndnum==5,'��ӽڵ����ָ��id)');
            testcase.verifyTrue(f.node.maxnum==10,'��ӽڵ����ָ��id)');
            
            testcase.verifyTrue(f.node.nds.object{end,1}==10,'��ӽڵ����ָ��id)');
            
            %����һ���ڵ����հ״�
            f.node.AddByCartesian(5,5,1,1);
            testcase.verifyTrue(f.node.ndnum==6,'��ӽڵ����ָ��id)');
            testcase.verifyTrue(f.node.maxnum==10,'��ӽڵ����ָ��id)');
            testcase.verifyTrue(f.node.nds.object{end-1,1}==5,'��ӽڵ����ָ��id)');
            
            %����һ���ڵ�����ֵ��
            f.node.AddByCartesian(5,5,2,1);
            testcase.verifyTrue(f.node.ndnum==6,'��ӽڵ����ָ��id)');
            testcase.verifyTrue(f.node.maxnum==10,'��ӽڵ����ָ��id)');
            tmp=f.node.nds.Get('index',f.node.ndnum-1);
            testcase.verifyTrue(tmp(2)==2,'��ӽڵ����ָ��id)');
            tmp=f.node.nds.Get('index',f.node.ndnum-1);
            testcase.verifyTrue(tmp(2)==2,'��ӽڵ����ָ��id)');
            f.node.AddByCartesian(11,1,1,2);
            
            %��Ӳ���
            f.manager_mat.Add(1,0.2,1,'concrete');
            f.manager_mat.objects(1)
            testcase.verifyTrue(strcmp(f.manager_mat.objects(1).name,'concrete'),'��Ӳ��ϴ���');
            f.manager_mat.Add(10,0.2,1,'steel');
            tmp=f.manager_mat.GetByIndex(2);
            testcase.verifyTrue(strcmp(tmp.name,'steel'),'��Ӳ��ϴ���');
            tmp=f.manager_mat.GetByIdentifier('concrete');
            testcase.verifyTrue(tmp.E==1,'��Ӳ��ϴ���');
            tmp=MATERIAL(2,0.2,1,'c30');
            f.manager_mat.Add(tmp);
            tm=f.manager_mat.GetByIdentifier('c30');
            testcase.verifyTrue(tm.v==0.2,'��Ӳ��ϴ���');
            tmp=f.manager_mat.GetByIdentifier('c50');
            testcase.verifyTrue(isempty(tmp),'��Ӳ��ϴ���');
            
            %��ӽ���
            % mat=f.manager_mat.objects(1);
            % f.manager_sec.Add('pile',mat,1,1,1);
            % f.manager_sec.Add('cap',mat,2,2,2);
            % tmp=SECTION('girder',mat,3,3,3);
            % f.manager_sec.Add(tmp);
            % tmp=f.manager_sec.GetByIndex(1);
            % testcase.verifyTrue(tmp.A==1,'��ӽ������');
            % tmp=f.manager_sec.GetByIdentifier('cap');
            % testcase.verifyTrue(tmp.A==2,'��ӽ������');
            % tmp=f.manager_sec.GetByIdentifier('girder');
            % testcase.verifyTrue(tmp.A==3,'��ӽ������');
            % tmp=f.manager_sec.GetByIdentifier('cap1');
            % testcase.verifyTrue(isempty(tmp),'��ӽ������');
            % tmp=SECTION('girder',mat,300,3,3);
            % testcase.verifyWarning(@()f.manager_sec.Add(tmp),'MATLAB:mywarning');
            % f.manager_sec.flag_overwrite=f.manager_sec.OVERWRITE_FALSE;
            % f.manager_sec.Add(tmp);
            % testcase.verifyFalse(300==f.manager_sec.objects(3).A,'��ӽ������');
            % f.manager_sec.flag_overwrite=1;
            % f.manager_sec.Add(tmp);
            % testcase.verifyTrue(300==f.manager_sec.objects(3).A,'��ӽ������');
            mat=f.manager_mat.objects(1);
            f.manager_sec.Add('pile',mat,1,1,1);
            f.manager_sec.Add('cap',mat,2,2,2);
            tmp=SECTION('girder',mat,3,3,3);
            f.manager_sec.Add(tmp);
            tmp=f.manager_sec.GetByIndex(1);
            testcase.verifyTrue(tmp.A==2,'��ӽ������');
            tmp=f.manager_sec.GetByIdentifier('cap');
            testcase.verifyTrue(tmp.A==2,'��ӽ������');
            tmp=f.manager_sec.GetByIdentifier('girder');
            testcase.verifyTrue(tmp.A==3,'��ӽ������');
            tmp=f.manager_sec.GetByIdentifier('cap1');
            testcase.verifyTrue(isempty(tmp),'��ӽ������');
            tmp=SECTION('girder',mat,300,3,3);
            testcase.verifyWarning(@()f.manager_sec.Add(tmp),'MATLAB:mywarning');
            f.manager_sec.flag_overwrite=f.manager_sec.OVERWRITE_FALSE;
            f.manager_sec.Add(tmp);
            testcase.verifyFalse(300==f.manager_sec.objects(2).A,'��ӽ������');
            f.manager_sec.flag_overwrite=1;
            f.manager_sec.Add(tmp);
            testcase.verifyTrue(300==f.manager_sec.objects(2).A,'��ӽ������');
            
            %��ӵ�Ԫ
            sec=f.manager_sec.GetByIndex(1);
            tmp=ELEMENT_EULERBEAM(f,1,[2 1],sec);
            f.manager_ele.Add(tmp);
            testcase.verifyTrue(1==f.manager_ele.maxnum,'��ӵ�Ԫ����');
            testcase.verifyError(@()f.manager_ele.Add(f,2,[1 2],sec),'MATLAB:myerror','��ӵ�Ԫ����');
            testcase.verifyError(@()f.manager_ele.Add(f,2,[1 2]),'MATLAB:myerror','��ӵ�Ԫ����');
            testcase.verifyError(@()ELEMENT_EULERBEAM(f,1,[1 6],sec),'MATLAB:myerror','��ӵ�Ԫ����');
            tmp=ELEMENT_EULERBEAM(f,0,[1 10],sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 10],sec);
            f.manager_ele.Add(tmp);
            testcase.verifyTrue((2==f.manager_ele.num)&&(2==f.manager_ele.maxnum),'��ӵ�Ԫ����');
            tmp=ELEMENT_EULERBEAM(f,10,[1 10],sec);
            f.manager_ele.Add(tmp);
            testcase.verifyTrue((3==f.manager_ele.num)&&(10==f.manager_ele.maxnum),'��ӵ�Ԫ����');
            tmp=ELEMENT_EULERBEAM(f,0,[1 10],sec);
            f.manager_ele.Add(tmp);
            testcase.verifyTrue((4==f.manager_ele.num)&&(11==f.manager_ele.maxnum),'��ӵ�Ԫ����');
            tmp=ELEMENT_EULERBEAM(f,0,[1 11],sec);
            f.manager_ele.Add(tmp);
            
            
            
            %��֤��������
            f.node.AddByCartesian(100,0,0,0);
            f.node.AddByCartesian(101,1,0,1);
            tmp=ELEMENT_EULERBEAM(f,0,[100 101],sec);
            f.manager_ele.Add(tmp);
            t1=f.manager_ele.Get('index',f.manager_ele.num);
            testcase.verifyTrue(norm(t1.zdir-[-1/sqrt(2) 0 1/sqrt(2)])<1e-10,'��ӵ�Ԫ����');
            tmp=ELEMENT_EULERBEAM(f,0,[100 101],sec,[0 1 0]);
            f.manager_ele.Add(tmp);
            t1=f.manager_ele.Get('index',f.manager_ele.num);
            testcase.verifyTrue(norm(t1.zdir-[0 1 0])<1e-10,'��ӵ�Ԫ����');
            
            
        end
        function test_verifymodel1(testcase)
            %��֤ģ��1 ������ 2�ڵ�
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1.14,0,1);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            %ʵ�������д���ڵ�ĵ�Ԫ
            testcase.verifyError(@()ELEMENT_EULERBEAM(f,0,[1001 1002],sec,[0 -1 0]),'MATLAB:myerror','��֤����');
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0]);%ָ��z����Ϊ-y����
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            %���ô���Ľڵ�߽����� �ڵ㲻����
            testcase.verifyError(@()lc.AddBC('displ',[1001 1 0;1001 2 0;1001 3 0;1001 4 0;1001 5 0;1001 6 0;]),'MATLAB:myerror','��֤����');
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[2 1 1;2 2 1;2 3 0;2 4 0;2 5 0;2 6 0;]);%���ҽڵ�ʩ������λ�� uyλ��
            
            lc.Solve();
            rea1=[-6.55	-10.67	6.63	5.33	-7.05	-6.08];
            rea2=[6.55	10.67	-6.63	5.33	-7.05	-6.08];%֧���������۽�sap2000�õ���
            % lc.noderst.Get('force',1,'all') lc.rst.Get('node','force',1,'all')
            testcase.verifyTrue(norm(lc.rst.Get('node','force',1,'all')-rea1)<0.01,'��֤����');
            testcase.verifyTrue(norm(lc.rst.Get('node','force',2,'all')-rea2)<0.01,'��֤����');
        end
        
        
        function test_verifymodel2(testcase)
            %��֤ģ��2 ������ 2�ڵ�
            f=FEM3DFRAME();
            f.node.AddByCartesian(1001,0,0,0);
            f.node.AddByCartesian(1002,1.14,0,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1001 1002],sec,[0 -1 0]);%ָ��z����Ϊ-y����
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1001 1 0;1001 2 0;1001 3 0;1001 4 0;1001 5 0;1001 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[1002 1 1;1002 2 1;1002 3 0;1002 4 0;1002 5 0; 1002 6 0;]);%���ҽڵ�ʩ������λ�� uyλ��
            lc.Solve();
            rea1=[-0.96 -25.11 0  0  0 -14.31 ];
            rea2=[0.96 25.11 0  0  0 -14.31 ];%֧���������۽�sap2000�õ���  lc.rst.Get('node','force',1,'all')
            testcase.verifyTrue(norm(lc.rst.Get('node','force',1001,'all')-rea1)<0.01,'��֤����');
            testcase.verifyTrue(norm(lc.rst.Get('node','force',1002,'all')-rea2)<0.01,'��֤����');
        end
        function test_verifymodel3(testcase)
            %��֤ģ��3 ��1��ģ�ͻ����Ͻ�z�����Ϊz��
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1.14,0,1);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            %ʵ�������д���ڵ�ĵ�Ԫ
            testcase.verifyError(@()ELEMENT_EULERBEAM(f,0,[1001 1002],sec,[0 -1 0]),'MATLAB:myerror','��֤����');
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);%ָ��z����Ϊz����
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            %���ô���Ľڵ�߽����� �ڵ㲻����
            testcase.verifyError(@()lc.AddBC('displ',[1001 1 0;1001 2 0;1001 3 0;1001 4 0;1001 5 0;1001 6 0;]),'MATLAB:myerror','��֤����');
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[2 1 1;2 2 1;2 3 0;2 4 0;2 5 0;2 6 0;]);%���ҽڵ�ʩ������λ�� uyλ��
            
            lc.Solve();
            rea1=[-5.05	-14.11	4.93	7.05	-5.33	-8.04];
            rea2=[5.05	14.11	-4.93	7.05	-5.33	-8.04];%֧���������۽�sap2000�õ���
            testcase.verifyTrue(norm( lc.rst.Get('node','force',1,'all')-rea1)<0.01,'��֤����');
            testcase.verifyTrue(norm( lc.rst.Get('node','force',2,'all')-rea2)<0.01,'��֤����');
        end
        function test_verifymodel4(testcase)
            %��֤ģ��4 ��3��ģ�� ���ظ�Ϊj�ڵ�����λ��Ϊ1
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1.14,0,1);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            %ʵ�������д���ڵ�ĵ�Ԫ
            testcase.verifyError(@()ELEMENT_EULERBEAM(f,0,[1001 1002],sec,[0 -1 0]),'MATLAB:myerror','��֤����');
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);%ָ��z����Ϊz����
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            
            %���ô���Ľڵ�߽����� �ڵ㲻����
            testcase.verifyError(@()lc.AddBC('displ',[1001 1 0;1001 2 0;1001 3 0;1001 4 0;1001 5 0;1001 6 0;]),'MATLAB:myerror','��֤����');
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[2 1 1;2 2 1;2 3 1;2 4 1;2 5 1;2 6 1;]);%���ҽڵ�ʩ������λ�� uyλ��
            
            lc.Solve();
            rea1=[5.21	-13.12	-7.5	2.94	4.84	-10.99];
            rea2=[-5.21	13.12	7.5	10.19	8.92	-3.97];%֧���������۽�sap2000�õ���
            testcase.verifyTrue(norm( lc.rst.Get('node','force',1,'all')-rea1)<0.01,'��֤����');
            testcase.verifyTrue(norm( lc.rst.Get('node','force',2,'all')-rea2)<0.01,'��֤����');
        end
        function test_verifymodel5(testcase)
            %��֤ģ��5 ��3��ģ�� ���ظ�Ϊj�ڵ�������Ϊ1
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1.14,0,1);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);%ָ��z����Ϊz����
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('force',[2 1 1;2 2 1;2 3 1;2 4 1;2 5 1;2 6 1;]);%���ҽڵ�ʩ������λ�� uyλ��
            
            lc.Solve();
            rea1=[-1	-1	-1	0	-0.86	-2.14];%֧���������۽�sap2000�õ���  lc.rst.Get('node','force',1,'all')
            testcase.verifyTrue(norm( lc.rst.Get('node','force',1,'all')-rea1)<0.01,'��֤����');
            displ2=[1.684273	0.309404	1.030101	0.089553	0.454933	0.497021];
            testcase.verifyTrue(norm( lc.rst.Get('node','displ',2,'all')-displ2)<0.01,'��֤����');
            testcase.verifyTrue(norm( lc.rst.Get('node','displ',1,'all'))<0.0001,'��֤����');
        end
        function test_verifymodel6(testcase)
            %��֤ģ��6 ����ģ�� ������ 2�ڵ� j����1 2 0 ���淽��x
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,2,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[1 0 0]);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[2 1 1;2 2 0;2 3 0;2 4 0;2 5 0;2 6 0;]);%���ҽڵ�ʩ��
            
            lc.Solve();
            rea1=[-2.76	1.13	0	0	0	3.33];
            rea2=[2.76	-1.13	0	0	0	3.33];%֧���������۽�sap2000�õ���
            testcase.verifyTrue(norm( lc.rst.Get('node','force',1,'all')-rea1)<0.01,'��֤����');
            testcase.verifyTrue(norm( lc.rst.Get('node','force',2,'all')-rea2)<0.01,'��֤����');
        end
        function test_verifymodel7(testcase)
            %��֤ģ��7 ��ģ��6�Ļ�����ʩ������λ��1����
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,2,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[1 0 0]);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[2 1 1;2 2 1;2 3 1;2 4 1;2 5 1;2 6 1;]);%���ҽڵ�ʩ��
            
            lc.Solve();
            
            
            
            rea1=[-4.95	1.74	-2.2	-4.39	-1.44	4.44];%
            rea2=[4.95	-1.74	2.2	-0.01342	3.64	7.21];%֧���������۽�sap2000�õ���
            testcase.verifyTrue(norm(lc.rst.Get('node','force',1,'all')-rea1)<0.01,'��֤����');
            testcase.verifyTrue(norm(lc.rst.Get('node','force',2,'all')-rea2)<0.01,'��֤����');
        end
        function test_verifymodel8(testcase)
            %��֤ģ��8 ���� j����1 2 3 λ��Ϊ����1 ����z��
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,2,3);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('displ',[2 1 0;2 2 0;2 3 1;2 4 0;2 5 0;2 6 0;]);%���ҽڵ�ʩ��
            
            lc.Solve();
            testcase.verifyTrue(norm(lc.rst.Get('node','force',2,'uz')-0.4426)<0.01,'��֤����');
            
        end
        function test_verifymodel9(testcase)
            %��֤ģ��9 ������ һ��z�� һ��y�� ����Ϊfx=1 �����۶�
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,3);
            f.node.AddByCartesian(3,0,5,3);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0]);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);%�̽���ڵ�
            lc.AddBC('force',[3 1 1;]);%���ҽڵ�ʩ�� norm(lc.noderst.Get('force',1,'ux')
            
            lc.Solve();
            testcase.verifyTrue(norm(lc.rst.Get('node','force',1,'ux')+1)<0.01,'��֤����');%1�ڵ�ux����
            testcase.verifyTrue(norm(lc.rst.Get('node','force',1,5)+3)<0.01,'��֤����');%1�ڵ�ry����
            r=[26.203877	0	2.007E-16	6.022E-17	1.097561	-5.818011];
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',3,'all')-r)<0.01,'��֤����');
        end
        function test_verifymodel10(testcase)
            %��֤ģ��10 ��9�Ļ����� ���ڵ�2��ux�̶� ��������
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,3);
            f.node.AddByCartesian(3,0,5,3);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0]);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[2 1 0;]);
            lc.AddBC('force',[3 1 1;]);
            
            lc.Solve();
            
            r=[24.008755	0	2.007E-16	6.022E-17	0	-5.818011];
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',3,'all')-r)<0.01,'��֤����');
            
            %��֤��Ԫ���
            ui=lc.rst.Get('node','displ',2,'all');
            uj=lc.rst.Get('node','displ',3,'all');
            e=f.manager_ele.Get('id',2);
            [a,b]=e.GetEleResult([ui;uj]);
            
            lc.rst.Get('ele','deform',1,'all')
            r=lc.rst.Get('ele','force',1,'ij',4)
            testcase.verifyTrue(norm(r-[5 ;-5])<0.001,'��֤����');
        end
        function test_verifymodel_11(testcase)
            %��֤ģ��11 ��֤�˶��ͷ�
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1.2,0,0);
            f.node.AddByCartesian(3,3,0,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0],'j');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec,[0 -1 0],'i');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[3 1 0;3 2 0;3 3 0;3 4 0;3 5 0;3 6 0;]);
            lc.AddBC('force',[2 2 1;]);
            
            lc.Solve();
            
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',2,'uy')-0.1335)<0.01,'��֤����');
        end
        function test_verifymodel_12(testcase)
            %��֤ģ��12 ��֤�˶��ͷ�
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.3);
            f.node.AddByCartesian(3,3,0,1.3);
            f.node.AddByCartesian(4,3,0,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0],'j');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec,[0 -1 0],'ij');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[3 4],sec,[0 -1 0]);%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[4 1 0;4 2 0;4 3 0;4 4 0;4 5 0;4 6 0;]);
            lc.AddBC('force',[2 1 1;]);
            
            lc.Solve();
            
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',2,'ux')-0.1683)<0.01,'��֤����');
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',3,'ux')-0.0103)<0.01,'��֤����');
            t=lc.rst.Get('ele','force',1,'i','all');
            t=t([2 6]);
            testcase.verifyTrue(norm(t-[0.94 1.22])<0.01,'��֤����');
        end
        function test_verifymodel_13(testcase)
            %��֤ģ��13 δ����Ԫ��������ɶ��ϼ���
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1.2,0,0);
            f.node.AddByCartesian(3,3,0,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0],'j');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec,[0 -1 0],'i');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[3 1 0;3 2 0;3 3 0;3 4 0;3 5 0;3 6 0;]);
            lc.AddBC('force',[2 4 1;]);
            lc.AddBC('force',[2 4 5;]);
            
            testcase.verifyError(@()lc.Solve(),'matlab:myerror','��֤����');
        end
        function test_verifymodel_14(testcase)
            %��֤ģ��14 ��12ģ����ͬʱʩ������λ��
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.3);
            f.node.AddByCartesian(3,3,0,1.3);
            f.node.AddByCartesian(4,3,0,0);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0],'j');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec,[0 -1 0],'ij');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[3 4],sec,[0 -1 0]);%ָ��z����Ϊ lc.noderst.Get('displ',2,1)
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[4 1 1;4 2 0;4 3 0;4 4 0;4 5 0;4 6 0;]);
            lc.AddBC('force',[2 1 1;]);
            
            lc.Solve();
            
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',2,1)-0.2262)<0.01,'��֤����');
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',3,1)-0.9524)<0.01,'��֤����');
        end
        function test_verifymodel_15(testcase)
            %��֤ģ��15 ��֤�˶��ͷ�
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            f.node.AddByCartesian(3,0,0,3);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 -1 0],'j');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[2 3],sec,[0 -1 0],'i');%ָ��z����Ϊ
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[3 1 0;3 2 0;3 3 0;3 4 0;3 5 0;3 6 0;]);
            lc.AddBC('force',[2 2 1;]);
            
            lc.Solve();
            
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',2,'uy')-0.1335)<0.01,'��֤����');
        end
        function test_verifymodel_16(testcase)
            %��֤ģ��16 ��֤spring��Ԫ
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            f.node.AddByCartesian(3,1,0,0);
            f.node.AddByCartesian(4,1,0,1.2);
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,1e5);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec,[0 1 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_EULERBEAM(f,0,[3 4],sec,[1 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 4],[1.15 0.8 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[3 1 0;3 2 0;3 3 0;3 4 0;3 5 0;3 6 0;]);
            lc.AddBC('force',[2 2 1;2 1 1]);
            
            lc.Solve();
            d4=[0.021828	0.01656	-7.874E-18	-0.0207	0.027285	0];
            testcase.verifyTrue(norm(lc.rst.Get('node','displ',4,'all')-d4)<0.001,'��֤����');
            t=lc.rst.Get('ele','eng',3);%�������Բ���
            testcase.verifyTrue(norm(t-[0.01468 0 0])<0.001,'��֤����');
        end
        function test_verifymodel_17(testcase)
            %��֤ģ��17 ����������
            n=60;%��Ԫ����
            h=30;%�ո�
            lenel=h/n;%��Ԫ����
            
            f=FEM3DFRAME();
            f.manager_mat.Add(32.5e6,0.2,2.5,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,15.84375,31.378,31.378,1e5);
            f.manager_sec.Add(sec);
            for it=1:n+1
                f.node.AddByCartesian(0,0,0,(it-1)*lenel);
            end
            for it=1:n
                tmp=ELEMENT_EULERBEAM(f,0,[it it+1],sec);
                f.manager_ele.Add(tmp);
            end
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[n+1 1 1]);
            lc.Solve();
            
            
            lc=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            %ɾ��Ťת���ɶ�
            for it=1:n+1
                lc.AddBC('displ',[it 6 0;it 3 0]);
                
            end
            lc.Solve();
            
        end
        function test_verifymodel_18(testcase)
            %��֤ģ��18 һ����Ԫ
            n=1;%��Ԫ����
            h=2;%�ո�
            lenel=h/n;%��Ԫ����
            
            f=FEM3DFRAME();
            f.manager_mat.Add(32.5e6,0.2,2.5,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,15.84375,31.378,31.378,1e5);
            f.manager_sec.Add(sec);
            for it=1:n+1
                f.node.AddByCartesian(0,0,0,(it-1)*lenel);
            end
            for it=1:n
                tmp=ELEMENT_EULERBEAM(f,0,[it it+1],sec);
                f.manager_ele.Add(tmp);
            end
            
            
            
            lc=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('displ',[2 1 0;2 3 0;2 5 0;2 6 0;]);
            lc.Solve();
        end
        function test_verifymodel_19(testcase)
            %���� mass��Ԫ
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            
            tmp=ELEMENT_SPRING(f,0,[1 2],[1.15 0.8 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,2,[23 25 30 0 0 0]);
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc.Solve();
            
            w1=sqrt(0.8/23);
            w2=sqrt(1.15/30);
            [~,t]=lc.rst.GetPeriodInfo();
            testcase.verifyTrue(norm(t(3)-w1)<0.001,'��֤����');
            lc.rst.SetPointer(2);
            [~,t]=lc.rst.GetPeriodInfo();
            testcase.verifyTrue(norm(t(3)-w2)<0.001,'��֤����');
            
        end
        function test_verifymodel_20(testcase)%���� ���𹤿� �����ɶ�
            
            
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            f.node.AddByCartesian(4,3,0,0);
            m=267e3;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,4,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            k=1.75e9;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 3],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[3 4],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            lc1=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.Solve();
            [~,pri]=lc1.rst.GetPeriodInfo();
            w1=pri(3);
            lc1.rst.SetPointer(3);
            [~,pri]=lc1.rst.GetPeriodInfo();
            w2=pri(3);
            
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            
            % ew=EarthquakWave();
            % ew.LoadFromFile('landers','g','F:\TOB\����\Landers.txt','time&acc',0);
            
            dt=load('wjj.mat','dz');
            dt=dt.dz;
            ew=EarthquakWave(dt(:,1),dt(:,2),'m/s^2','dz');
            ei=EarthquakeInput(lc,'landers',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(w1,w2,0.05,0.05);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            testcase.verifyTrue(norm(max(vn)-1.0106e-003)<0.001,'��֤����');
            
            lc=LoadCase_Earthquake(f,'eq1');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            ei=EarthquakeInput(lc,'landers',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('central');
            [a, b]=DAMPING.RayleighDamping(w1,w2,0.05,0.05);
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn1,tn1]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            hold on
            plot(tn1,vn1,'o')
            legend('newamrk','central')
            err=norm(vn1-vn)/sqrt(length(vn));
            testcase.verifyTrue(err<0.00005,'��֤����');
            
        end
        
        function test_verifymodel_21(testcase)
            %���� ���𹤿� ���ڵ�������������
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            
            m=1;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            k=1;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            lc1=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.Solve();
            [~,pri]=lc1.rst.GetPeriodInfo();
            w1=pri(3);
            
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.CloneBC(lc1);
            
            
            ew=EarthquakWave.MakeSin(2/2/pi,1,10,0.01);
            ei=EarthquakeInput(lc,'sin',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            syms t
            v_t=exp(-0.005*t)*(0.0022221*cos(0.99999*t) + 0.66666*sin(0.99999*t)) - 0.33332*sin(2.0*t) - 0.0022221*cos(2.0*t);
            v_v=subs(v_t,t,0:0.01:10);
            v_v=vpa(v_v,7);
            v_v=double(v_v);
            hold on
            plot(tn,-v_v,'+','markersize',3);
            legend('fem','��ȷֵ');
            syms t
            v_t=exp(-0.005*t)*(0.0022221*cos(0.99999*t) + 0.66666*sin(0.99999*t)) - 0.33332*sin(2.0*t) - 0.0022221*cos(2.0*t);
            v_v=subs(v_t,t,0:0.01:10);
            v_v=vpa(v_v,7);
            v_v=double(v_v);
            hold on
            plot(tn,-v_v,'+','markersize',3);
            legend('fem','��ȷֵ');
            er=v_v'+vn;
            testcase.verifyTrue(norm(er)<0.002,'��֤����');
            
            %���Ĳ�ַ�
            lc=LoadCase_Earthquake(f,'eq1');
            f.manager_lc.Add(lc);
            lc.CloneBC(lc1);
            ew=EarthquakWave.MakeSin(2/2/pi,1,10,0.01);
            ei=EarthquakeInput(lc,'sin',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('central');
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn1,tn1]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            err=norm(vn1-vn);
            testcase.verifyTrue(err<0.002,'��֤����');
        end
        function test_verifymodel_22(testcase)
            %���� ��ʼλ��
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            
            m=1;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            k=1;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            lc1=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.Solve();
            [~,pri]=lc1.rst.GetPeriodInfo();
            w1=pri(3);
            
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.CloneBC(lc1);
            testcase.verifyError(@()lc.intd.Add([1 1 1]),'nyh:error','��֤����');
            lc.intd.Add([2 1 1])
            
            ew=EarthquakWave.MakeConstant(0,20,0.01);
            ei=EarthquakeInput(lc,'const',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            
            
            
            %������
            [v]=dsolve('D2y+0.01*Dy+y=0','Dy(0)=0','y(0)=1');
            syms t
            v_v=subs(v,t,[0:0.01:20]);
            v_v=double(v_v);
            hold on
            plot(0:0.01:20,v_v,'o','markersize',2);
            
            er=norm(vn-v_v');
            
            testcase.verifyTrue(er/2001<0.002,'��֤����');
            
            %���Ĳ�ַ�
            lc=LoadCase_Earthquake(f,'eq1');
            f.manager_lc.Add(lc);
            lc.CloneBC(lc1);
            lc.intd.Add([2 1 1])
            
            ew=EarthquakWave.MakeConstant(0,20,0.01);
            ei=EarthquakeInput(lc,'const',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('central');
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn1,tn1]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            err=norm(vn-vn1)/sqrt(length(vn));
            plot(tn1,vn1);
            legend('newmark','������','central')
            testcase.verifyTrue(err<0.001,'��֤����');
        end
        function test_verifymodel_23(testcase)%���� ģ̬���� ͬʱ��֤����λ��Ϊ��������ʱ���Ƿ�����ģ̬����Ϊ0
            
            
            order=2;
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            f.node.AddByCartesian(4,3,0,0);
            m=267e3;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,4,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            k=1.75e9;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 3],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[3 4],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            lc1=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.Solve();
            [~,pri]=lc1.rst.GetPeriodInfo();
            w1=pri(3);
            lc1.rst.SetPointer(order);
            [~,pri]=lc1.rst.GetPeriodInfo();
            w2=pri(3);
            
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            
            % ew=EarthquakWave();
            % ew.LoadFromFile('landers','g','F:\TOB\����\Landers.txt','time&acc',0);
            
            
            ew=EarthquakWave.MakeConstant(0,5,0.002);
            ei=EarthquakeInput(lc,'landers',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(w1,w2,0.05,0.05);
            lc.damp.Set('rayleigh',0,0);
            %��λ��
            u1=lc1.rst.Get('node','displ',2,1);
            u2=lc1.rst.Get('node','displ',3,1);
            u3=lc1.rst.Get('node','displ',4,1);
            lc.intd.Add([2 1 u1; 3 1 u2;4 1 u3]);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'eng');
            t=sum(vn,2);
            vn=[vn t];
            figure
            plot(tn,vn);
            title('����')
            legend('����','����','����','������')
            %����ģ̬����
            md=lc.MakeModalDispl(lc1);
            [t,YY,eng]=md.PlotData();
            testcase.verifyTrue(t(order)/sum(t)>0.99,'��֤����');
            testcase.verifyTrue(norm(vn(:,1)-eng(:,end))<0.0001,'��֤����');%��֤ģ̬�����ܺͽṹ�������Ƿ�һ��
            
            %��֤���ͷֽ�
            [u_comp,tn]=md.GetDispComp(2,1);
            figure
            plot(tn,u_comp)
            legend('1','2','3')
            uhe=sum(u_comp,2);
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            testcase.verifyTrue(norm(uhe-vn)<1e-10,'��֤����');
        end
        function test_verifymodel_24(testcase)
            %���� ������
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            
            m=1;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            k=1;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            lc1=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.Solve();
            [~,pri]=lc1.rst.GetPeriodInfo();
            w1=pri(3);
            
            lcd=LoadCase_Static(f,'eq');
            f.manager_lc.Add(lcd);
            lcd.CloneBC(lc1);
            lcd.AddBC('force',[2 1 1]);
            lcd.Solve();
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.CloneBC(lcd);
            ew=EarthquakWave.MakeConstant(0,20,0.01);
            ei=EarthquakeInput(lc,'const',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            
            %������
            [v]=dsolve('D2y+0.01*Dy+y=1','Dy(0)=0','y(0)=0');
            syms t
            v_v=subs(v,t,[0:0.01:20]);
            v_v=double(v_v);
            hold on
            plot(0:0.01:20,v_v,'o','markersize',2);
            
            er=norm(vn-v_v');
            
            testcase.verifyTrue(er/2001<0.002,'��֤����');
            
            %���Ĳ�ַ�
            lc=LoadCase_Earthquake(f,'eq1');
            f.manager_lc.Add(lc);
            lc.CloneBC(lcd);
            ew=EarthquakWave.MakeConstant(0,20,0.01);
            ei=EarthquakeInput(lc,'const',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('central');
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn1,tn1]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            plot(tn1,vn1);
            legend('newmark','������','central')
            err=norm(vn-vn1)/sqrt(length(vn));
            testcase.verifyTrue(err<0.001,'��֤����');
        end
        function test_verifymodel_25(testcase)
            %���� ������+��λ��
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            
            m=1;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            k=1;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            lc1=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.Solve();
            [~,pri]=lc1.rst.GetPeriodInfo();
            w1=pri(3);
            
            lcd=LoadCase_Static(f,'eq');
            f.manager_lc.Add(lcd);
            lcd.CloneBC(lc1);
            lcd.AddBC('force',[2 1 1]);
            lcd.Solve();
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.CloneBC(lcd);
            
            lc.intd.Add([2 1 1])
            
            
            
            ew=EarthquakWave.MakeConstant(0,20,0.01);
            ei=EarthquakeInput(lc,'const',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(w1,5,0.005,0.005);
            
            lc.damp.Set('rayleigh',a,b);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            
            %������
            [v]=dsolve('D2y+0.01*Dy+y=1','Dy(0)=0','y(0)=1');
            syms t
            v_v=subs(v,t,[0:0.01:20]);
            v_v=double(v_v);
            hold on
            plot(0:0.01:20,v_v,'o','markersize',2);
            legend('fem','������')
            er=norm(vn-v_v');
            
            testcase.verifyTrue(er/2001<0.002,'��֤����');
        end
        
        
        function test_verifymodel_26(testcase)%��֤ģ��26 %��֤spring��Ԫ������
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            tmp=ELEMENT_SPRING(f,0,[1 2],[1.15 0.8 0 0 0 0]);
            tmp.SetNLProperty(1,[1 1 0.1]);
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[2 3 1]);
            
            lc.Solve();
            r1=lc.rst.Get('node','displ',2,3);
            r2=lc.rst.Get('ele','force',1,'i','all');
            testcase.verifyTrue(norm(r1-1)<0.002,'��֤����');
            testcase.verifyTrue(norm(r2-[-1 0 0 0 0 0])<0.002,'��֤����');
            
            lc=LoadCase_Static(f,'dead2');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[2 3 1.5]);
            lc.Solve();
            r1=lc.rst.Get('node','displ',2,3);
            r2=lc.rst.Get('ele','force',1,'i','all');
            testcase.verifyTrue(norm(r1-6)<0.002,'��֤����');
            testcase.verifyTrue(norm(r2-[-1.5 0 0 0 0 0])<0.002,'��֤����');
        end
        
        
        function test_verifymodel_27(testcase)%��֤ģ��27 %��֤spring��Ԫ������ ����һ��
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            tmp=ELEMENT_SPRING(f,0,[1 2],[1.15 0.8 0 0 0 0]);
            tmp.SetNLProperty(1,[1 1 0.1]);
            f.manager_ele.Add(tmp);
            
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);
            f.manager_ele.Add(tmp);
            lc=LoadCase_Static(f,'dead');
            f.manager_lc.Add(lc);
            
            
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[2 3 2.2217]);
            
            lc.Solve();
            r1=lc.rst.Get('node','displ',2,3);
            r2=lc.rst.Get('ele','force',1,'i','all');
            testcase.verifyTrue(norm(r1-1.3)<0.002,'��֤����');
            
            
        end
        
        
        function test_verifymodel_28(testcase)%��֤ģ��28 %��֤��ε���
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            tmp=ELEMENT_SPRING(f,0,[1 2],[1.15 0.8 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            f.manager_mat.Add(1,0.2,1,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            f.manager_sec.Add(sec);
            tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);
            f.manager_ele.Add(tmp);
            
            
            lc=LoadCase_MultStepStatic(f,'dead');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 1;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[2 3 2.2217]);
            testcase.verifyError(@()lc.Solve(),'nyh:error','��֤����');
            
            
            lc=[];
            lc=LoadCase_MultStepStatic(f,'dead1');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[2 3 1]);
            ew=EarthquakWave.MakeSin(1,1,1,0.05,1);
            lc.Set(ew.tn,ew.accn);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,1,'node','displ',2,3);%��ȡʱ�̽��
            vn_tar=ew.accn/2.0667;
            figure;
            plot(tn,vn)
            hold on
            plot(tn,vn_tar,'o')
            legend('fem','����ֵ')
            err=norm(vn-vn_tar);
            testcase.verifyTrue(err<0.001,'��֤����');
        end
        
        
        
        function test_verifymodel_29(testcase)%��֤ģ��28 %��֤��ηǵ���
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,0,0,1.2);
            tmp=ELEMENT_SPRING(f,0,[1 2],[1.15 0.8 0 0 0 0]);
            tmp.SetNLProperty(1,[1 1 0.1]);
            f.manager_ele.Add(tmp);
            
            % f.manager_mat.Add(1,0.2,1,'concrete');
            % mat=f.manager_mat.GetByIdentifier('concrete');
            % sec=SECTION('ver',mat,1.1,3.1,4.1,13);
            % f.manager_sec.Add(sec);
            % tmp=ELEMENT_EULERBEAM(f,0,[1 2],sec);
            % f.manager_ele.Add(tmp);
            
            
            
            
            
            lc=[];
            lc=LoadCase_MultStepStatic(f,'dead1');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0;]);
            lc.AddBC('force',[2 3 1]);
            ew=EarthquakWave.MakeSin(1,1,1,0.05,1);
            lc.Set(ew.tn,ew.accn);
            lc.Solve();
            [vn,tn]=lc.rst.GetTimeHistory(0,1,'node','displ',2,3);%��ȡʱ�̽��
            [fn,tn]=lc.rst.GetTimeHistory(0,1,'ele','force',1,'j',1);%��ȡʱ�̽��
            vn_tar=[1
                4.090169944
                6.877852523
                9.090169944
                10.51056516
                11
                10.95105652
                10.80901699
                10.58778525
                10.30901699
                10
                9.690983006
                9.412214748
                9.190983006
                9.048943484
                9
                9.048943484
                9.190983006
                9.412214748
                9.690983006
                10
                ];
            figure;
            plot(vn,fn)
            hold on
            plot(vn_tar,fn,'o');
            err=norm(vn-vn_tar);
            testcase.verifyTrue(err<0.001,'��֤����');
        end
        
        
        
        function test_verifymodel_30(testcase)
            %���� ���𹤿� �����ɶ� ������spring
            
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            f.node.AddByCartesian(4,3,0,0);
            m=267e3;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,4,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            k1=1.75e9;k2=k1*0.1;fy=k1*1e-4;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 3],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[3 4],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            
            
            
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            
            % ew=EarthquakWave();
            % ew.LoadFromFile('landers','g','F:\TOB\����\Landers.txt','time&acc',0);
            
            dt=load('wjj.mat','dz');
            dt=dt.dz;
            ew=EarthquakWave(dt(:,1),dt(:,2),'m/s^2','dz');
            ei=EarthquakeInput(lc,'landers',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('newmark',0.5,0.25);
            C1=[
                2.6955e+006  -962.0010e+003     0.0000e+000
                -962.0010e+003     2.6955e+006  -962.0010e+003
                0.0000e+000  -962.0010e+003     1.7335e+006];
            
            lc.damp.Set('matrix',C1);
            lc.Solve();
            [u3,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,u3)
            r=max(u3);
            testcase.verifyTrue(norm(r-0.0037219)<0.001,'��֤����');
            
            
        end
        
        function test_verifymodel_31(testcase)%������ EX16.2
            
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            f.node.AddByCartesian(4,3,0,0);
            f.node.AddByCartesian(5,4,0,0);
            f.node.AddByCartesian(6,5,0,0);
            m=0.259;
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,4,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,5,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,6,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            k1=100;
            k2=5;
            fy=125;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 3],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[3 4],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[4 5],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[5 6],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            
            
            
            % lc=LoadCase_Static(f,'dead');
            % f.manager_lc.Add(lc);
            % lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            % tmp=[2 1 125/15
            %     3  1  250/15
            %     4 1 375/15
            %     5 1 500/15
            %     6 1 625/15];
            % lc.AddBC('force',tmp);
            % lc.Solve();
            % r=[lc.rst.Get('node','displ',2,1)
            %     lc.rst.Get('node','displ',3,1)
            %     lc.rst.Get('node','displ',4,1)
            %     lc.rst.Get('node','displ',5,1)
            %     lc.rst.Get('node','displ',6,1)]
            
            lc=LoadCase_MultStepStatic(f,'dead');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            tmp=[2 1 125/15
                3  1  250/15
                4 1 375/15
                5 1 500/15
                6 1 625/15];
            lc.AddBC('force',tmp);
            scale=[0 1 1.1 1.2 1.3 1.4 1.5 1.6];
            tn=1:length(scale);tn=tn';
            lc.Set(tn,scale);
            lc.Solve();
            r1=lc.rst.GetTimeHistory(0,20,'node','displ',2,1);
            r1_tar=[     0.0000e+000
                1.2500e+000
                3.7500e+000
                6.2500e+000
                8.7500e+000
                11.2500e+000
                13.7500e+000
                16.2500e+000];
            err=norm(r1-r1_tar);
            testcase.verifyTrue(err<0.001,'��֤����');
        end
        function test_verifymodel_32(testcase) %���� ���𹤿� �����ɶ� ������spring
            
            
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            f.node.AddByCartesian(4,3,0,0);
            m=267e3;
            
            tmp=ELEMENT_MASS(f,0,2,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,4,[m m m 0 0 0]);
            f.manager_ele.Add(tmp);
            
            k1=1.75e9;k2=k1*0.1;fy=k1*1e-4;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 3],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[3 4],[k1 0 0 0 0 0]);
            tmp.SetNLProperty(1,[k1 fy k2]);
            f.manager_ele.Add(tmp);
            
            
            
            
            
            lc=LoadCase_Earthquake(f,'eq');
            f.manager_lc.Add(lc);
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            
            % ew=EarthquakWave();
            % ew.LoadFromFile('landers','g','F:\TOB\����\Landers.txt','time&acc',0);
            
            dt=load('wjj.mat','dz');
            dt=dt.dz;
            ew=EarthquakWave(dt(:,1),dt(:,2),'m/s^2','dz');
            ei=EarthquakeInput(lc,'landers',ew,1,0);
            lc.AddEarthquakeInput(ei);
            lc.SetAlgorithm('central');
            C1=[
                2.6955e+006  -962.0010e+003     0.0000e+000
                -962.0010e+003     2.6955e+006  -962.0010e+003
                0.0000e+000  -962.0010e+003     1.7335e+006];
            
            lc.damp.Set('matrix',C1);
            lc.Solve();
            [u3,tn]=lc.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,u3)
            r=max(u3);
            testcase.verifyTrue(norm(r-0.0037219)<0.001,'��֤����');
            
            
        end
        function test_verifymodel_33(testcase)%���Թ������� ָ���ڵ�λ�Ƶ����ͷֽ�
            %��femģ��2���ɶ� copy������
            %���� ���𹤿� ���ڵ�������������
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            
            
            tmp=ELEMENT_MASS(f,0,2,[1 1 1 0 0 0]*100);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[1 1 1 0 0 0]*400);
            f.manager_ele.Add(tmp);
            
            
            k=19740;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            k=9870;
            tmp=ELEMENT_SPRING(f,0,[2 3],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            lc=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc);
            lc.arg{2}='m';%�����������һ������ ���ĳɰ��������ܹ�һ���˲���Ҳ������ͨ��
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc.AddBC('displ',[2 2 0;2 3 0;2 4 0;2 5 0;2 6 0]);
            lc.AddBC('displ',[3 2 0;3 3 0;3 4 0;3 5 0;3 6 0]);
            lc.Solve();
            lc.rst.PrintPeriodInfo()
            
            lc1=LoadCase_Earthquake(f,'ea');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.AddBC('displ',[2 2 0;2 3 0;2 4 0;2 5 0;2 6 0]);
            lc1.AddBC('displ',[3 2 0;3 3 0;3 4 0;3 5 0;3 6 0]);
            dt=ReadTxt("E:\�о���\����Ħ����֧��\matlab\sap2000automation\waves\elcentro.th",2,2);
            ew=EarthquakWave(dt(:,1),dt(:,2),'g','el');
            ew.FillZeros(40);
            ew.PointInterpolation(1);
            ei=EarthquakeInput(lc1,'landers',ew,1,0);
            lc1.AddEarthquakeInput(ei);
            lc1.SetAlgorithm('newmark',0.5,0.25);
            [a, b]=DAMPING.RayleighDamping(1,10,0.05,0.05);
            lc1.damp.Set('rayleigh',0,0);%������
            lc1.Solve();
            figure
            [vn,tn]=lc1.rst.GetTimeHistory(0,40,'node','displ',3,1);
            plot(tn,vn)
            testcase.verifyTrue(abs(max(vn)-2.042e-1)<1e-3,'���ֵ')
            testcase.verifyTrue(abs(min(vn)+1.927e-1)<1e-3,'��Сֵ')
            
            md=lc1.MakeModalDispl(lc);
            [u_comp,tn]=md.GetDispComp(2,1);
            figure
            plot(tn,u_comp)
            legend('1','2')
            uhe=sum(u_comp,2);
            [vn,tn]=lc1.rst.GetTimeHistory(0,40,'node','displ',2,1);
            figure
            plot(tn,vn)
            hold on
            plot(tn,uhe,'*')
            legend('���𹤿�ԭֵ','�ֽ��')
            testcase.verifyTrue(norm(vn-uhe)<1e-7,'�ֽ�ǰ��������')
            
            
            
            
            
            %�������Ͷ�3�Žڵ������
            [u_comp3,tn]=md.GetDispComp(3,1);
            sd1=0.1927;
            t3=AbsMax(u_comp3(:,1),1);
            disp('���� ��ֵ ��  ���ͷֽ�ֵ')
            fprintf('%f\t%f\t%f\t%f\n',lc.modal_participation_factor1(2,1),sd1,sd1*lc.modal_participation_factor1(2,1),t3)%1��
            testcase.verifyTrue(norm(sd1*lc.modal_participation_factor1(2,1)-t3)<1e-3,'���Ͳ�������1�������Ͳ�������1*λ����ֵ��=�����ɶ����ͷֽ�ֵ')
            sd1=0.04638;
            t3=AbsMax(u_comp3(:,2),1);
            disp('���� ��ֵ ��  ���ͷֽ�ֵ')
            fprintf('%f\t%f\t%f\t%f\n',lc.modal_participation_factor1(2,2),sd1,sd1*lc.modal_participation_factor1(2,2),t3)%1��
            testcase.verifyTrue(norm(abs(sd1*lc.modal_participation_factor1(2,2))-abs(t3))<1e-3,'���Ͳ�������1�������Ͳ�������1*λ����ֵ��=�����ɶ����ͷֽ�ֵ')
            
            %�������Ͷ�2�Žڵ������
            [u_comp3,tn]=md.GetDispComp(2,1);
            sd1=0.1927;
            t3=AbsMax(u_comp3(:,1),1);
            disp('���� ��ֵ ��  ���ͷֽ�ֵ')
            fprintf('%f\t%f\t%f\t%f\n',lc.modal_participation_factor1(1,1),sd1,sd1*lc.modal_participation_factor1(1,1),t3)%1��
            testcase.verifyTrue(norm(sd1*lc.modal_participation_factor1(1,1)-t3)<5e-3,'���Ͳ�������1�������Ͳ�������1*λ����ֵ��=�����ɶ����ͷֽ�ֵ')
            sd1=0.04638;
            t3=AbsMax(u_comp3(:,2),1);
            disp('���� ��ֵ ��  ���ͷֽ�ֵ')
            fprintf('%f\t%f\t%f\t%f\n',lc.modal_participation_factor1(1,2),sd1,sd1*lc.modal_participation_factor1(1,2),t3)%1��
            testcase.verifyTrue(norm(abs(sd1*lc.modal_participation_factor1(1,2))-abs(t3))<5e-3,'���Ͳ�������1�������Ͳ�������1*λ����ֵ��=�����ɶ����ͷֽ�ֵ')
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            % [maxYY,YY,eng]=md.PlotData();
            % figure
            % plot(tn,YY(:,1))
            
            
            
            
        end
        
        function test_verifymodel_34(testcase)%loadcase modal��PredictWithResponseSpectrum
            %3��story
            f=FEM3DFRAME();
            f.node.AddByCartesian(1,0,0,0);
            f.node.AddByCartesian(2,1,0,0);
            f.node.AddByCartesian(3,2,0,0);
            f.node.AddByCartesian(4,3,0,0);
            
            mass=0.3;
            tmp=ELEMENT_MASS(f,0,2,[1 1 1 0 0 0]*mass);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,3,[1 1 1 0 0 0]*mass);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_MASS(f,0,4,[1 1 1 0 0 0]*mass);
            f.manager_ele.Add(tmp);
            
            
            k=200;
            tmp=ELEMENT_SPRING(f,0,[1 2],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[2 3],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[3 4],[k 0 0 0 0 0]);
            f.manager_ele.Add(tmp);
            
            lc=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc);
            lc.arg{2}='m';
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc.AddBC('displ',[2 2 0;2 3 0;2 4 0;2 5 0;2 6 0]);
            lc.AddBC('displ',[3 2 0;3 3 0;3 4 0;3 5 0;3 6 0]);
            lc.AddBC('displ',[4 2 0;4 3 0;4 4 0;4 5 0;4 6 0]);
            lc.Solve();
            lc.rst.PrintPeriodInfo()
            
            
            
            lc1=LoadCase_Earthquake(f,'ea');
            f.manager_lc.Add(lc1);
            lc1.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            lc1.AddBC('displ',[2 2 0;2 3 0;2 4 0;2 5 0;2 6 0]);
            lc1.AddBC('displ',[3 2 0;3 3 0;3 4 0;3 5 0;3 6 0]);
            dt=ReadTxt("E:\�о���\����Ħ����֧��\matlab\sap2000automation\waves\elcentro.th",2,2);
            ew=EarthquakWave(dt(:,1),dt(:,2),'g','el');
            ew.FillZeros(40);
            ew.PointInterpolation(1);
%             ei=EarthquakeInput(lc1,'landers',ew,1,0);
%             lc1.AddEarthquakeInput(ei);
%             lc1.SetAlgorithm('newmark',0.5,0.25);
%             [a, b]=DAMPING.RayleighDamping(1,10,0.05,0.05);
%             lc1.damp.Set('rayleigh',0,0);%������
%             lc1.Solve();
%             figure
%             [vn,tn]=lc1.rst.GetTimeHistory(0,40,'node','displ',3,1);
%             plot(tn,vn)
            
            t=lc.PredictWithResponseSpectrum(3,1,0,ew);
            testcase.verifyEqual(t,0.154,'AbsTol',0.001);


        end
        
        function test_verifymodel_35(testcase)%���Ե��𹤿� ���ͷֽ�
            f=FEM3DFRAME();
            for i=1:11
                f.node.AddByCartesian(i,0,(i-1)*2,0);%11���ڵ�
            end
            f.node.AddByCartesian(12,0,20.1,0);%12���ڵ�
            
            
            f.manager_mat.Add(32.5e6,0.2,2.55,'concrete');
            mat=f.manager_mat.GetByIdentifier('concrete');
            sec=SECTION('ver',mat,2.5447,0.5153,0.5153,1.0306);%���� ��Դ��sap2000
            f.manager_sec.Add(sec);
            
            for i=1:10
                tmp=ELEMENT_EULERBEAM(f,0,[i i+1],sec,[0 0 1]);%ָ��z����Ϊ-y����
                f.manager_ele.Add(tmp);
            end
            
            tmp=ELEMENT_MASS(f,0,12,[1 1 1 0 0 0]*500);%�������
            f.manager_ele.Add(tmp);
            tmp=ELEMENT_SPRING(f,0,[11 12],[10e6 4000 4000 0 0 0]);
            f.manager_ele.Add(tmp);
            
            
            lc=LoadCase_Modal(f,'modal');
            f.manager_lc.Add(lc);
            lc.arg{1}=21;
            lc.arg{2}='k';
            lc.AddBC('displ',[1 1 0;1 2 0;1 3 0;1 4 0;1 5 0;1 6 0]);
            for i=1:12
                lc.AddBC('displ',[i 2 0;i 3 0;i 4 0;i 5 0]);
            end
            lc.Solve();
            lc.rst.PrintPeriodInfo()%��sap��϶Ȼ�����
            
            
            
            lce=LoadCase_Earthquake(f,'eq');
            lce.CloneBC(lc);
            f.manager_lc.Add(lce);
            ew=EarthquakWave.LoadFromFile1('el','m/s^2',"E:\�ҵ��ĵ�\MATLAB\GoodTool\FEM3DFRAME\������������\elcentro-st.th",'time&acc',2);
            ew.PointInterpolation(1);
            ew.FillZeros(40);
            ei=EarthquakeInput(lce,'landers',ew,1,0);
            lce.AddEarthquakeInput(ei);
            lce.SetAlgorithm('modalcomposition',lc);
            lce.damp.Set('xi',lc,0);
            lce.Solve();
            [up,tn]=lce.rst.GetTimeHistory(0,40,'node','displ',11,1);
            testcase.verifyEqual(max(up),0.0099131,'AbsTol',0.0001);
            testcase.verifyEqual(min(up),-0.010048,'AbsTol',0.0001);
        end
    end
end