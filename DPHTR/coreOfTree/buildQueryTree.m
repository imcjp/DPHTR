function [tree,H] = buildQueryTree(n,posn)
% ����Ҷ�ڵ��Լ������ڵ�������ֵı���������ѯ�����
% ���룺
% 1. n:Ҷ�ڵ���
% 2. posn:������ͬ�ڵ�������ֵı�����posn(i)ָ���Ƕ���Ϊ(i-1)�Ľڵ���ֵı�����ע��posn(i)���Լ�������Ϊ1��������Ǹ���ֵԽ��ı�ʾ��Ӧ�ȳ��ָ���Խ�ߡ�
% �����
% 1. tree:�����
% 2. H:ӳ�����h_ij==1��ʾ��i��Ҷ�ڵ���ڵĲ�������Ϊj
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
t2=(length(fnn)-n+1):length(fnn);% �������Ҷ�ڵ�һ����fn�����
t2=matId(t2); %������ӳ��Ϊ�����ı��
t3=ones(n,1);
H=sparse(t1,t2,t3,n,length(fnn));
end

