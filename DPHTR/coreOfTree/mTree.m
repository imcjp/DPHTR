classdef Tree < handle    
    properties
        fatherId;% 树中每个节点的父节点
        nodeHeight;% 树中每个节点的高度，叶子节点高度为1
        nodeCount;% 树的节点数量
        cache;% 缓存
    end    
    methods
        function [res]=disp(obj)
            res=disp(obj.getChRep);
        end
        function res=getStruMat(obj)
            % 获取层次树的结构矩阵
            if isfield(obj.cache,'tmpStruMat')
                res=obj.cache.tmpStruMat;
            else
                res = mexBuildGMat(obj.fatherId);
                obj.cache.tmpStruMat=res;
            end
        end
        function res=getLeafMappingMat(obj)
            % 获取层次树的结构矩阵
            if isfield(obj.cache,'tmpMappingMat')
                res=obj.cache.tmpMappingMat;
            else
                n1=getN(obj,1);
                n=getN(obj);
                m=n-n1;
                res = sparse(1:m,(n1+1):n,1,m,n);
                obj.cache.tmpMappingMat=res;
            end
        end
        function res=getGenMat(obj,wNode,wEdge)
            % 获取层次树的生成矩阵
            if obj.getN~=length(wNode) || obj.getN~=length(wEdge)
                error(message('wNode和wEdge的长度应和节点数一致'));
            end
            if sum(wNode==0)>0 || sum(wEdge==0)>0
                error(message('wNode和wEdge的值不可为0'));
            end
            res = mexBuildGMat(obj.fatherId,wNode,wEdge);
        end
        function res=getAdjMat(obj)
            % 获取层次树的邻接矩阵
            if isfield(obj.cache,'tmpAdjMat')
                res=obj.cache.tmpAdjMat;
            else
                res=speye(obj.getN)-obj.getStruMat;
                obj.cache.tmpAdjMat=res;
            end
        end
        function res=getDistMat(obj)
            % 获取层次树的距离矩阵
            if isfield(obj.cache,'tmpDistMat')
                res=obj.cache.tmpDistMat;
            else
                G=obj.getStruMat;
                M1=G\ones(obj.getN,1)*ones(1,obj.getN);
                iG=inv(G);
                M2=iG*iG';
                res=M1+M1'-2*M2;
                obj.cache.tmpDistMat=res;
            end
        end
        function res=getAncMat(obj)
            % 获取层次树的祖先矩阵
            if isfield(obj.cache,'tmpAncMat')
                res=obj.cache.tmpAncMat;
            else
                G=obj.getStruMat;
                iG=inv(G);
                M=iG*iG';
                n1=obj.getN(1);
                res=M((n1+1):end,(n1+1):end)-1;
                obj.cache.tmpAncMat=res;
            end
        end
        function res=getLapMat(obj)
            % 获取层次树的拉普拉斯矩阵
            if isfield(obj.cache,'tmpLapMat')
                res=obj.cache.tmpLapMat;
            else
                G=obj.getStruMat;
                res=G'*G;
                res(1,1)=res(1,1)-1;
                obj.cache.tmpLapMat=res;
            end
        end
        function res=getN(obj,k)
            % 获取层次树的节点个数
            if exist('k')
                res=obj.nodeCount(1+k);
            else
                res=obj.nodeCount(1);
            end
        end
        function res=getChnOfNode(obj)
            % 获取层次树的节点个数
            if isfield(obj.cache,'tmpChnOfNode')
                res=obj.cache.tmpChnOfNode;
            else
                G=obj.getStruMat;
                res=full(sum(speye(obj.getN)-G',2));
                obj.cache.tmpChnOfNode=res;
            end
        end
        function res=getCCMat(obj)
            % 获取层次树的一致性约束矩阵
            if isfield(obj.cache,'tmpCCMat')
                res=obj.cache.tmpCCMat;
            else
                G=obj.getStruMat;
                res=G(:,1:obj.getN(1));
                obj.cache.tmpCCMat=res;
            end
        end
        function res=getParRep(obj)
            % 获取层次树的父节点表示
            res=obj.fatherId;
        end
        function res=getHeight(obj)
            % 获取层次树各个节点的高度
            res=obj.nodeHeight;
        end
        function res=getChRep(obj)
            % 获取层次树的子节点表示
            if isfield(obj.cache,'tmpChRep')
                res=obj.cache.tmpChRep;
            else
%                 chn=obj.getChnOfNode;
                n=obj.getN;
                Gt=obj.getGenMat(ones(n,1),1:n);
                [t1,t2,t3]=find(speye(n)-Gt);
                chn=obj.getChnOfNode;
                m=obj.getN(1);
                chn=chn(1:m);
                chn=[0;cumsum(chn)];
                res=ChRep();
                res.n=n;
                res.m=m;
                res.inds=chn;
                res.chIds=t3';
            end
        end
        function [subTree]=getSubTree(obj,k)
            % 获取该树的子树
            % lv:树的等级，表示所选择的子树包含了高度大于等于lv的结点，lv=0返回和自己相同的树
            % 返回子树
            subTree=Tree();
            subTree.nodeCount=obj.nodeCount((1+k):end);
            ns=subTree.nodeCount(1);
            subTree.fatherId=obj.fatherId(1:ns);
            subTree.nodeHeight=obj.nodeHeight(1:ns)-k;
        end
        function clearCache(obj)
            obj.cache={};
        end
    end    
end

