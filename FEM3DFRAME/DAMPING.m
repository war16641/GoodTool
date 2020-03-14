classdef DAMPING<handle
    %UNTITLED5 �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        lc 
        typename char
        arg cell

        
    end
    
    methods
        function obj = DAMPING(lc)
            obj.lc=lc;
            obj.typename='';
            obj.arg={};
        end
        
        function Set(obj,varargin)
            varargin=Hull(varargin);
            switch varargin{1}
                case 'rayleigh'%�������� ����������������� �նȾ������
                    obj.typename='rayleigh';
                    if 3~=length(varargin)
                        error('matlab:myerror','��������������')
                    end
                    obj.arg=varargin(2:end);
                case 'matrix'%ֱ��ָ��C1
                    obj.typename='matrix';
                    obj.arg=varargin(2);
                case 'xi'%ָ��ÿһ�׵������
                    obj.typename='xi';
                    obj.arg=varargin(2:end);%ģ̬���� �����
                otherwise
                    error('matlab:myerror','δ֪��������')
            end
        end
        function Make(obj)%����lc������� ��Ҫ����lc��M1 K1
            %ע��:���ô˺���ǰ ȷ�������͸նȾ����Ѿ�������� 
            switch obj.typename
                case 'rayleigh'%��������
                    obj.lc.C1=obj.arg{1}*obj.lc.M1+obj.arg{2}*obj.lc.K1;
                case 'matrix'%ֱ��ָ��C1
                    obj.lc.C1=obj.arg{1};
                case 'xi'
                    xi=obj.arg{2};
                    lcm=obj.arg{1};
                    if length(xi)==1%xiֻ��һ���� Ĭ��ȫ�׶�����������
                        xi=ones(lcm.arg{1},1)*xi;
                    end
                    assert(length(xi)==lcm.arg{1},'xi������ģ̬����һ��')
                    
%                     %���´���������⣺��modal����������ȫ��ʱ�ִ����޷���������
%                     %ԭ������ �ṹ����ѧ ������ P188 ʽ12-48 12-49
%                     C=xi.*lcm.w.*lcm.generalized_vars(:,1);
%                     C=diag(2*C);
%                     obj.lc.C1=(lcm.mode')^-1*C*lcm.mode^-1;
                    
                    obj.lc.C1=0*obj.lc.K1;%����0����һ�� ��������ϵ������ ��ʹ�������
                    obj.arg=[obj.arg xi];
                otherwise
                    error('matlab:myerror','δ֪��������')
            end
        end
    end
    methods(Static)
        function [alpha,beta,c]=RayleighDamping(w1,w2,xi1,xi2,k,m)
            %�������� w xi��ԲƵ�ʺ������
            %alpha����������
            if nargin==4
                t=2*w1*w2/(w2^2-w1^2)*[w2 -w1;-1/w2 1/w1]*[xi1 ;xi2];
                alpha=t(1);beta=t(2);
            elseif nargin==6
                t=2*w1*w2/(w2^2-w1^2)*[w2 -w1;-1/w2 1/w1]*[xi1 ;xi2];
                alpha=t(1);beta=t(2);
                c=alpha*m+beta*k;
            end
        end
    end
end

