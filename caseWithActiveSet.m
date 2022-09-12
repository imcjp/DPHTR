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
% In this script, we attempt to use the active set method to solve for optimally
% non-negative consistent releases. The results show that the active set method 
% is not a good choice, which can only handle the smallest scale dataset.
clear all;clc;close all;
%% setup our core codes
addpath(genpath('DPHTR'));
%% Initialization of experimental parameters
alg='Active Set'; % Select a algorithm
dataset='Census2010';
% privacy parameters
eplison=1;
delta=1e-8;
%% parameters for data scale of datasets
% for Census2010
kOrder=5;
%% Load random seed
%% new a noise mechanism(analytical Gaussian Mechanism)
noiMech=GsMech(eplison,delta);
%% Load dataset and build a Hierarchical Tree
path='data/census2010.mat';       
load(path);
fn=census.data(:,2)+1;
population=census.data(:,4);
[tree,matId]=buildTreebyFn(fn);
tree=tree.getSubTree(kOrder);
n=tree.getN;
v(matId)=population;
v=v(:);
v=v(1:n);
dtInfo=sprintf('%i-Order SubTree',kOrder);
%% Building a DPHTR releaser according to the chosen algorithm
releaser=DPReleaser(tree,noiMech);
%% Noise addition to achieve (epsilon,delta)-DP
vNoi=releaser.addNoise(v);
%% post-processing for Consistency or Non-negative Consistency with CVX
iter=1;
tic
n=length(vNoi);
M=tree.getCCMat();
n1=tree.getN(1);
lb=zeros(n,1);
lb(1:n1)=-inf;
options=optimset('Algorithm','active-set','Display','off');
vAvgPos=fmincon(@(x)(sum((vNoi-x).^2)),vNoi,[],[],full(M'),zeros(n1,1),lb,[],[],options);
vAvg=vAvgPos;
runtime=toc;
%% Experimental evaluation
% evaluation with Node Query
M=tree.getCCMat();
bias=sqrt(mean((M'*vAvg).^2));
fval=sqrt(mean((vAvg-vNoi).^2));
rmse=sqrt(mean((v-vAvg).^2));
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
fprintf('\tThe rmse is %g.\n',rmse);