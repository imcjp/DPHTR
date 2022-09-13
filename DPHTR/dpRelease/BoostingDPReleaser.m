%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2022 Jianping Cai
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef BoostingDPReleaser < DPReleaser  
    % DPHTR by Boosting, only support "consistency"
    properties
        tmpV;
        tmpW;
        tmpK;
    end
    
    methods
        function obj = BoostingDPReleaser(tree, noiMech, varargin)
            obj@DPReleaser(tree, noiMech, varargin);
            obj.name='BoostingDPReleaser';
            obj.desc='differential privacy hierarchy tree release for consistency by using Boosting Method';
        end

        function [z,height]=pgUp(obj,treeInfo,p)
            z=obj.tmpV(p);
            k=obj.tmpK;
            if p<=treeInfo.getM
                chn=treeInfo.getChList(p);
                s=0;
                height=0;
                for ch=chn
                    [sc,hc]=pgUp(obj,treeInfo,ch);
                    s=s+sc;
                    height=max(height,hc);
                end
                height=height+1;
                v1=(k^height-k^(height-1))/(k^height-1);
                v2=(k^(height-1)-1)/(k^height-1);
                z=v1*z+v2*s;
                obj.tmpW(p)=s;
                obj.tmpV(p)=z;
            else
                height=1;
            end
        end

        function pgDown(obj,treeInfo,p,pf)
            k=obj.tmpK;
%             obj.tmpV(p)=obj.tmpV(p);
            if p>1
                obj.tmpV(p)=obj.tmpV(p)+(obj.tmpV(pf)-obj.tmpW(pf))/k;
            end
            if p<=treeInfo.getM
                chn=treeInfo.getChList(p);
                for ch=chn
                    pgDown(obj,treeInfo,ch,p);
                end
            end
        end
        
        function [vAvg,info] = consistency(obj,noiVn)
            if length(obj.lambdan)>0
                error(sprintf('%s do not support consistency method with various coefficients...',obj.name))
            else
                treeInfo=obj.tree.getChRep;
                obj.tmpV=noiVn;
                obj.tmpK=length(treeInfo.getChList(1));
                obj.tmpW=zeros(length(treeInfo),1);
                pgUp(obj,treeInfo,1);
                pgDown(obj,treeInfo,1,0);                
                vAvg=obj.tmpV;
            end
            info=struct('fanOut',obj.tmpK);
        end
        
        function [vAvgPos,info]  = nonNegConsistency(obj,noiVn)
            error(sprintf('%s do not support nonNegConsistency method...',obj.name))
        end
        
    end
end

