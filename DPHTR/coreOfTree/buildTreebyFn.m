function [tree,matId]=buildTreebyFn(fn)
% ���ݸ��ڱ�ʾ�������������������Ĳ�����ǰ��ո߶ȵݼ�˳������ġ�
% ���룺
% 1. fn:�����ڵ�ĸ��ڵ�
% �����
% 1. tree:�����
% 2. matId: ԭ����ÿ���ڵ��ڸ߶ȵݼ������ı��
    %% ���ݸ������������
    n=length(fn);
    t1=(2:n)';
    t2=fn(t1);
    t3=ones(n-1,1);
    edgeMatrix=sparse(t1,t2,t3,n,n);%����ϡ������ʾ��ʽ
    [hn,nLvl]=mexDfsHeight(edgeMatrix);%���hnΪ����ÿ���ڵ�ĸ߶ȣ�nLvl��ʾÿ���߶ȵĽڵ���
    height=double(hn);
    nLvl=double(nLvl);
    %% ��ԭ�����ڵ�ı�����µ�����ʹ�����нڵ�߶ȵ�˳������˳��һ��
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