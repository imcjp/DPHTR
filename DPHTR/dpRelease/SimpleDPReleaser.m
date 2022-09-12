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

