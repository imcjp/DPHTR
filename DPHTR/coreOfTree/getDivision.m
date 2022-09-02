function [xn] = getDivision(n,posn)
posn=posn/sum(posn);
posn2=cumsum(posn);
rdn=rand(n,1);
xn=zeros(n,1);
for i=2:length(posn)
    xn(rdn>=posn2(i-1) & rdn<posn2(i))=i-1;
end
rg=find(posn)-1;
a=min(rg);
b=max(rg);
sxn=cumsum(xn);
p=max(find(sxn<=n));
xn=xn(1:p);
s=sum(xn);
d=n-s;
if d>=a
    xn=[xn;d];
else
    for i=1:d
        sm=find(xn<b);
        if length(sm)==0
            pt=randi(length(xn));
            while 1
                rd=rand();
                x1=0;
                for i2=2:length(posn)
                    x1(rd>=posn2(i2-1) & rd<posn2(i2))=i2-1;
                end
                x2=b+1-x1;
                if x2>=a && x2<=b
                    xn(pt)=x1;
                    xn=[xn;x2];
                    break;
                end
            end
        else
            pt=randi(length(sm));
            xn(pt)=xn(pt)+1;
        end
    end
end
end

