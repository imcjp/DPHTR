function [] = showgraph(varargin)
% 函数showgraph 用于展示一个或多个稀疏矩阵的关系图
% 调用 showgraph(M1,M2,...) 该函数将根据所输入的矩阵在默认浏览器上弹出一个网页，并以关系图的形式展示每个矩阵。
% 所输入的矩阵均应为方阵
% Mi可以是一个n*n的矩阵或者cell
%     当Mi为cell时，Mi{1}表示一个n*n的矩阵；
%     Mi{2}是一个n*2的矩阵第一列表示每个节点的x坐标，第二列表示每个节点的y坐标。相应坐标值可以取NaN，表示该坐标点由系统自行设定
%     Mi{3}为option结构体，包含'ptScal','edgeScal','arScal'三个属性，分别调节节点，边和箭头的大小比例。如果不设置该属性，则三者的大小比例均为1
%     可采用形如下列方式构造结构体： 
%         opt=struct('ptScal',0.3,'edgeScal',.2,'arScal',.4);
% 在关系图展示时
%     矩阵对角线上的元素m_ii表示每个节点的权重，不同权重用不同的颜色标识
%     非对角线上的元素m_ij(i!=j)表示相应边的权重，不太权重用不同的颜色标识
% 所输入的矩阵为复矩阵，网页将分别对矩阵的实部以及虚部分别显示，并标以M(real)以及M(imag)作为区分。
% 直接调用 showmat 将在浏览器上弹出一个demo，里面有一些特殊矩阵的例子
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