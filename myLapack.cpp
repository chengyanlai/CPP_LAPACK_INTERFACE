#ifdef OSX
    #include <Accelerate/Accelerate.h>//On OSX
#elif defined MKL
    #include "mkl.h"
#endif

#include "myLapack.h"

void Diag(double* Kij, int N, double* Eig, double* EigVec)
{
    memcpy(EigVec, Kij, (unsigned long)N * (unsigned long)N * sizeof(double));
    int ldA = N;
    int lwork = 4*N;
    double* work= (double*)malloc((unsigned long)lwork * sizeof(double));
    int info;
#ifdef OSX
    dsyev_((char*)"V", (char*)"U", &N, EigVec, &ldA, Eig, work, &lwork, &info);//On OSX
#elif defined MKL
    dsyev((char*)"V", (char*)"U", &N, EigVec, &ldA, Eig, work, &lwork, &info);//On MKL
#endif
    assert(info == 0);
    free(work);
}
