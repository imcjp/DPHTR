function check( M,str1,str2 )
%�������M�Ƿ�Ϊ������ǵĻ����str1���������str2
y=norm(M,'fro');
if y<1e-8
    str=['��  ' str1];
else
    str=['x  ' str2];
end
disp(str)
end

