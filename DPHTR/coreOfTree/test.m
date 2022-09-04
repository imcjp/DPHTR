clear all;clc;close all;
posn=TreeGenProb([0,1,10,5])
% 指定叶子节点数，构造一个随机的查询树
[tree1,H] = buildQueryTree(20,posn);
% 指定树的总节点数，构造一个随机的树结构
tree2=buildRandTree(30,posn);
% 根据树的父节点表示发构造一个树结构
fn0=[0,1,1,2,2,3,3,3,4,4];
tree3=buildTreebyFn(fn0);
% 展示图的节点数，给出参数k得到k阶子树的节点数
n=tree1.getN();
k=3;
nk=tree1.getN(k);
fprintf('树包含%i个节点，%i阶子树包含%i个节点\n',n,k,nk);
% 获得层次树的结构矩阵
stru=tree1.getStruMat;
fprintf('树的结构矩阵如下：\n');
disp(full(stru))
% 获得层次树的一致性约束矩阵
ccMat=tree1.getCCMat;
fprintf('树的一致性约束矩阵如下：\n');
disp(full(ccMat))
% 获得层次树的叶节点映射矩阵H
H=tree1.getLeafMappingMat;
fprintf('树的叶节点映射矩阵H如下：\n');
disp(full(H))
% 获得层次树的生成矩阵
wNode=rand(n,1); %设定点权
wEdge=rand(n,1); %设定边权
genMat=tree1.getGenMat(wNode,wEdge);
fprintf('树的生成矩阵如下：\n');
disp(full(genMat))
% 获得层次树的邻接矩阵
adjMat=tree1.getAdjMat;
fprintf('树的邻接矩阵如下：\n');
disp(full(adjMat))
% 获得层次树的拉普拉斯矩阵
lapMat=tree1.getLapMat;
fprintf('树的拉普拉斯矩阵如下：\n');
disp(full(lapMat))
% 获得层次树的距离矩阵
distMat=tree1.getDistMat;
fprintf('树的距离矩阵如下：\n');
disp(distMat)
% 获得层次树的祖先矩阵
ancMat=tree1.getAncMat;
fprintf('树的祖先矩阵如下：\n');
disp(ancMat)
% 获取层次树的父节点表示
fn=tree1.getParRep;
fprintf('树的父节点信息如下：\n');
for i=1:n
    if i==1
        fprintf('第%i个节点为根节点;\t',i);
    else
        fprintf('第%i个节点的父节点为节点%i\t',i,fn(i));
    end
    if i==n || mod(i,5)==0
        fprintf('\n')
    end
end
% 获取层次树各个节点高度
hn=tree1.getHeight;
fprintf('树的高度信息如下：\n');
for i=1:n
    fprintf('第%i个节点的父节点为节点%i\t',i,hn(i));
    if i==n || mod(i,5)==0
        fprintf('\n')
    end
end
% 获取层次树各个节点高度
chRep=tree1.getChRep;
disp(chRep);
% k阶子树
k=3;
subTree=tree1.getSubTree(k)
