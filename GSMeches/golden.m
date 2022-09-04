function [z]=golden(f,a,b)
% 通过黄金分割算法来求解一元凸优化问题的最小值，并返回最小值所在位置。
% eps=1e-8;
a0=a;
b0=b;
P2=(sqrt(5)-1)/2;
P1=1-P2;
eps2=(b-a)*eps;
t1=a+P1*(b-a);
t2=a+P2*(b-a);
y1=f(t1);
y2=f(t2);
while 1
    if y1<=y2
        b=t2;
        if b-a<=eps2
            z=(b+a)/2;
            y3=f(a0);
            if y3<=y1
                z=a0;
                y1=y3;
            end
            if f(b0)<=y1
                z=b0;
            end
            return
        else
            t2=t1;
            y2=y1;
            t1=a+P1*(b-a);
            y1=f(t1);
        end
    else 
        a=t1;
        if b-a<=eps2
            z=(b+a)/2;
            y3=f(a0);
            if y3<=y2
                z=a0;
                y2=y3;
            end
            if f(b0)<=y2
                z=b0;
            end
            return
        else
            t1=t2;
            y1=y2;
            t2=a+P2*(b-a);
            y2=f(t2);
        end
    end
end