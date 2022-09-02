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
%% setup our core codes
addpath(genpath('DPHTR'));
%% Initialization of experimental parameters
% Available algorithms
algs={'Processless','Boosting','PrivTrie','GMC','ForcePos','IPC','GMNC'};
alg=algs{7}; % Select a algorithm
% Available datasets
datasets={'Census2010','Trip2013','SynData'};
dataset=datasets{2}; % Select a dataset
seed=3020; % set a random seed
% privacy parameters
eplison=1;
delta=1e-8;
% alpha for Non-uniform Private Budgets. alpha = 1 corresponds to Uniform
% Private Budgets; This parameter only works for algorithms that support
% Non-uniform Private Budgets.
alpha=1;
%Number of queries tested
q=100000; 
%% parameters for data scale of datasets
% for Census2010
kOrder=1;
% for Trip2013
timeLev=3;
% for SynData
height=12;
%% Load random seed
rand('seed',seed);
randn('seed',seed);
%% Constructing a noise generator (analytical Gaussian Mechanism)
noiMech=AGMech(eplison,delta);
%% Load dataset and build a Hierarchical Tree
if strcmp(dataset,datasets{1}) % for dataset Census2010
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
elseif strcmp(dataset,datasets{2}) % for dataset Trip2013
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
elseif strcmp(dataset,datasets{3}) % for dataset SynData
    fanOut=2;
    lambda=10;
    posn=[zeros(1,fanOut) 1];
    p=height-1;
    nLeaf=fanOut^p;
    tree = buildQueryTree(nLeaf,posn);
    n=tree.getN;
    % Randomly generate q range queries
    rgs=genRandRange(nLeaf,q);
    dtInfo=sprintf('h = %i',height);
else
	error(sprintf('Dataset name %s is error.',dataset));
end
%% Building a DPHTR releaser according to the chosen algorithm
% If lambdan is not provided, default indicates the setting of Uniform
% Private Budgets.
lambdan=alpha.^(tree.getHeight-1);
isSupportLambda=0;
if strcmp(alg,algs{1})
    releaser=SimpleDPReleaser(tree,noiMech);
elseif strcmp(alg,algs{2})
    releaser=BoostingDPReleaser(tree,noiMech);
elseif strcmp(alg,algs{3})
    releaser=PrivTrieDPReleaser(tree,noiMech,lambdan);
    isSupportLambda=1;
elseif strcmp(alg,algs{4})
    releaser=GMDPReleaser(tree,noiMech);
elseif strcmp(alg,algs{5})
    releaser=SimpleDPReleaser(tree,noiMech);
elseif strcmp(alg,algs{6})
    releaser=DPReleaser(tree,noiMech,lambdan);
    isSupportLambda=1;
elseif strcmp(alg,algs{7})
    releaser=GMDPReleaser(tree,noiMech,lambdan);
    isSupportLambda=1;
else
	error(sprintf('Algorithm name %s is error.',alg));
end
%% build Tree
if strcmp(dataset,datasets{1}) % for dataset Census2010
    if isSupportLambda
        v=v.*lambdan;
    end
elseif strcmp(dataset,datasets{2}) % for dataset Trip2013
    x=u.cnt;
    v=releaser.buildTree(x);
elseif strcmp(dataset,datasets{3}) % for dataset SynData
    x=random('poisson',lambda,nLeaf,1);
    v=releaser.buildTree(x);
else
	error(sprintf('Dataset name %s is error.',dataset));
end
%% Noise addition to achieve (epsilon,delta)-DP
vNoi=releaser.addNoise(v);
%% post-processing for Consistency or Non-negative Consistency
iter=1;
tic
if strcmp(alg,algs{1})
    vAvg=releaser.consistency(vNoi);
elseif strcmp(alg,algs{2})
    vAvg=releaser.consistency(vNoi);
elseif strcmp(alg,algs{3})
    vAvg=releaser.consistency(vNoi);
elseif strcmp(alg,algs{4})
    vAvg=releaser.consistency(vNoi);
elseif strcmp(alg,algs{5})
    vAvg=releaser.nonNegConsistency(vNoi);
elseif strcmp(alg,algs{6})
    [vAvg,info]=releaser.nonNegConsistency(vNoi);
    iter=info.iter;
elseif strcmp(alg,algs{7})
    [vAvg,info]=releaser.nonNegConsistency(vNoi);
    iter=info.iter;
else
	error(sprintf('Algorithm name %s is error.',alg));
end
if isSupportLambda
    vAvg=vAvg./lambdan;
end
runtime=toc;
%% Experimental evaluation
if strcmp(dataset,datasets{1}) % for dataset Census2010
    % evaluation with Node Query
    M=tree.getCCMat();
    if isSupportLambda
        vNoi=vNoi./lambdan;
        v=v./lambdan;
    end
    bias=sqrt(mean((M'*vAvg).^2));
    fval=sqrt(mean((vAvg-vNoi).^2));
    rmse=sqrt(mean((v-vAvg).^2));
    negNum=sum(vAvg<-1e-8);
elseif strcmp(dataset,datasets{2})||strcmp(dataset,datasets{3}) % for dataset Trip2013 or SynData
    % evaluation with Range Query
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
else
	error(sprintf('Dataset name %s is error.',dataset));
end
%% Show result
fprintf('Experimental Information:\n')
fprintf('\tThe used algorithm is "%s".\n',alg)
fprintf('\tThe used dataset is "%s" with %s.\n',dataset,dtInfo)
m=tree.getN()-tree.getN(1);
fprintf('\tThe hierarchical tree contains %i nodes and %i leaves.\n',n,m);
fprintf('Differential Privacy Information:\n')
fprintf('\tThe algorithm satisfies (%g, %g)-DP with Gaussian noise following N(0, %g) (under sensitivity 1).\n',eplison,delta,noiMech.sigma0)
fprintf('The summary of experimental results:\n')
fprintf('\tThe running time is %gs.\n',runtime);
fprintf('\tThe rmse is %g.\n',rmse);
fprintf('\tThe optimal solution of the optimization equation is %g.\n',fval);
if bias<1e-6
    fprintf('\tThe result satisfies hierarchical consistency. (bias = %g)\n',bias);
else
    fprintf('\tThe result do not satisfy hierarchical consistency. (bias = %g)\n',bias);
end
if negNum==0
    fprintf('\tThe result satisfies Non-negativity. (negNum = %i)\n',negNum);
else
    fprintf('\tThe result do not satisfy Non-negativity. (negNum = %i)\n',negNum);
end
fprintf('\tThe number of iterations of the algorithm is %i.\n',iter);
