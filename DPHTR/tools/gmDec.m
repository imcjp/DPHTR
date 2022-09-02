function [alpha,beta,G] = gmDec(G)
n=size(G,1);
wNode=full(diag(G));
rn=1:n;
G(sub2ind([n n],rn,rn))=0;
wEdge=-full(sum(G,2));
wEdge(1,1)=1;
wNode=log(wNode);
wEdge=log(wEdge);
G(find(G))=1;
G=speye(n)-G;
alpha=G\(wNode-wEdge);
beta=wNode-alpha;
alpha=real(exp(alpha));
beta=real(exp(beta));
end

