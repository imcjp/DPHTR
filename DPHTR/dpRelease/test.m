clear all;clc;close all;
isShow=0;
% 根据树的父节点表示法构造一个树结构
fn0=[0,1,1,2,2,3,3,3,4,4];
% fn0=[0,1];
tree=buildTreebyFn(fn0);
if isShow
    showTree(tree)
end
% 构造高斯机制
epsilon=1
delta=1e-5
noiMech=GsMech(epsilon,delta);
% noiMech=LapMech(epsilon);
disp(noiMech);
% 给定非均匀隐私预算
lambdan=rand(length(fn0),1);
% 构造噪声数据
releaser=DPReleaser(tree,noiMech,lambdan);
xn=randn(releaser.m,1);
vn=releaser.buildTree(xn);
noiVn=releaser.addNoise(vn);
% 简单的发布，仅支持非负性发布
releaser=SimpleDPReleaser(tree,noiMech,lambdan);
fprintf('发布器为%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % 无处理
rmse=sqrt(sum((avgV1-vn).^2))
info
[avgV1,info]=releaser.nonNegConsistency(noiVn); % 简单第将小于0的节点置0，不满足一致性
rmse=sqrt(sum((avgV1-vn).^2))
info
% Boosting的发布，只支持一致性
releaser=BoostingDPReleaser(tree,noiMech); % 不支持非均匀隐私预算
fprintf('发布器为%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); 
rmse=sqrt(sum((avgV1-vn).^2))
info
% PrivTrie的发布，只支持一致性
releaser=PrivTrieDPReleaser(tree,noiMech,lambdan);
fprintf('发布器为%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % 无处理
rmse=sqrt(sum((avgV1-vn).^2))
info
% 使用二次规划求解器的发布，只支持一致性和非负性
releaser=DPReleaser(tree,noiMech,lambdan);
fprintf('发布器为%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % 无处理
rmse=sqrt(sum((avgV1-vn).^2))
info
[avgV1,info]=releaser.nonNegConsistency(noiVn); % 简单第将小于0的节点置0，不满足一致性
rmse=sqrt(sum((avgV1-vn).^2))
info
% 使用基于生成矩阵的发布，只支持一致性和非负性
releaser=GMDPReleaser(tree,noiMech,lambdan);
fprintf('发布器为%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % 无处理
rmse=sqrt(sum((avgV1-vn).^2))
info
[avgV1,info]=releaser.nonNegConsistency(noiVn); % 简单第将小于0的节点置0，不满足一致性
rmse=sqrt(sum((avgV1-vn).^2))
info