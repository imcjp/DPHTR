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
function [res] = queryRg(rg,vn,lrg,rrg,chInd)
global ques;
qs=1;
qt=1;
ques(:,qt)=[rg;1];
qt=qt+1;
res=0;
while qs<qt
    qn=ques(:,qs);
    qs=qs+1;
    pos=qn(3);
    if qn(1)==lrg(pos) && qn(2)==rrg(pos)
        res=res+vn(pos);
    else
        for i=chInd(pos):(chInd(pos+1)-1)
            qn2(1)=max(lrg(i),qn(1));
            qn2(2)=min(rrg(i),qn(2));
            if qn2(1)<=qn2(2)
                qn2(3)=i;
                ques(:,qt)=qn2(:);
                qt=qt+1;
            end
        end
    end
end