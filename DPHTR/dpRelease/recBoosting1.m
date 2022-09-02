function [v] = recBoosting1(treeInfo,vInput)
    global v
    global w
    global k
    v=vInput;
    k=length(treeInfo.getChList(1));
    w=zeros(length(treeInfo),1);
    pgUp(treeInfo,1);
    pgDown(treeInfo,1,0)
end

function [z,height]=pgUp(treeInfo,p)
    global v
    global w
    global k
    z=v(p);
    if p<=treeInfo.getM
        chn=treeInfo.getChList(p);
        s=0;
        height=0;
        for ch=chn
            [sc,hc]=pgUp(treeInfo,ch);
            s=s+sc;
            height=max(height,hc);
        end
        height=height+1;
        v1=(k^height-k^(height-1))/(k^height-1);
        v2=(k^(height-1)-1)/(k^height-1);
        z=v1*z+v2*s;
        w(p)=s;
        v(p)=z;
    else
        height=1;
    end
end

function pgDown(treeInfo,p,pf)
    global v
    global w
    global k
    v(p)=v(p);
    if p>1
        v(p)=v(p)+(v(pf)-w(pf))/k;
    end
    if p<=treeInfo.getM
        chn=treeInfo.getChList(p);
        for ch=chn
            pgDown(treeInfo,ch,p);
        end
    end
end
% fn=tree.getParVec();
% hn=tree.getHeight()+1;
% k=tree.getChildNum();
% k=k(1);
% [nLeaf,n1]=tree.getNodeCnt();
% n=nLeaf+n1;
% zn=zeros(n,1);
% for i=n:-1:1
%     l=hn(i);
%     if i>n1
%         zn(i)=v(i);
%     else
%         zn(i)=(k^l-k^(l-1))/(k^l-1)*v(i)+(k^(l-1)-1)/(k^l-1)*zn(i);
%     end
%     if i>1
%         zn(fn(i))=zn(fn(i))+zn(i);
%     end
% end
% M=tree.getLinearMat();
% szn=zn(1:n1)-M'*zn;
% vAvg=zn;
% for i=2:n
%     vAvg(i)=vAvg(i)+(vAvg(fn(i))-szn(fn(i)))/k;
% end
