classdef GMDPReleaser < handle  
    %分析高斯机制类
    
    properties
        tree;
        noiMech;
        lambdan;
        iLambdan;
        m;
        n;
    end
    
    methods
        function obj = GMDPReleaser(tree, noiMech, varargin)
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
                if bias>1e-8
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
        function vAvg = consistency(obj,noiVn)
            if length(obj.lambdan)>0
                
            else
                G=getG1(obj.tree);
                M=obj.tree.getCCMat;
                v1=noiVn'*M/G;
                vAvg=(noiVn-M*(G\(v1(:))));
            end
        end
        
        function [vAvgPos,iter] = nonNegConsistency(obj,noiVn)
            if length(obj.lambdan)>0
                
            else
                [vAvgPos,iter]=GMPC(obj.tree,noiVn);
            end
        end
        function res = getSensType(obj)
            res = 2;
        end
        
        function setSens(obj,sens)
            obj.sens=sens;
            obj.sigma=sens*obj.sigma0;
        end
        
        function [res]=disp(obj)
%             res='';
%             res=sprintf('%s高斯机制，支持L%i敏感度；\n',res,getSensType(obj));
%             if length(obj.epsilon)==0
%                 res=sprintf('%s\t噪声参数直接指定，单位噪声参数 sigma0 = %g，噪声参数 sigma = %g；\n',res,obj.sigma0,obj.sigma);
%             else
%                 res=sprintf('%s\t满足(ε = %g,δ = %g) - 差分隐私，单位噪声参数 sigma0 = %g，噪声参数 sigma = %g；\n',res,obj.epsilon,obj.delta,obj.sigma0,obj.sigma);
%             end
%             res=sprintf('%s\t敏感度设置为%g；\n',res,obj.sens);
%             res=sprintf('%s\t噪声方差为%g。\n',res,obj.getMse);
%             disp(res)
        end
    end
end

