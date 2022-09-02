classdef AGMech < handle  
    %分析高斯机制类
    
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
            res=sprintf('%s高斯机制，支持L%i敏感度；\n',res,getSensType(obj));
            if length(obj.epsilon)==0
                res=sprintf('%s\t噪声参数直接指定，单位噪声参数 sigma0 = %g，噪声参数 sigma = %g；\n',res,obj.sigma0,obj.sigma);
            else
                res=sprintf('%s\t满足(ε = %g,δ = %g) - 差分隐私，单位噪声参数 sigma0 = %g，噪声参数 sigma = %g；\n',res,obj.epsilon,obj.delta,obj.sigma0,obj.sigma);
            end
            res=sprintf('%s\t敏感度设置为%g；\n',res,obj.sens);
            res=sprintf('%s\t噪声方差为%g。\n',res,obj.getMse);
            disp(res)
        end
    end
end

