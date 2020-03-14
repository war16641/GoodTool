classdef DAMPING<handle
    %UNTITLED5 此处显示有关此类的摘要
    %   此处显示详细说明
    
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
                case 'rayleigh'%瑞利阻尼 依次是质量矩阵乘子 刚度矩阵乘子
                    obj.typename='rayleigh';
                    if 3~=length(varargin)
                        error('matlab:myerror','瑞利阻尼梁参数')
                    end
                    obj.arg=varargin(2:end);
                case 'matrix'%直接指定C1
                    obj.typename='matrix';
                    obj.arg=varargin(2);
                case 'xi'%指定每一阶的阻尼比
                    obj.typename='xi';
                    obj.arg=varargin(2:end);%模态工况 阻尼比
                otherwise
                    error('matlab:myerror','未知阻尼类型')
            end
        end
        function Make(obj)%生成lc阻尼矩阵 需要调用lc的M1 K1
            %注意:调用此函数前 确保质量和刚度矩阵已经计算完毕 
            switch obj.typename
                case 'rayleigh'%瑞利阻尼
                    obj.lc.C1=obj.arg{1}*obj.lc.M1+obj.arg{2}*obj.lc.K1;
                case 'matrix'%直接指定C1
                    obj.lc.C1=obj.arg{1};
                case 'xi'
                    xi=obj.arg{2};
                    lcm=obj.arg{1};
                    if length(xi)==1%xi只是一个数 默认全阶都是这个阻尼比
                        xi=ones(lcm.arg{1},1)*xi;
                    end
                    assert(length(xi)==lcm.arg{1},'xi必须与模态阶数一致')
                    
%                     %以下代码块有问题：当modal工况不是求全阶时又存在无法求矩阵的逆
%                     %原理来自 结构动力学 克拉夫 P188 式12-48 12-49
%                     C=xi.*lcm.w.*lcm.generalized_vars(:,1);
%                     C=diag(2*C);
%                     obj.lc.C1=(lcm.mode')^-1*C*lcm.mode^-1;
                    
                    obj.lc.C1=0*obj.lc.K1;%先用0矩阵顶一顶 放弃阻尼系数矩阵 改使用阻尼比
                    obj.arg=[obj.arg xi];
                otherwise
                    error('matlab:myerror','未知阻尼类型')
            end
        end
    end
    methods(Static)
        function [alpha,beta,c]=RayleighDamping(w1,w2,xi1,xi2,k,m)
            %瑞利阻尼 w xi是圆频率和阻尼比
            %alpha是质量乘子
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

