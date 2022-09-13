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
classdef SimpleDPReleaser < DPReleaser  
    % DPHTR by Simple Mathods, Processless and ForcePositive
    
    properties
    end
    
    methods
        function obj = SimpleDPReleaser(tree, noiMech, varargin)
            obj@DPReleaser(tree, noiMech, varargin);
            obj.name='SimpleDPReleaser';
            obj.desc='differential privacy hierarchy tree release by Simple Methods. The methods do not satisfy consistency.';
        end
        
        function [vAvg,info] = consistency(obj,noiVn)
            vAvg=noiVn;
            info=struct();
        end
        
        function [vAvgPos,info] = nonNegConsistency(obj,noiVn)
            vAvgPos=noiVn;
            vAvgPos(vAvgPos<0)=0;
            info=struct();
        end
    end
end

