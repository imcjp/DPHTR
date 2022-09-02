classdef PrivTrieDPReleaser < DPReleaser  
    %PrivTrie 发布方法
    
    properties
        tmpV;
        tmpSn;
        tmpRn;
        tmpSgn;
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
                s1=0;
                s2=0;
                for ch=chn
                    sc=pgUp(obj,treeInfo,ch);
                    s1=s1+sc;
                    s2=s2+sc/(obj.tmpSgn(p)^2);
                end
                obj.tmpRn(p)=1/(1+s2);
                sv=s1*obj.tmpRn(p);
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
                sumAnc1=sumAnc+obj.tmpV(p)/(obj.tmpSgn(p)^2);
                obj.tmpV(p)=0;
                chn=treeInfo.getChList(p);
                for ch=chn
                    pgSum(obj,treeInfo,ch,sumAnc1);
                end
            else
                obj.tmpV(p)=obj.tmpV(p)/(obj.tmpSgn(p)^2)+sumAnc;
            end
        end
        function pgDown(obj,treeInfo,p,sumAnc)
%             obj.tmpV(p)=obj.tmpV(p);
            if p>1
                obj.tmpV(p)=obj.tmpV(p)-obj.tmpSn(p)*sumAnc;
            end
            if p<=treeInfo.getM
                sumAnc1=sumAnc+obj.tmpV(p)/(obj.tmpSgn(p)^2);
                chn=treeInfo.getChList(p);
                for ch=chn
                    pgDown(obj,treeInfo,ch,sumAnc1);
                end
            end
        end
        
        function [vAvg,info] = consistency(obj,noiVn)
            treeInfo=obj.tree.getChRep;
            n1= treeInfo.getM;
            n=treeInfo.getN;
            if length(obj.lambdan)>0
                obj.tmpSgn=obj.iLambdan;
                obj.tmpV=noiVn.*obj.tmpSgn;
            else
                obj.tmpSgn=ones(n,1);
                obj.tmpV=noiVn;
            end
            obj.tmpSn=[zeros(n1,1);obj.tmpSgn((n1+1):n).^2];
            obj.tmpRn=[zeros(n1,1);obj.tmpSgn((n1+1):n).^2];
            pgUp(obj,treeInfo,1);
            pgSum(obj,treeInfo,1,0);
            pgUp2(obj,treeInfo,1);
            pgDown(obj,treeInfo,1,0);
            if length(obj.lambdan)>0
                vAvg=obj.tmpV.*obj.lambdan;
            else
                vAvg=obj.tmpV;
            end
            info=struct();
        end
        
        function [vAvgPos,info] = nonNegConsistency(obj,noiVn)
            error(sprintf('%s do not support nonNegConsistency method...',obj.name))
        end
        
    end
end

