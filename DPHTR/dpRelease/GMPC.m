function [vAvgPos,iter] = GMPC(tree,v)
% 满足非负一致性的层次树算法（精炼），改进在于不使用矩阵的转置，而使用矩阵的右乘（除）替代左乘（除），减少内存空间的使用。8G内存可以支持到6千万数据
% 改进去掉了对算法第二段（非0的解析过程的条件判断），并删掉了kkt2不满足性的统计，因为可以从理论论证经过算法第二段kkt2必然都满足
% 去掉了NQP算法的部分
% 该优化具有较明显的性能提升
M=tree.getCCMat();% 一致性约束矩阵
[n,m]=size(M);
R=getG1(tree);% QR分解后的矩阵
M2=M((m+1):end,:);
vAvg=v-M*(R\(v'*M/R)'); 
b=vAvg((m+1):end,:);
%% 初始化
iter=0;
deltaSt=b<-eps;
mxIter=300;
while sum(deltaSt)>0 && iter<mxIter
    iter=iter+1;
    if iter==1
        st=deltaSt;
    else
        st=st|deltaSt;
    end
    noSt=~st;
    R2=getG1ByDelLeaf(tree,find(st));
    bt=b;
    bt(noSt)=0;
    dv1=M2*(R2\(bt'*M2/R2)');
    dv1(noSt)=0;
    beta=-bt-dv1;
    Av=beta-M2*(R\(beta'*M2/R)');
    dt=Av+b;
    deltaSt=(noSt & dt<-eps);
%     sum(deltaSt)
end
if iter>=1
    beta2=[zeros(m,1);beta];
    vAvgPos=v-M*(R\((v'*M+beta'*M2)/R)')+beta2;
else
    vAvgPos=vAvg;
end
end