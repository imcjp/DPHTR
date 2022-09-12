function check( M,str1,str2 )
%Check whether the matrix M is a zero matrix, if yes, output str1, otherwise output str2
y=norm(M,'fro');
if y<1e-8
    str=['¡Ì  ' str1];
else
    str=['x  ' str2];
end
disp(str)
end

