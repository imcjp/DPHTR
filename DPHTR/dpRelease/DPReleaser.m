classdef DPReleaser < handle  
    % DPHTR by Built-in Optimizer
    % It's the ancestor class of other DPReleaser
    properties
        tree;
        noiMech;
        lambdan;
        iLambdan;
        m;
        n;
        name='DPReleaser';
        desc='differential privacy hierarchy tree release for consistency by using Quadratic Programming Solver';
    end
    
    methods
        function obj = DPReleaser(tree, noiMech, varargin)
            while length(varargin)==1 && strcmp(class(varargin{1}),'cell')==1
                varargin=varargin{1};
            end
            obj.tree=tree;
            obj.noiMech=noiMech;
            obj.n=obj.tree.getN();
            obj.m=obj.n-obj.tree.getN(1);
            if length(varargin)>0
                obj.lambdan=varargin{1};
                if length(obj.lambdan)~=obj.n
                    error(sprintf('Length of lambdan (%i) should be equal to node number (%i).',length(obj.lambdan),obj.n));
                else
                    obj.lambdan=obj.lambdan(:);
                end
                obj.iLambdan=1./obj.lambdan;
            end
            if length(obj.lambdan)>0
                if noiMech.getSensType==1
                    sens=max(tree.getStruMat\(abs(obj.lambdan)));
                elseif noiMech.getSensType==2
                    sens=sqrt(max(tree.getStruMat\(obj.lambdan.^2)));
                end
            else
                hn=tree.getHeight;
                if noiMech.getSensType==1
                    sens=hn(1);
                elseif noiMech.getSensType==2
                    sens=sqrt(hn(1));
                end
            end
            noiMech.setSens(sens);
        end
        
        function vn = buildTree(obj,xn)
            if length(xn)~=obj.m
                error(sprintf('Length of xn (%i) should be equal to leaf number (%i).',length(xn),obj.m));
            end
            vn=obj.tree.getStruMat'\(obj.tree.getLeafMappingMat'*xn);
            vn=full(vn);
            if length(obj.lambdan)>0
                vn=obj.lambdan.*vn;
            end
        end
        
        function noiVn = addNoise(obj,vn)
            if length(vn)~=obj.n
                error(sprintf('Length of xn (%i) should be equal to leaf number (%i).',length(xn),obj.m));
            end
            if length(obj.lambdan)>0
                Mt=obj.tree.getCCMat';
                bias=norm(Mt*(obj.iLambdan.*vn));
                if bias>1e-6
                    error(sprintf('The input hierarchical tree vectors are inconsistent. The bias is %g.',bias));
                end
            else
                Mt=obj.tree.getCCMat';
                bias=norm(Mt*vn);
                if bias>1e-8
                    error(sprintf('The input hierarchical tree vectors are inconsistent. The bias is %g.',bias));
                end
            end
            noiVn=vn+obj.noiMech.genNoise(obj.n,1);
        end
        function [vAvg,info] = consistency(obj,noiVn)
            if length(obj.lambdan)>0
                options=optimset('Algorithm','interior-point-convex','Display','off');
                M=obj.iLambdan.*obj.tree.getCCMat();
                n1=obj.tree.getN(1);
                [vAvg,~,~,info,~]=quadprog(speye(obj.n),-noiVn,[],[],M',zeros(n1,1),[],[],[],options);
            else
                options=optimset('Algorithm','interior-point-convex','Display','off');
                M=obj.tree.getCCMat();
                n1=obj.tree.getN(1);
                [vAvg,~,~,info,~]=quadprog(speye(obj.n),-noiVn,[],[],M',zeros(n1,1),[],[],[],options);
            end
            dtV=vAvg-noiVn;
            val=sum(dtV.^2);
            info=struct('optVal',val);
        end
        
        function [vAvgPos,info] = nonNegConsistency(obj,noiVn)
            if length(obj.lambdan)>0
                n=length(noiVn);
                M=obj.tree.getCCMat();
                M=spdiags(obj.iLambdan,0,n,n)*M;
                n1=obj.tree.getN(1);
                lb=zeros(obj.n,1);
                lb(1:n1)=-inf;
                options=optimset('Algorithm','interior-point-convex','Display','off');
                [vAvgPos,~,~,info,~]=quadprog(speye(obj.n),-noiVn,[],[],M',zeros(n1,1),lb,[],[],options);
                iter=info.iterations;
            else
                n=length(noiVn);
                M=obj.tree.getCCMat();
                options=optimset('Algorithm','active-set','Display','off');
                n1=obj.tree.getN(1);
                lb=zeros(obj.n,1);
                lb(1:n1)=-inf;
                [vAvgPos,~,~,info,~]=quadprog(speye(obj.n),-noiVn,[],[],M',zeros(n1,1),lb,[],[],options);
                iter=info.iterations;
            end
            dtV=vAvgPos-noiVn;
            val=sum(dtV.^2);
            info=struct('optVal',val,'iter',iter);
        end
        
        function [res]=disp(obj)
            res=sprintf('The releaser is of ''%s''.\nThe description: %s.\n',obj.name,obj.desc);
            res=sprintf('%sThe tree has %i nodes, where first %i nodes is non-leaf node.\n',res,obj.n,obj.m);
            if length(obj.lambdan)>0
                res=sprintf('%sThe tree is with non-uniform private budgets. The budgets are:\n',res);                
                n=length(obj.lambdan);
                if n>1
                    nt=min(n,20);
                    tmpS=sprintf(',%i',obj.lambdan(2:nt));
                    if nt<n
                        tmpS=sprintf('%s ...',tmpS);
                    end
                else
                    tmpS='';
                end
                res=sprintf('%s\t[%g%s]\n',res,obj.lambdan(1),tmpS);
            end
            disp(res)
            fprintf('The information of noise mechanism is:\n');
            res=sprintf('%sThe information of noise mechanism is:\n%s',res,disp(obj.noiMech));
        end
    end
end

