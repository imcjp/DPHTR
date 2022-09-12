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
%% Head
% In this script, we show a case of failure to solve the optimal non-negative consistent release using Infeasible path-following algorithms by CVX.
% The non-dependability of CVX for large-scale hierarchical trees such as this case shows that it is not a good choice for baseline.
% For this case, the correct results are obtained using our proposed GMNC. 
% Under the correct result, the RMSE is 40.4423.
clear all;clc;close all;
%% setup our core codes
addpath(genpath('DPHTR'));
addpath(genpath('cvx'));
cvx_setup;
%% Initialization of experimental parameters
alg='Infeasible path-following algorithms'; % Select a algorithm
dataset='Trip2013';
seed=3020; % set a random seed
% privacy parameters
eplison=1;
delta=1e-8;
% Number of queries tested
q=100000; 
%% parameters for data scale of datasets
% for Trip2013
timeLev=3;
%% Load random seed
rand('seed',seed);
randn('seed',seed);
%% new a noise mechanism(analytical Gaussian Mechanism)
noiMech=GsMech(eplison,delta);
%% Load dataset and build a Hierarchical Tree
path='data/trip1.mat';
u=load(path);
nLvl=[3600,86400,604800,2678400,7776000,31536000];
timeLevNames={'Hour','Day','Week','Month','Quarter','Year'};
nLeaf=nLvl(timeLev);
u.cnt=u.cnt(1:nLeaf,1);
posn=[0,0,4,3,2,1];
nLeaf=length(u.cnt);
tree = buildQueryTree(nLeaf,posn);
n=tree.getN;
% Randomly generate q range queries
rgs=genRandRange(nLeaf,q);
dtInfo=sprintf('"%s"',timeLevNames{timeLev});
%% Building a DPHTR releaser according to the chosen algorithm
releaser=DPReleaser(tree,noiMech);
%% build Tree
x=u.cnt;
v=releaser.buildTree(x);
%% Noise addition to achieve (epsilon,delta)-DP
vNoi=releaser.addNoise(v);
%% post-processing for Consistency or Non-negative Consistency with CVX
iter=1;
tic
n=length(vNoi);
M=tree.getCCMat();
cvx_begin
    variable vAvgPos(n)
    minimize (norm(vAvgPos-vNoi))
    M'*vAvgPos==0;
    vAvgPos >= 0;
cvx_end
vAvg=vAvgPos;
runtime=toc;
%% Experimental evaluation
M=tree.getCCMat();
H=tree.getLeafMappingMat();
bias=sqrt(mean((M'*vAvg).^2));
fval=sqrt(mean((vAvg-vNoi).^2));
cumX=[0;cumsum(x)];
rTrue=zeros(q,1);
rNoi=zeros(q,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%
fn=tree.fatherId;
lrg=(1:nLeaf)*H;
lrg(lrg==0)=inf;
rrg=(1:nLeaf)*H;
rrg(rrg==0)=-inf;
for i=n:-1:2
    lrg(fn(i))=min(lrg(fn(i)),lrg(i));
    rrg(fn(i))=max(rrg(fn(i)),rrg(i));
end
hn=zeros(nLeaf,1);
chn=tree.getChnOfNode;
n1=tree.getN(1);
chn=chn(1:n1);
chInd=[0;cumsum(chn)]+2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xRes=H*vAvg;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ques=zeros(3,10000);
for i=1:q
    lr=rgs(1,i);
    rr=rgs(2,i);
    rTrue(i)=cumX(rr+1)-cumX(lr);
    rNoi(i)=queryRg(rgs(:,i),vAvg,lrg,rrg,chInd);
end
rmse=sqrt(mean((rTrue-rNoi).^2));
negNum=sum(vAvg<-1e-8);
%% Show result
fprintf('Experimental Information:\n')
fprintf('\tThe used algorithm is "%s".\n',alg)
fprintf('\tThe used dataset is "%s" with %s.\n',dataset,dtInfo)
m=tree.getN()-tree.getN(1);
fprintf('\tThe hierarchical tree contains %i nodes and %i leaves.\n',n,m);
fprintf('Differential Privacy Information:\n')
fprintf('\tThe algorithm satisfies (%g, %g)-DP with Gaussian noise following N(0, %g) (under sensitivity %g).\n',eplison,delta,noiMech.sigma,noiMech.sens)
fprintf('The summary of experimental results:\n')
fprintf('\tThe running time is %gs.\n',runtime);
correctRmse=40.4423;
fprintf('\tThe rmse is %g. (correct rmse should be %g)\n',rmse,correctRmse);
