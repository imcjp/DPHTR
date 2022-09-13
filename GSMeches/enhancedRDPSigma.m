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
function [sigma] = enhancedRDPSigma(eplison, delta,h)
%% Solve sigma by given privacy budgets for Enhanced RDP
% [1] Asoodeh S, Liao J, Calmon F P, et al. A better bound gives a hundred rounds: Enhanced privacy guarantees via f-divergences[C]//2020 IEEE International Symposium on Information Theory (ISIT). IEEE, 2020: 920-925.
func=@(sigma)(enhancedRDP(sigma, delta,h));
sigma=binary_search(func,eplison);
end

function s_mid=binary_search(func,threshold) 
% binary search for Descending Sequence
    s_inf=0;
    s_sup=1;
    while func(s_sup)>=threshold
        s_inf=s_sup;
        s_sup=s_sup*2;
    end
    s_mid = s_inf + (s_sup-s_inf)/2.0;
    while s_sup-s_inf>1e-8
        if func(s_mid)<threshold
            s_sup = s_mid;
        else
            s_inf = s_mid;
        end
        s_mid = s_inf + (s_sup-s_inf)/2.0;
    end
end
