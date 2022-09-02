classdef LapMech < handle  
    %拉普拉斯机制类
    
    properties
        epsilon;
%         delta;
        sens=1;
        b0;
        b;
    end
    
    methods(Static)
        function obj = withB(b0, varargin)
            obj=LapMech(0);
            if length(varargin)>0
                obj.sens=varargin{1};
            end
            obj.epsilon=[];
%             obj.delta=[];
            obj.b0=b0;
            obj.b=obj.sens*obj.b0;
        end
    end
    methods
        function obj = LapMech(epsilon, varargin)
            if length(varargin)>0
                obj.sens=varargin{1};
            end
            obj.epsilon=epsilon;
%             obj.delta=delta;
            if obj.epsilon==0
                obj.b0=inf;
                obj.b=inf;
            else
                obj.b0=1/obj.epsilon;
                obj.b=obj.b0*obj.sens;
            end
        end
        
        function res = genNoise(obj,varargin)
            if length(varargin)>0
                U=unifrnd(-0.5,0.5,cell2mat(varargin));
                res=(-obj.b)*sign(U).*log(1-2*abs(U));
            else
                U=unifrnd(-0.5,0.5);
                res=(-obj.b)*sign(U).*log(1-2*abs(U));
            end
        end
        
        function res = getMse(obj)
            res = 2*obj.b^2;
        end
        
        function res = getSensType(obj)
            res = 1;
        end
        
        function setSens(obj,sens)
            obj.sens=sens;
            obj.b=obj.b0*obj.sens;
        end
        
        function [res]=disp(obj)
            res='';
            res=sprintf('%s拉普拉斯机制，支持L%i敏感度；\n',res,getSensType(obj));
            if length(obj.epsilon)==0
                res=sprintf('%s\t噪声参数直接指定，单位噪声参数 b0 = %g，噪声参数 b = %g；\n',res,obj.b0,obj.b);
            else
                res=sprintf('%s\t满足(ε = %g) - 差分隐私，单位噪声参数 b0 = %g，噪声参数 b = %g；\n',res,obj.epsilon,obj.b0,obj.b);
            end
            res=sprintf('%s\t敏感度设置为%g；\n',res,obj.sens);
            res=sprintf('%s\t噪声方差为%g。\n',res,obj.getMse);
            disp(res)
        end
    end
end

