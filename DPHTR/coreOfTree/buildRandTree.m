function [tree]=buildRandTree(n,posn)
    % 根据节点数生成一棵随机树,该树至少有n个节点（可能比它略多）
    % 生成过程根据posn的值产生节点的随机度
    % posn(1)表示生成度为0的节点的概率比例，posn(2)表示生成度为1的节点的概率比例，以此类推
    %% 根据概率生成随机数
    if strcmp(class(posn),'TreeGenProb')==1
        posn=posn.theProb;
    end
    posn=posn/sum(posn);
    posn2=cumsum(posn);
    alpha=0.2;
    n1=round(alpha*n);
    n2=n-n1;
    stn2=zeros(n2,1); %随机树中每个节点的度（未被保护的节点）
    rdn=rand(n2,1);
    for i=2:length(posn)
        stn2(rdn>=posn2(i-1) & rdn<posn2(i))=i-1;
    end
    posn(1)=[];
    posn=posn/sum(posn);
    posn2=cumsum(posn);
    stn1=ones(n1,1);%随机树中每个节点的度（被保护（度不会为0）的节点）
    rdn=rand(n1,1);
    for i=2:length(posn)
        stn1(rdn>=posn2(i-1) & rdn<posn2(i))=i;
    end
    stn=[stn1;stn2];%随机树中每个节点的度
    fn=-ones(n,1);%采用父亲存储结构存储树
    fn(1)=0;% 第1个节点一定为根
    s=1;%当前待分配子节点的节点
    t=2;%当前未被分配父节点的节点
    while t<=n
        u=s;
        nx=stn(s);
        s=s+1;
        if t<=n && nx>0
            for i=1:nx
                fn(t)=u;
                t=t+1;
            end
        end
    end
    fn=fn(1:n);
    [tree,matId]=buildTreebyFn(fn);
end