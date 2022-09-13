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
clear all;clc;close all;
epsilon=1
delta=1e-5
sens=3
sz=[3,5,7]
%高斯机制
mech=GsMech(epsilon,delta);
mech.setSens(sens)
disp(mech);
%生成噪声
rn=mech.genNoise()
%拉普拉斯机制
mech=LapMech(epsilon);
mech.setSens(sens);
disp(mech);
%生成噪声
rn=mech.genNoise()
%无噪声机制
mech=NoNoiMech();
disp(mech);
%生成噪声
rn=mech.genNoise(sz)