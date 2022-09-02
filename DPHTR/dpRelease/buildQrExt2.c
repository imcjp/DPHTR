#include <math.h> /* Needed for the ceil() prototype */
#include "mex.h"

void mexFunction(
		 int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]
		 )
{
    mwSize n,n1,nLeaf;
    mwIndex i,j,k;
    double *pr,*sr,*lambdan2,*leafPos;
    if (nrhs != 4) {
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:invalidNumInputs",
                "Three input argument required.");
    }
    if(nlhs > 1){
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:maxlhs",
                "Too many output arguments.");
    }
    
    if (!(mxIsDouble(prhs[0]))){
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:inputNotDouble",
                "Input argument must be of type double.");
    }
    
    if (mxGetNumberOfDimensions(prhs[0]) != 2){
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:inputNot2D",
                "Input argument must be two dimensional\n");
    }
    
    n  = mxGetN(prhs[0])*mxGetM(prhs[0]);
    pr = mxGetPr(prhs[1]);
    lambdan2 = mxGetPr(prhs[2]);
    nLeaf = mxGetN(prhs[3])*mxGetM(prhs[3]);
    leafPos = mxGetPr(prhs[3]);
    n1=*pr;
//     printf("%d\n",n1);
    if (n1==0){
        plhs[0]=mxCreateDoubleMatrix(0,0,mxREAL);
        return;
    }
    pr = mxGetPr(prhs[0]);
    plhs[0]=mxCreateDoubleMatrix(n1,1,mxREAL);
    sr = mxGetPr(plhs[0]);
    for (j=n1;j<n;++j){
        k=pr[j];
        sr[k-1]+=lambdan2[j];
    }
    for (j=0;j<nLeaf;++j){
        i=leafPos[j];
        k=pr[i-1];
        sr[k-1]-=lambdan2[i-1];
    }
    for (j=n1-1;j>0;--j){
        k=pr[j];
        sr[k-1]+=sr[j]*lambdan2[j]/(sr[j]+lambdan2[j]);
    }
//     for (j=0;j<n1;++j){
//         printf("%lf,",sr[j]);
//     }
}
