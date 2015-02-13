#include <iostream>
#include "myLapack.h"

int main(){
    int dim = 3;
    double * Matrix;
    double * EigVec;
    double * Eig;

    EigVec = new double[dim*dim];
    Eig = new double[dim];

    Matrix = new double[dim*dim];
    std::fill(Matrix, Matrix+dim*dim, 0.0e0);

    Matrix[0]=0.0;
    Matrix[1]=1.0;
    Matrix[2]=1.0;
    Matrix[3]=1.0;
    Matrix[4]=0.0;
    Matrix[5]=1.0;
    Matrix[6]=1.0;
    Matrix[7]=1.0;
    Matrix[8]=0.0;

    Diag(Matrix, dim, Eig, EigVec);

    printf("Eigenvalues\n");
    for (int i=0; i < dim; i++) printf(" %17.10e ", Eig[i]);

    printf("\n\n");
    printf("Eigenvectors\n");
    for (int i=0; i < dim; i++)
    {
        for (int j=0; j < dim; j++)
        {
            printf(" %17.10e ", EigVec[j*dim+i]);
        }
        printf("\n");
    }
    printf("\n");
}
