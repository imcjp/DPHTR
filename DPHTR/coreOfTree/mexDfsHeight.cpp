#include "mex.h"
#include <memory.h>
#include<iostream>
#include <queue>
using namespace std;
mwIndex *ir, *jc;
int *pr1,*pr2;

int dfs(int p){
    int res=-1;
    int i=jc[p],i2=jc[p+1];
    int t=0;
    for (;i<i2;++i){
        t=dfs(ir[i]);
        if (res<t){
            res=t;
        }
    }
    res++;
    pr1[p]=res;
    return res;
}
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[] )
{
    int i,j,n;
    ir = mxGetIr(prhs[0]);
    jc = mxGetJc(prhs[0]);
    n = mxGetM(prhs[0]);
    plhs[0]=mxCreateNumericMatrix(n,1,mxINT32_CLASS,mxREAL);
    pr1 = (int*)mxGetPr(plhs[0]);
    dfs(0);
    plhs[1]=mxCreateNumericMatrix(*pr1+1,1,mxINT32_CLASS,mxREAL);
    pr2 = (int*)mxGetPr(plhs[1]);
    for(i=0;i<n;++i,++pr1)
    {
        pr2[*pr1]++;
    }
}