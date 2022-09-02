function [tree,matId]=buildTreebyFn(fn)
% 根据父节表示法构建层次树，构建后的层次树是按照高度递减顺序排序的。
% 输入：
% 1. fn:各个节点的父节点
% 输出：
% 1. tree:层次树
% 2. matId: 原来的每个节点在高度递减排序后的编号
    %% 根据概率生成随机数
    n=length(fn);
    t1=(2:n)';
    t2=fn(t1);
    t3=ones(n-1,1);
    edgeMatrix=sparse(t1,t2,t3,n,n);%树的稀疏矩阵表示形式
    [hn,nLvl]=mexDfsHeight(edgeMatrix);%求得hn为树中每个节点的高度，nLvl表示每个高度的节点数
    height=double(hn);
    nLvl=double(nLvl);
    %% 将原本树节点的编号重新调整，使得树中节点高度的顺序与编号顺序一致
    matId2ndId=[(1:n)' height];
    matId2ndId=sortrows(matId2ndId,[-2,1]);
    matId2ndId=matId2ndId(:,1);
    ndId2matId=[(1:n)' matId2ndId];
    ndId2matId=sortrows(ndId2matId,2);
    ndId2matId=ndId2matId(:,1);
    fn=fn(int32(matId2ndId));
    fn(1)=1;
    fn=ndId2matId(fn);
    fn(1)=0;
    tree=Tree();
    tree.nodeHeight=height(matId2ndId)+1;
    tree.fatherId=fn;
%     tree.nodeHeightCount=nLvl;
    tree.nodeCount=cumsum(nLvl,1,'reverse');
    matId=ndId2matId;
end