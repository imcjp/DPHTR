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
function [eplison] = enhancedRDP(sigma, delta,h)
%% An Enhanced privacy guarantees implementation refer to Lemma 1 in [1], which gives a better for RDP.
% [1] Asoodeh S, Liao J, Calmon F P, et al. A better bound gives a hundred rounds: Enhanced privacy guarantees via f-divergences[C]//2020 IEEE International Symposium on Information Theory (ISIT). IEEE, 2020: 920-925.
func=@(alpha)(eplisonWithAlpha(alpha,sigma, delta,h));
z=golden(func,1,1/delta);
eplison=func(z);
end

function [eplison] = eplisonWithAlpha(alpha,sigma, delta,h)
    gamma=h*alpha/(2*sigma^2);
    if alpha*delta<1
        etaA=1/alpha*((1-1/alpha)^(alpha-1));
        kexi=(exp((alpha-1)*gamma)-1)/(alpha-1);
        f1=(alpha-1)*gamma-log(delta/etaA);
        f2=log((alpha-1)*kexi/(alpha*delta)+1);
        eplison=min(max(f1,0),f2)/(alpha-1);
    else
        eplison=max(gamma+log(1-delta),0);
    end
end