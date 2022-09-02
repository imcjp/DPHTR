function [vAvgPos,iter] = GMPC(tree,v)
% ����Ǹ�һ���ԵĲ�����㷨�����������Ľ����ڲ�ʹ�þ����ת�ã���ʹ�þ�����ҳˣ����������ˣ������������ڴ�ռ��ʹ�á�8G�ڴ����֧�ֵ�6ǧ������
% �Ľ�ȥ���˶��㷨�ڶ��Σ���0�Ľ������̵������жϣ�����ɾ����kkt2�������Ե�ͳ�ƣ���Ϊ���Դ�������֤�����㷨�ڶ���kkt2��Ȼ������
% ȥ����NQP�㷨�Ĳ���
% ���Ż����н����Ե���������
M=tree.getCCMat();% һ����Լ������
[n,m]=size(M);
R=getG1(tree);% QR�ֽ��ľ���
M2=M((m+1):end,:);
vAvg=v-M*(R\(v'*M/R)'); 
b=vAvg((m+1):end,:);
%% ��ʼ��
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