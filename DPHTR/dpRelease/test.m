clear all;clc;close all;
isShow=0;
% �������ĸ��ڵ��ʾ������һ�����ṹ
fn0=[0,1,1,2,2,3,3,3,4,4];
% fn0=[0,1];
tree=buildTreebyFn(fn0);
if isShow
    showTree(tree)
end
% �����˹����
epsilon=1
delta=1e-5
noiMech=GsMech(epsilon,delta);
% noiMech=LapMech(epsilon);
disp(noiMech);
% �����Ǿ�����˽Ԥ��
lambdan=rand(length(fn0),1);
% ������������
releaser=DPReleaser(tree,noiMech,lambdan);
xn=randn(releaser.m,1);
vn=releaser.buildTree(xn);
noiVn=releaser.addNoise(vn);
% �򵥵ķ�������֧�ַǸ��Է���
releaser=SimpleDPReleaser(tree,noiMech,lambdan);
fprintf('������Ϊ%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % �޴���
rmse=sqrt(sum((avgV1-vn).^2))
info
[avgV1,info]=releaser.nonNegConsistency(noiVn); % �򵥵ڽ�С��0�Ľڵ���0��������һ����
rmse=sqrt(sum((avgV1-vn).^2))
info
% Boosting�ķ�����ֻ֧��һ����
releaser=BoostingDPReleaser(tree,noiMech); % ��֧�ַǾ�����˽Ԥ��
fprintf('������Ϊ%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); 
rmse=sqrt(sum((avgV1-vn).^2))
info
% PrivTrie�ķ�����ֻ֧��һ����
releaser=PrivTrieDPReleaser(tree,noiMech,lambdan);
fprintf('������Ϊ%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % �޴���
rmse=sqrt(sum((avgV1-vn).^2))
info
% ʹ�ö��ι滮������ķ�����ֻ֧��һ���ԺͷǸ���
releaser=DPReleaser(tree,noiMech,lambdan);
fprintf('������Ϊ%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % �޴���
rmse=sqrt(sum((avgV1-vn).^2))
info
[avgV1,info]=releaser.nonNegConsistency(noiVn); % �򵥵ڽ�С��0�Ľڵ���0��������һ����
rmse=sqrt(sum((avgV1-vn).^2))
info
% ʹ�û������ɾ���ķ�����ֻ֧��һ���ԺͷǸ���
releaser=GMDPReleaser(tree,noiMech,lambdan);
fprintf('������Ϊ%s\n',releaser.name);
[avgV1,info]=releaser.consistency(noiVn); % �޴���
rmse=sqrt(sum((avgV1-vn).^2))
info
[avgV1,info]=releaser.nonNegConsistency(noiVn); % �򵥵ڽ�С��0�Ľڵ���0��������һ����
rmse=sqrt(sum((avgV1-vn).^2))
info