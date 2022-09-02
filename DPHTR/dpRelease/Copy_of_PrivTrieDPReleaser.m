classdef PrivTrieDPReleaser < DPReleaser  
    %Boosting 发布方法
    
    properties
        tmpV;
        tmpSn;
        tmpRn;
    end
    
    methods
        function obj = PrivTrieDPReleaser(tree, noiMech, varargin)
            obj@DPReleaser(tree, noiMech, varargin);
            obj.name='PrivTrieDPReleaser';
            obj.desc='differential privacy hierarchy tree release for consistency by using PrivTrie Method';
        end

        function [sv]=pgUp(obj,treeInfo,p)
            if p<=treeInfo.getM
                chn=treeInfo.getChList(p);
                s=0;
                for ch=chn
                    sc=pgUp(obj,treeInfo,ch);
                    s=s+sc;
                end
                obj.tmpRn(p)=1/(1+s);
                sv=s*obj.tmpRn(p);
                obj.tmpSn(p)=sv;
            else
                sv=obj.tmpSn(p);
            end
        end

        function [sv]=pgUp2(obj,treeInfo,p)
            if p<=treeInfo.getM
                chn=treeInfo.getChList(p);
                s=0;
                for ch=chn
                    sc=pgUp2(obj,treeInfo,ch);
                    s=s+sc;
                end
                obj.tmpV(p)=s*obj.tmpRn(p);
            else
                obj.tmpV(p)=obj.tmpV(p)*obj.tmpRn(p);
            end
            sv=obj.tmpV(p);
        end
        function pgSum(obj,treeInfo,p,sumAnc)
            if p<=treeInfo.getM
                sumAnc1=sumAnc+obj.tmpV(p);
                obj.tmpV(p)=0;
                chn=treeInfo.getChList(p);
                for ch=chn
                    pgSum(obj,treeInfo,ch,sumAnc1);
                end
            else
                obj.tmpV(p)=obj.tmpV(p)+sumAnc;
            end
        end
        function pgDown(obj,treeInfo,p,sumAnc)
%             obj.tmpV(p)=obj.tmpV(p);
            if p>1
                obj.tmpV(p)=obj.tmpV(p)-obj.tmpSn(p)*sumAnc;
            end
            if p<=treeInfo.getM
                sumAnc1=sumAnc+obj.tmpV(p);
                chn=treeInfo.getChList(p);
                for ch=chn
                    pgDown(obj,treeInfo,ch,sumAnc1);
                end
            end
        end
        
        function vAvg = consistency(obj,noiVn)
            if length(obj.lambdan)>0
                error(sprintf('%s do not support consistency method with various coefficients...',obj.name))
            else
                treeInfo=obj.tree.getChRep;
                obj.tmpV=noiVn;
                n1=length(treeInfo);
                n=length(noiVn);
                obj.tmpSn=[zeros(n1,1);ones(n-n1,1)];
                obj.tmpRn=[zeros(n1,1);ones(n-n1,1)];
                pgUp(obj,treeInfo,1);
                pgSum(obj,treeInfo,1,0);
                pgUp2(obj,treeInfo,1);
                pgDown(obj,treeInfo,1,0);
                vAvg=obj.tmpV;
%                 vAvg2=recPrivTrie(obj.tree.getChRep,noiVn);
%                 norm(vAvg-vAvg2)
            end
        end
        
        function [vAvgPos,iter] = nonNegConsistency(obj,noiVn)
            error(sprintf('%s do not support nonNegConsistency method...',obj.name))
        end
        
    end
end

