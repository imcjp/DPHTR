function [tree]=buildRandTree(n,posn)
    % ���ݽڵ�������һ�������,����������n���ڵ㣨���ܱ����Զࣩ
    % ���ɹ��̸���posn��ֵ�����ڵ�������
    % posn(1)��ʾ���ɶ�Ϊ0�Ľڵ�ĸ��ʱ�����posn(2)��ʾ���ɶ�Ϊ1�Ľڵ�ĸ��ʱ������Դ�����
    %% ���ݸ������������
    if strcmp(class(posn),'TreeGenProb')==1
        posn=posn.theProb;
    end
    posn=posn/sum(posn);
    posn2=cumsum(posn);
    alpha=0.2;
    n1=round(alpha*n);
    n2=n-n1;
    stn2=zeros(n2,1); %�������ÿ���ڵ�Ķȣ�δ�������Ľڵ㣩
    rdn=rand(n2,1);
    for i=2:length(posn)
        stn2(rdn>=posn2(i-1) & rdn<posn2(i))=i-1;
    end
    posn(1)=[];
    posn=posn/sum(posn);
    posn2=cumsum(posn);
    stn1=ones(n1,1);%�������ÿ���ڵ�Ķȣ����������Ȳ���Ϊ0���Ľڵ㣩
    rdn=rand(n1,1);
    for i=2:length(posn)
        stn1(rdn>=posn2(i-1) & rdn<posn2(i))=i;
    end
    stn=[stn1;stn2];%�������ÿ���ڵ�Ķ�
    fn=-ones(n,1);%���ø��״洢�ṹ�洢��
    fn(1)=0;% ��1���ڵ�һ��Ϊ��
    s=1;%��ǰ�������ӽڵ�Ľڵ�
    t=2;%��ǰδ�����丸�ڵ�Ľڵ�
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