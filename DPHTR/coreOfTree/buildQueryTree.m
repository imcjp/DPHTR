function [tree,H] = buildQueryTree(n,posn)
% 根据叶节点以及各个节点度数出现的比例构建查询层次树
% 输入：
% 1. n:叶节点树
% 2. posn:各个不同节点度数出现的比例，posn(i)指的是度数为(i-1)的节点出现的比例。注意posn(i)可以加起来不为1，但必须非负，值越大的表示相应度出现概率越高。
% 输出：
% 1. tree:层次树
% 2. H:映射矩阵，h_ij==1表示第i个叶节点对于的层次树编号为j
nt=n;
fnn=[];
if strcmp(class(posn),'TreeGenProb')==1
    posn=posn.theProb;
end
while 1
    fn=zeros(nt,1);
    if nt==1
        fnn=[fn;fnn];
        break;
    end
    xn=getDivision(nt,posn);
    p=1;
    for i=1:length(xn)
        for j=1:xn(i)
            fn(p)=i;
            p=p+1;
        end
    end
    nt=length(xn);
	fnn=[fn;fnn+nt];
end
fnn=round(fnn);
[tree,matId]=buildTreebyFn(fnn);
t1=1:n;
t2=(length(fnn)-n+1):length(fnn);% 构建后的叶节点一定在fn的最后
t2=matId(t2); %把他们映射为排序后的编号
t3=ones(n,1);
H=sparse(t1,t2,t3,n,length(fnn));
end

