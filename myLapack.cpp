#ifdef OSX
    #include <Accelerate/Accelerate.h>//On OSX
#elif defined MKL
    #include "mkl.h"
#endif

#include "myLapack.h"

void Diag(double* Kij, int N, double* Eig, double* EigVec)
{
    memcpy(EigVec, Kij, N * N * sizeof(double));
    int ldA = N;
    int lwork = -1;
    double worktest;
    int info;
    dsyev((char*)"V", (char*)"U", &N, EigVec, &ldA, Eig, &worktest, &lwork, &info);
    if(info != 0){
        std::ostringstream err;
        err << "\nError in Lapack function 'dsyev': Lapack INFO = " << info << "\n";
        throw std::runtime_error(err.str());
    }
    lwork = (int)worktest;
    double* work= (double*)malloc(sizeof(double)*lwork);
    dsyev((char*)"V", (char*)"U", &N, EigVec, &ldA, Eig, work, &lwork, &info);
    if(info != 0){
        std::ostringstream err;
        err << "\n Error in Lapack function 'dsyev': Lapack INFO = " << info << "\n";
        throw std::runtime_error(err.str());
    }
    free(work);
}
