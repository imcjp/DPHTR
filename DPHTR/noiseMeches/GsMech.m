classdef GsMech < handle  
    % Gaussian Mechanism based on f-DP
    
    properties
        epsilon;
        delta;
        sens=0;
        sigma;
    end
    
    methods(Static)
        function obj = withSigma(sigma0, varargin)
            obj=GsMech(0,0);
            if length(varargin)>0
                obj.sens=varargin{1};
            end
            obj.epsilon=[];
            obj.delta=[];
%             obj.sigma0=sigma0;
            obj.sigma=sigma0;
        end
    end
    methods
        function obj = GsMech(epsilon, delta, varargin)
            if length(varargin)>0
                obj.sens=varargin{1};
            end
            obj.epsilon=epsilon;
            obj.delta=delta;
            if obj.epsilon==0
                obj.sigma=inf;
            else
                if obj.sens>0
                    obj.sigma=fDPGaussSigma(obj.epsilon,obj.delta,obj.sens);
                end
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
            obj.sigma=fDPGaussSigma(obj.epsilon,obj.delta,obj.sens);
        end
        
        function [res]=disp(obj)
            res='';
            res=sprintf('%sGaussian Mechanism with L%i sensitivity;\n',res,getSensType(obj));
            if length(obj.epsilon)==0
                res=sprintf('%s\tNoise scale is specified directly, where sigma = %g;\n',res,obj.sigma);
            else
                res=sprintf('%s\tSatisfying (¦Å = %g,¦Ä = %g) - DP, where sigma = %g;\n',res,obj.epsilon,obj.delta,obj.sigma);
            end
            res=sprintf('%s\tSensitivity is set as %g;\n',res,obj.sens);
            res=sprintf('%s\tThe noise variance is %g.\n',res,obj.getMse);
            disp(res)
        end
    end
end

