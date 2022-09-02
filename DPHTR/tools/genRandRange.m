function rg = genRandRange(m,n)
rg=randi(m,2,n);
st=(rand(1,n)<1/(m+1));
rg(2,st)=rg(1,st);
rg=sort(rg);
