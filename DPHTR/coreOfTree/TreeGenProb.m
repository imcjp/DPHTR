classdef TreeGenProb < handle    
    properties
        theProb
    end    
    methods
        function obj = TreeGenProb(prob)
            prob=prob/sum(prob);
            obj.theProb=prob;
        end
        function [res]=disp(obj)
            res='';
            for i =1:length(obj.theProb)
                res=sprintf('%s\t���ɳ���Ϊ%i�Ľڵ����Ϊ%g%%\n',res,i-1,obj.theProb(i)*100);
            end
            disp(res)
        end
    end    
end

