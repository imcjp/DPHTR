function [res,theta] = getG1(tree)
n1=tree.getN(1);
fn=tree.getParRep;
theta=buildQrExt(fn,n1,[]);
% theta=tree.getChnOfNode;
% theta=theta(1:n1,1);
% for i=n1:-1:2
%     theta(fn(i))=theta(fn(i))-1/(1+theta(i));
% end
wNode=sqrt(theta+1);
wEdge=1./wNode;
tree1=tree.getSubTree(1);
res=tree1.getGenMat(wNode,wEdge);
end

