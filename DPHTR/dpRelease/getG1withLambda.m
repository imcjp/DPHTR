function [res,theta] = getG1withLambda(tree,lambdan,delLeafSt)
n=tree.getN();
n1=tree.getN(1);
fn=tree.getParRep;
if exist('delLeafSt')==1
    leafPos=delLeafSt+n1;
else
    leafPos=[];
end
theta=buildQrExt2(fn,n1,lambdan.^2,leafPos);
wNode=sqrt(theta+lambdan(1:n1).^2);
wEdge=lambdan(1:n1).^2./wNode;
tree1=tree.getSubTree(1);
res=tree1.getGenMat(wNode,wEdge);
end

