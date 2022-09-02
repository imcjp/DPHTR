function [res] = getComputerName()
res=strtrim(evalc('system("echo %COMPUTERNAME%");'));
end

