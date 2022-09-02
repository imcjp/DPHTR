classdef AGMech < handle  
    %������˹������
    
    properties
        epsilon;
        delta;
        sens=1;
        sigma0;
        sigma;
    end
    
    methods(Static)
        function obj = withSigma(sigma0, varargin)
            obj=AGMech(0,0);
            if length(varargin)>0
                obj.sens=varargin{1};
            end
            obj.epsilon=[];
            obj.delta=[];
            obj.sigma0=sigma0;
            obj.sigma=obj.sens*obj.sigma0;
        end
    end
    methods
        function obj = AGMech(epsilon, delta, varargin)
            if length(varargin)>0
                obj.sens=varargin{1};
            end
            obj.epsilon=epsilon;
            obj.delta=delta;
            if obj.epsilon==0
                obj.sigma0=inf;
                obj.sigma=inf;
            else
                obj.sigma0=anaGaussSigma(obj.epsilon, obj.delta, 1);
                obj.sigma=obj.sens*obj.sigma0;
            end
        end
        
        function res = genNoise(obj,varargin)
            if length(varargin)>0
                res=randn(cell2mat(varargin));
            else
                res=randn();
            end
            res = obj.sigma*res;
        end
        
        function res = getMse(obj)
            res = obj.sigma^2;
        end
        
        function res = getSensType(obj)
            res = 2;
        end
        
        function setSens(obj,sens)
            obj.sens=sens;
            obj.sigma=sens*obj.sigma0;
        end
        
        function [res]=disp(obj)
            res='';
            res=sprintf('%s��˹���ƣ�֧��L%i���жȣ�\n',res,getSensType(obj));
            if length(obj.epsilon)==0
                res=sprintf('%s\t��������ֱ��ָ������λ�������� sigma0 = %g���������� sigma = %g��\n',res,obj.sigma0,obj.sigma);
            else
                res=sprintf('%s\t����(�� = %g,�� = %g) - �����˽����λ�������� sigma0 = %g���������� sigma = %g��\n',res,obj.epsilon,obj.delta,obj.sigma0,obj.sigma);
            end
            res=sprintf('%s\t���ж�����Ϊ%g��\n',res,obj.sens);
            res=sprintf('%s\t��������Ϊ%g��\n',res,obj.getMse);
            disp(res)
        end
    end
end

