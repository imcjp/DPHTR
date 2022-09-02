classdef CvxDPReleaser < DPReleaser  
    %PrivTrie ��������
    
    properties
        tmpV;
        tmpSn;
        tmpRn;
        tmpSgn;
    end
    
    methods
        function obj = CvxDPReleaser(tree, noiMech, varargin)
            obj@DPReleaser(tree, noiMech, varargin);
            obj.name='CvxDPReleaser';
            obj.desc='differential privacy hierarchy tree release for consistency by using Cvx Tool';
        end
        function [vAvg,info] = consistency(obj,noiVn)
%             treeInfo=obj.tree.getChRep;
%             n1= treeInfo.getM;
%             n=treeInfo.getN;
%             if length(obj.lambdan)>0
%                 obj.tmpSgn=obj.iLambdan;
%                 obj.tmpV=noiVn.*obj.tmpSgn;
%             else
%                 obj.tmpSgn=ones(n,1);
%                 obj.tmpV=noiVn;
%             end
%             obj.tmpSn=[zeros(n1,1);obj.tmpSgn((n1+1):n).^2];
%             obj.tmpRn=[zeros(n1,1);obj.tmpSgn((n1+1):n).^2];
%             pgUp(obj,treeInfo,1);
%             pgSum(obj,treeInfo,1,0);
%             pgUp2(obj,treeInfo,1);
%             pgDown(obj,treeInfo,1,0);
%             if length(obj.lambdan)>0
%                 vAvg=obj.tmpV.*obj.lambdan;
%             else
%                 vAvg=obj.tmpV;
%             end
%             info=struct();
        end
        
        function [vAvgPos,info] = nonNegConsistency(obj,noiVn)
            n=length(noiVn);
            M=obj.tree.getCCMat();
            cvx_begin
                variable vAvgPos(n)
                minimize (norm(vAvgPos-noiVn))
                M'*vAvgPos==0;
                vAvgPos >= 0;
            cvx_end
            iter=1;
            dtV=vAvgPos-noiVn;
            val=sum(dtV.^2);
            info=struct('optVal',val,'iter',iter);
        end
        
    end
end
