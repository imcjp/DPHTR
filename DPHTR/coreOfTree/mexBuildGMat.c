#include <math.h> /* Needed for the ceil() prototype */
#include "mex.h"

/* If you are using a compiler that equates NaN to be zero, you must
 * compile this example using the flag  -DNAN_EQUALS_ZERO. For example:
 *
 *     mex -DNAN_EQUALS_ZERO fulltosparse.c
 *
 * This will correctly define the IsNonZero macro for your C compiler.
 */

void mexFunction(
		 int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]
		 )
{
    mwSize nzmax,n;
    mwIndex *irs,*jcs,i,j,k;
    double *pr,*sr,*pr1;
    
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
    if (n==0){
        plhs[0] = mxCreateSparse(0,0,0,0);
        return;
    }
    pr = mxGetPr(prhs[0]);
    nzmax=(mwSize)(2*n-1);
    
    plhs[0] = mxCreateSparse(n,n,nzmax,0);
    sr  = mxGetPr(plhs[0]);
    irs = mxGetIr(plhs[0]);
    jcs = mxGetJc(plhs[0]);
    for (j=1;j<=n;++j){
        jcs[j]++;
    }
    for (j=1;j<n;++j){
        k=pr[j];
        jcs[k]++;
    }
    
    for (j=1;j<=n;++j){
        jcs[j]+=jcs[j-1];
    }
    
    if(nrhs == 1){
        for (j=0;j<n;++j){
            k=jcs[j]++;
            irs[k]=j;
            sr[k]=1;
        }
        for (j=1; j<n; ++j) {
            k=pr[j];
            i=jcs[k-1]++;
            irs[i]=j;
            sr[i]=-1;
        }
        for (j=n; j;--j) {
            jcs[j]=jcs[j-1];
        }
        jcs[0]=0;
    }else if(nrhs == 3){
        pr1 = mxGetPr(prhs[1]);
        for (j=0;j<n;++j){
            k=jcs[j]++;
            irs[k]=j;
            sr[k]=*pr1;
            ++pr1;
        }
        pr1 = mxGetPr(prhs[2]);
        ++pr1;
        for (j=1; j<n; ++j) {
            k=pr[j];
            i=jcs[k-1]++;
            irs[i]=j;
            sr[i]=-(*pr1);
            ++pr1;
        }
        for (j=n; j;--j) {
            jcs[j]=jcs[j-1];
        }
        jcs[0]=0;
    }else{
        mexErrMsgIdAndTxt( "MATLAB:fulltosparse:maxlhs",
                "Input arguments number should be 1 or 3.");
    }
}
