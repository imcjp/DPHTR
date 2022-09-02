function check( M,str1,str2 )
%检验矩阵M是否为零矩阵，是的话输出str1，否则输出str2
y=norm(M,'fro');
if y<1e-8
    str=['√  ' str1];
else
    str=['x  ' str2];
end
disp(str)
end

