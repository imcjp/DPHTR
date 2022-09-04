classdef GMDPReleaser < DPReleaser  
    %分析高斯机制类
    
    properties
    end
    
    methods
        function obj = GMDPReleaser(tree, noiMech, varargin)
            obj@DPReleaser(tree, noiMech, varargin);
            obj.name='GMDPReleaser';
            obj.desc='differential privacy hierarchy tree release for consistency by using Generation Matrix Methods';
        end
        
        function [vAvg,info] = consistency(obj,noiVn)
            if length(obj.lambdan)>0
                G=getG1withLambda(obj.tree,obj.iLambdan);
                M=obj.tree.getCCMat;
                v1=(noiVn.*obj.iLambdan)'*M/G;
                vAvg=noiVn-(obj.iLambdan.*(M*(G\(v1(:)))));
            else
                G=getG1(obj.tree);
                M=obj.tree.getCCMat;
                v1=noiVn'*M/G;
                vAvg=(noiVn-M*(G\(v1(:))));
            end
            dtV=vAvg-noiVn;
            val=sum(dtV.^2);
            info=struct('optVal',val);
        end
        
        function [vAvgPos,info] = nonNegConsistency(obj,noiVn)
            if length(obj.lambdan)>0
                [vAvgPos,iter]=GMNC2(obj.tree,noiVn,obj.iLambdan);
            else
                [vAvgPos,iter]=GMNC(obj.tree,noiVn);
            end
            dtV=vAvgPos-noiVn;
            val=sum(dtV.^2);
            info=struct('optVal',val,'iter',iter);
        end
        
    end
end

