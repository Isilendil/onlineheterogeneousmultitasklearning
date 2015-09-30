#include <math.h>
#include "mex.h"
#include "matrix.h"

#define mlog2pi  -1.837877

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  double *X, *W, *Y, *out;
  mwIndex m, n;
  mwIndex *ir_x, *jc_x, *ir_w, *jc_w, *ir_y, *jc_y;
  double loglik = 0;
  mwIndex ix,iw,iy,j;
  
  if (nrhs<3) 
    mexErrMsgTxt("usage: loglik = gaussian(X,W,Y)\n");
  
  m = mxGetM(prhs[0]);
  n = mxGetN(prhs[0]);
  if (mxGetM(prhs[1])!=m || mxGetM(prhs[2])!=m || mxGetN(prhs[1])!=n || mxGetN(prhs[2])!=n)
    mexErrMsgTxt("X ,W and Y must be of the same size");
  if (!mxIsSparse(prhs[0]) || !mxIsSparse(prhs[1]) || !mxIsSparse(prhs[2]))
    mexErrMsgTxt("X, W and Y must all be sparse");
  X = mxGetPr(prhs[0]);
  ir_x = mxGetIr(prhs[0]);
  jc_x = mxGetJc(prhs[0]);
  
  W = mxGetPr(prhs[1]);
  ir_w = mxGetIr(prhs[1]);
  jc_w = mxGetJc(prhs[1]);
  
  Y = mxGetPr(prhs[2]);
  ir_y = mxGetIr(prhs[2]);
  jc_y = mxGetJc(prhs[2]);

  for(j=0;j<n;j++) {
    ix=jc_x[j];
    iy=jc_y[j];
    for (iw=jc_w[j];iw<jc_w[j+1];iw++) {
      while (ir_x[ix]<ir_w[iw] && ix<jc_x[j+1])
        ix++;
      while (ir_y[iy]<ir_w[iw] && iy<jc_y[j+1])
        iy++;
      if (ir_y[iy]==ir_w[iw] && ir_x[ix]==ir_w[iw]) {
        loglik += W[iw]*(mlog2pi-0.5*pow(X[ix]-Y[iy],2));

      } else if (ir_y[iy]!=ir_w[iw] && ir_x[ix]==ir_w[iw]) {
        loglik += W[iw]*(mlog2pi-0.5*pow(X[ix],2));

      } else if (ir_y[iy]==ir_w[iw] && ir_x[ix]!=ir_w[iw]) {
        loglik += W[iw]*(mlog2pi-0.5*pow(Y[iy],2));

      } else {
        loglik += W[iw]*mlog2pi;
      }
    }
  }

  plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
  out = mxGetPr(plhs[0]);
  out[0] =-1*loglik;
}