PROGRAM LAPACKtest
  USE nrtype, ONLY: DBL
  USE Interface_lapack
  IMPLICIT NONE
  INTEGER, PARAMETER :: dim = 2
  REAL(KIND=DBL), DIMENSION(dim,dim) :: Matrix
  REAL(KIND=DBL), DIMENSION(dim) :: EigVal
  ! dummy
  INTEGER :: i

  ! Assign matrix elements by hand
  Matrix(1, 1) = 0.0
  Matrix(1, 2) = 1.0
  ! Matrix(1, 3) = 1.0
  Matrix(2, 1) = 1.0
  Matrix(2, 2) = 0.0
  ! Matrix(2, 3) = 1.0
  ! Matrix(3, 1) = 1.0
  ! Matrix(3, 2) = 1.0
  ! Matrix(3, 3) = 0.0

  CALL dia(dim, Matrix, EigVal)

  do i = 1, dim, 1
    write(*,*) "Eigenvalue:", EigVal(i), " with eigenvector."
    write(*,*) Matrix(:,i)
  end do
END PROGRAM
