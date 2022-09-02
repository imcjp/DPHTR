function [v] = recPrivTrie(treeInfo,vInput)
    global v
    global sn
    global rn
    v=vInput;
    n1=length(treeInfo);
    n=length(vInput);
    sn=[zeros(n1,1);ones(n-n1,1)];
    rn=[zeros(n1,1);ones(n-n1,1)];
    pgUp(treeInfo,1);
    pgSum(treeInfo,1,0);
    pgUp2(treeInfo,1);
    pgDown(treeInfo,1,0);
end

function [sv]=pgUp(treeInfo,p)
    global sn
    global rn
    if p<=treeInfo.getM
        chn=treeInfo.getChList(p);
        s=0;
        for ch=chn
            sc=pgUp(treeInfo,ch);
            s=s+sc;
        end
        rn(p)=1/(1+s);
        sv=s*rn(p);
        sn(p)=sv;
    else
        sv=sn(p);
    end
end

function [sv]=pgUp2(treeInfo,p)
    global v
    global rn
    if p<=treeInfo.getM
        chn=treeInfo.getChList(p);
        s=0;
        for ch=chn
            sc=pgUp2(treeInfo,ch);
            s=s+sc;
        end
        v(p)=s*rn(p);
    else
        v(p)=v(p)*rn(p);
    end
    sv=v(p);
end
function [s]=pgSum(treeInfo,p,sumAnc)
    global v
    if p<=treeInfo.getM
        sumAnc1=sumAnc+v(p);
        v(p)=0;
        chn=treeInfo.getChList(p);
        for ch=chn
            pgSum(treeInfo,ch,sumAnc1);
        end
    else
        v(p)=v(p)+sumAnc;
    end
end
function pgDown(treeInfo,p,sumAnc)
    global v
    global sn
    v(p)=v(p);
    if p>1
        v(p)=v(p)-sn(p)*sumAnc;
    end
    if p<=treeInfo.getM
        sumAnc1=sumAnc+v(p);
        chn=treeInfo.getChList(p);
        for ch=chn
            pgDown(treeInfo,ch,sumAnc1);
        end
    end
end
