classdef NoNoiMech < handle  
    %无噪声机制类
    
    properties
    end
    
    methods
        
        function res = genNoise(obj,varargin)
            if length(varargin)>0
                res=zeros(cell2mat(varargin));
            else
                res=zeros();
            end
        end
        
        function res = getMse(obj)
            res = 0;
        end
        
        function res = getSensType(obj)
            res = 2;
        end
        
        function setSens(obj,sens)
        end
        
        function [res]=disp(obj)
            res='无噪声机制，噪声方差为0。\n';
            disp(res)
        end
    end
end

