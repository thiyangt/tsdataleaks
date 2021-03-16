#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector corw(NumericVector x,NumericVector y){
  // nx > ny
  int ny = y.size();
  int nx = x.size();
  // Rprintf("nx %d ny %d\n",nx,ny);
  NumericVector cor(nx);
  for(int i = 0;i < ny-1;i++){
    cor[i] = NA_REAL;
  }

  bool fresh = false;
  double sY = sum(y);
  double sYSq = sum(pow(y,2));
  double K = sqrt((ny*sYSq)-pow(sY,2));
  double sX;
  double sXSq;
  double old_x_one;
  for(int start = 0;start < (nx - ny+1);start++){
    NumericVector x_slice = x[Rcpp::Range(start,start+ny)];
    //Rprintf("slice start %d slice end %d\n",start,(start+ny));

    if(!fresh){
      double sumXman = 0;
      double sumXSqman = 0;
      for(int i = 0;i<ny;i++){
        //Rprintf("x[%d] = %.4f;",i,x_slice[i]);
        sumXman += x_slice[i];
        sumXSqman += x_slice[i] * x_slice[i];
      }
      old_x_one = x_slice[0];
      sX = sumXman;
      sXSq = sumXSqman;
      fresh = true;
    }else{
      sX = sX - old_x_one + x_slice[ny-1];
      sXSq = sXSq - (old_x_one * old_x_one) + (x_slice[ny-1]*x_slice[ny-1]);
      old_x_one = x_slice[0];
    }
    //Rprintf("\n\n xold = %.4f;sX = %.4f;sXSq = %.4f\n\n",old_x_one,sX,sXSq);
    double sumXYman = 0;
    for(int i = 0;i<ny;i++){
      sumXYman += x_slice[i] * y[i];
    }
    double sXsY = sumXYman;
    double denom = sqrt((ny*sXSq) - (sX*sX)) * K;
    //Rprintf("denom %.4f sY %.4f sYSq %.4f sXsY %.4f\n",denom,sY,sYSq,sXsY);
    double partA = (ny * sXsY) / denom;
    double partB = (sX * sY) / denom;
    double cor_val = partA - partB;
    //Rprintf("cor_val %.4f\n",cor_val);
    cor[start+ny-1] = cor_val;
  }
  return cor;
}
