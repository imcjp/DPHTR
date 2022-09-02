function showTree(tree)
mat=tree.getAdjMat();
% mat=edgeMat+nodeMat;
height=tree.getHeight();
n=tree.getN;
nodeColors=zeros(n,1);
nodeColors(height>1)=-1;
nodeColors(1)=1;
mat=mat+spdiags(nodeColors,0,n,n);
showgraph({mat})
end

