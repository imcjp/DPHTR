function [] = showgraph(varargin)
% ����showgraph ����չʾһ������ϡ�����Ĺ�ϵͼ
% ���� showgraph(M1,M2,...) �ú���������������ľ�����Ĭ��������ϵ���һ����ҳ�����Թ�ϵͼ����ʽչʾÿ������
% ������ľ����ӦΪ����
% Mi������һ��n*n�ľ������cell
%     ��MiΪcellʱ��Mi{1}��ʾһ��n*n�ľ���
%     Mi{2}��һ��n*2�ľ����һ�б�ʾÿ���ڵ��x���꣬�ڶ��б�ʾÿ���ڵ��y���ꡣ��Ӧ����ֵ����ȡNaN����ʾ���������ϵͳ�����趨
%     Mi{3}Ϊoption�ṹ�壬����'ptScal','edgeScal','arScal'�������ԣ��ֱ���ڽڵ㣬�ߺͼ�ͷ�Ĵ�С��������������ø����ԣ������ߵĴ�С������Ϊ1
%     �ɲ����������з�ʽ����ṹ�壺 
%         opt=struct('ptScal',0.3,'edgeScal',.2,'arScal',.4);
% �ڹ�ϵͼչʾʱ
%     ����Խ����ϵ�Ԫ��m_ii��ʾÿ���ڵ��Ȩ�أ���ͬȨ���ò�ͬ����ɫ��ʶ
%     �ǶԽ����ϵ�Ԫ��m_ij(i!=j)��ʾ��Ӧ�ߵ�Ȩ�أ���̫Ȩ���ò�ͬ����ɫ��ʶ
% ������ľ���Ϊ��������ҳ���ֱ�Ծ����ʵ���Լ��鲿�ֱ���ʾ��������M(real)�Լ�M(imag)��Ϊ���֡�
% ֱ�ӵ��� showmat ����������ϵ���һ��demo��������һЩ������������
addpath(pwd);
conf=config();
url=['http://' conf.url '/showgraph.php'];
% url='http://localhost:8080/MatricesShow/showGraphTemplate.jsp';
m=size(varargin,2);
if m>0
    res=strtrim(urlread(url));
    dr=[matlabroot '\matTemp'];
    if ~exist(dr,'dir')
        mkdir(dr);
    end
    fileName=[num2str(int64(now*1e+5)) '_' num2str(int64(rand()*1e+8))];
    fileName=[dr '\' fileName '.html'];
    fidout=fopen(fileName,'w');
    fprintf(fidout,'%s[',res(1,1:strfind(res,'${data}')-1));
    for i=1:m
        name=inputname(i);
        if size(name,1)==0
            name=['Mat' num2str(i)];
        end
        Mt=varargin{1,i};
        isPos=false;
        isOpt=false;
        if strcmp(class(Mt),'cell')==1
            M=Mt{1};
            if(length(Mt)>=2)
                pos=Mt{2};
                if size(pos,2)==2
                    isPos=true;
                elseif size(pos,1)==2
                    pos=pos';
                    isPos=true;
                end
            end
            if(length(Mt)>=3)
                opt=Mt{3};
                isOpt=true;
            end
        end
        Ms={};
        if isreal(M)==0
            Ms{1}=real(M);
            Ms{2}=imag(M);
            nameSuf{1}='(real)';
            nameSuf{2}='(imag)';
        else
            Ms{1}=real(M);
            nameSuf{1}='';
        end
        for j=1:length(Ms)
            M=Ms{j};
            if strcmp(class(M),'double')==0
                M=double(M);
            end
            M=sparse(M);
            [t1,t2,t3]=find(M);
            if i>1 || j>1
                fprintf(fidout,',');
            end
            optStr='';
            if isOpt
                optStr=',"opt":{';
                if (isfield(opt,'ptScal'))
                    optStr=[optStr sprintf('"ptScal":%g,',getfield(opt,'ptScal'))];
                end
                if (isfield(opt,'arScal'))
                    optStr=[optStr sprintf('"arScal":%g,',getfield(opt,'arScal'))];
                end
                if (isfield(opt,'edgeScal'))
                    optStr=[optStr sprintf('"edgeScal":%g,',getfield(opt,'edgeScal'))];
                end
                optStr=[optStr '}'];
            end
            fprintf(fidout,'{"name":"%s"%s,"size":%d,',[name nameSuf{j}],optStr,size(M,1));
            if isPos
                fprintf(fidout,'"xPos":[');
                fprintf(fidout,'%d,',pos(:,1));
                fprintf(fidout,'],"yPos":[');
                fprintf(fidout,'%d,',pos(:,2));
                fprintf(fidout,'],');
            end
            if size(t3,1)==0
                fprintf(fidout,'"colpt":[0');
                fprintf(fidout,',%d',zeros(size(M,2),1));
                fprintf(fidout,'],"rows":[],"vals":[]}');
            else
                colpt=full(sum(abs(sign(M))));
                colpt=cumsum(colpt);
                fprintf(fidout,'"colpt":[0');
                fprintf(fidout,',%d',colpt);
                fprintf(fidout,'],"rows":[');
                fprintf(fidout,'%d,',t1-1);
                if min(t3)==max(t3)
                    fprintf(fidout,'],"vals":%g,"def":true}',t3(1));
                else
                    fprintf(fidout,'],"vals":[');
                    fprintf(fidout,'%g,',t3);
                    fprintf(fidout,']}');
                end
            end
        end
    end
    fprintf(fidout,']%s',res(1,strfind(res,'${data}')+length('${data}'):end));
    fclose(fidout);
    web('-browser',fileName);
    files = dir(fullfile(dr,'*.html'));
    nf=size(files,1);
    for i=1:nf
        tm=files(i,1).datenum;
        if now-tm>1/48
            delete([dr '\' files(i,1).name]);
        end
    end
else
    web('-browser','http://matweb.applinzi.com/example/showgraph.html');
end
end