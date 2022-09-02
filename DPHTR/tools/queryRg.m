function [res] = queryRg(rg,vn,lrg,rrg,chInd)
global ques;
qs=1;
qt=1;
ques(:,qt)=[rg;1];
qt=qt+1;
res=0;
while qs<qt
    qn=ques(:,qs);
    qs=qs+1;
    pos=qn(3);
    if qn(1)==lrg(pos) && qn(2)==rrg(pos)
        res=res+vn(pos);
    else
        for i=chInd(pos):(chInd(pos+1)-1)
            qn2(1)=max(lrg(i),qn(1));
            qn2(2)=min(rrg(i),qn(2));
            if qn2(1)<=qn2(2)
                qn2(3)=i;
                ques(:,qt)=qn2(:);
                qt=qt+1;
            end
        end
    end
end