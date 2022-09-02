function [res,theta] = getG1withLambda(tree,lambdan,delLeafSt)
n=tree.getN();
n1=tree.getN(1);
fn=tree.getParRep;
% theta=buildQrExt(fn,n1,[]);
% theta=tree.getChnOfNode;
% theta=zeros(n1,1);
% if exist('st')==1
%     rg=1:(n-n1);
%     rg(st)=[];
%     rg=rg+n1;
% else
%     rg=(n1+1):n;
% end
% for i=rg
%     theta(fn(i))=theta(fn(i))+lambdan(i)^2;
% end
% for i=n1:-1:2
% %     theta(fn(i))=theta(fn(i))+lambdan(i)^2*(1-1/(1+theta(i)/lambdan(i)^2));
%     theta(fn(i))=theta(fn(i))+theta(i)/(1+theta(i)/lambdan(i)^2);
% end
if exist('delLeafSt')==1
    leafPos=delLeafSt+n1;
else
    leafPos=[];
end
theta=buildQrExt2(fn,n1,lambdan.^2,leafPos);
% norm(theta-theta2)
wNode=sqrt(theta+lambdan(1:n1).^2);
wEdge=lambdan(1:n1).^2./wNode;
tree1=tree.getSubTree(1);
res=tree1.getGenMat(wNode,wEdge);
end

