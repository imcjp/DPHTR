classdef ChRep < handle  
    %���ǲ�����ĺ��ӽڵ��ʾ
    
    properties
        inds;
        chIds;
        n;
        m
    end
    
    methods
        function res = getChList(obj,p)
            % ��ȡ������Ľڵ�ĺ����б�
            res=obj.chIds((obj.inds(p)+1):obj.inds(p+1));
        end
        
        function res = getN(obj)
            % ��ȡ������Ľڵ����
            res = obj.n;
        end
        function res = getM(obj)
            % ��ȡ������ķ�Ҷ�ڵ����
            res = obj.m;
        end
        function [res]=disp(obj)
            res=sprintf('������Ľڵ���Ϊ%i������%i���ڵ�Ϊ��Ҷ�ӽڵ�\n',obj.n,obj.m);
            for i =1:obj.m
                chs=getChList(obj,i);
                chn=length(chs);
                if chn>1
                    tmpS=sprintf(',%i',chs(2:end));
                else
                    tmpS='';
                end
                res=sprintf('%s\t�ڵ���%i����%i���ӽڵ㣺�ֱ���[%i%s];\n',res,i,chn,chs(1),tmpS);
            end
            disp(res)
        end
    end
end

