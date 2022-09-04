clear all;clc;close all;
posn=TreeGenProb([0,1,10,5])
% ָ��Ҷ�ӽڵ���������һ������Ĳ�ѯ��
[tree1,H] = buildQueryTree(20,posn);
% ָ�������ܽڵ���������һ����������ṹ
tree2=buildRandTree(30,posn);
% �������ĸ��ڵ��ʾ������һ�����ṹ
fn0=[0,1,1,2,2,3,3,3,4,4];
tree3=buildTreebyFn(fn0);
% չʾͼ�Ľڵ�������������k�õ�k�������Ľڵ���
n=tree1.getN();
k=3;
nk=tree1.getN(k);
fprintf('������%i���ڵ㣬%i����������%i���ڵ�\n',n,k,nk);
% ��ò�����Ľṹ����
stru=tree1.getStruMat;
fprintf('���Ľṹ�������£�\n');
disp(full(stru))
% ��ò������һ����Լ������
ccMat=tree1.getCCMat;
fprintf('����һ����Լ���������£�\n');
disp(full(ccMat))
% ��ò������Ҷ�ڵ�ӳ�����H
H=tree1.getLeafMappingMat;
fprintf('����Ҷ�ڵ�ӳ�����H���£�\n');
disp(full(H))
% ��ò���������ɾ���
wNode=rand(n,1); %�趨��Ȩ
wEdge=rand(n,1); %�趨��Ȩ
genMat=tree1.getGenMat(wNode,wEdge);
fprintf('�������ɾ������£�\n');
disp(full(genMat))
% ��ò�������ڽӾ���
adjMat=tree1.getAdjMat;
fprintf('�����ڽӾ������£�\n');
disp(full(adjMat))
% ��ò������������˹����
lapMat=tree1.getLapMat;
fprintf('����������˹�������£�\n');
disp(full(lapMat))
% ��ò�����ľ������
distMat=tree1.getDistMat;
fprintf('���ľ���������£�\n');
disp(distMat)
% ��ò���������Ⱦ���
ancMat=tree1.getAncMat;
fprintf('�������Ⱦ������£�\n');
disp(ancMat)
% ��ȡ������ĸ��ڵ��ʾ
fn=tree1.getParRep;
fprintf('���ĸ��ڵ���Ϣ���£�\n');
for i=1:n
    if i==1
        fprintf('��%i���ڵ�Ϊ���ڵ�;\t',i);
    else
        fprintf('��%i���ڵ�ĸ��ڵ�Ϊ�ڵ�%i\t',i,fn(i));
    end
    if i==n || mod(i,5)==0
        fprintf('\n')
    end
end
% ��ȡ����������ڵ�߶�
hn=tree1.getHeight;
fprintf('���ĸ߶���Ϣ���£�\n');
for i=1:n
    fprintf('��%i���ڵ�ĸ��ڵ�Ϊ�ڵ�%i\t',i,hn(i));
    if i==n || mod(i,5)==0
        fprintf('\n')
    end
end
% ��ȡ����������ڵ�߶�
chRep=tree1.getChRep;
disp(chRep);
% k������
k=3;
subTree=tree1.getSubTree(k)
