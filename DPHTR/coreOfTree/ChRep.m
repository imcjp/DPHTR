classdef ChRep < handle  
    %这是层次树的孩子节点表示
    
    properties
        inds;
        chIds;
        n;
        m
    end
    
    methods
        function res = getChList(obj,p)
            % 获取层次树的节点的孩子列表
            res=obj.chIds((obj.inds(p)+1):obj.inds(p+1));
        end
        
        function res = getN(obj)
            % 获取层次树的节点个数
            res = obj.n;
        end
        function res = getM(obj)
            % 获取层次树的非叶节点个数
            res = obj.m;
        end
        function [res]=disp(obj)
            res=sprintf('层次树的节点数为%i，其中%i个节点为非叶子节点\n',obj.n,obj.m);
            for i =1:obj.m
                chs=getChList(obj,i);
                chn=length(chs);
                if chn>1
                    tmpS=sprintf(',%i',chs(2:end));
                else
                    tmpS='';
                end
                res=sprintf('%s\t节点数%i包含%i个子节点：分别是[%i%s];\n',res,i,chn,chs(1),tmpS);
            end
            disp(res)
        end
    end
end

