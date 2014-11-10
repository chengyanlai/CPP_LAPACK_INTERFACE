MODULE Interface_lapack
  USE nrtype, ONLY: DBL
  implicit none
  INTERFACE dia
     MODULE PROCEDURE ddiagonalize
     MODULE PROCEDURE zdiagonalize
  END INTERFACE

contains

!Diagonalize Hamitonian and reduced density matrix using LAPACK function(zheev).
  subroutine ddiagonalize(n, a, w)
    implicit none
    integer, intent(in) :: n                                     !dimension of hamitonian
    real(KIND=DBL), dimension(n, n) :: a          !diagolize a; output eigenvectors
    real(KIND=DBL) :: w(n)                           !output eigenvalues
    character(len=1), parameter :: jobz = 'V'        !"V" for eigenvalues and eigenvectors
    character(len=1), parameter :: uplo = 'U'        !"U" is upper triangular, "L" is lower one
    integer :: lda                                   !a(lda, n) basicly a is square matrix
    integer :: lwork         
    real(KIND=DBL), allocatable :: work(:) 
    integer :: info

    lda = n
    lwork = (3*n-1)

    allocate ( work(lwork) )

    call dsyev(jobz, uplo, n, a, lda, w, work, lwork, info)

    deallocate ( work )

    return
  end subroutine ddiagonalize
!Diagonalize Hamitonian and reduced density matrix using LAPACK function(zheev).
  subroutine zdiagonalize(n, a, w)
    implicit none
    character(len=1), parameter :: jobz = 'V'        !"V" for eigenvalues and eigenvectors
    character(len=1), parameter :: uplo = 'U'        !"U" is upper triangular, "L" is lower one
    integer :: n                                     !dimension of hamitonian
    integer :: lda                                   !a(lda, n); basicly a is square matrix
    complex(KIND=DBL), intent(in) :: a(n,n)          !diagolize a; output eigenvectors
    real(KIND=DBL) :: w(n)                           !output eigenvalues
    integer lwork         
    complex(KIND=DBL), allocatable :: work(:)         
    integer lrwork
    real(KIND=DBL), allocatable :: rwork(:)
    integer :: info
    
    lda = n
    lwork = (2*n-1)
    lrwork = (3*n-2)

    allocate ( work(lwork) )
    allocate ( rwork(lrwork) )

    call zheev(jobz, uplo, n, a, lda, w, work, lwork, rwork, info)

    deallocate ( work )
    deallocate ( rwork )

    return
  end subroutine zdiagonalize
  subroutine non_Hermitian(n,a,w)
    implicit none
    character(len=1), parameter :: jobvr='N'
    character(len=1), parameter :: jobvl='N'
    integer, intent(in) :: N
    integer info, lda, ldvl, ldvr, lwork
    real(KIND=DBL), allocatable :: rwork(:)
    complex(KIND=DBL), intent(out) :: w(n)
    complex(KIND=DBL), intent(inout) :: a(n,n)
    complex(KIND=DBL), allocatable :: vl(:,:),vr(:,:),work(:)

    w = cmplx(0.0E0_DBL,0.0E0_DBL)

    lda = n
    ldvl = n
    ldvr = n
    lwork = 2*n+1

    allocate( vl(ldvl,n) )
    allocate( vr(ldvr,n) )
    allocate( work(lwork) )
    allocate( rwork(2*n) )

    call zgeev(jobvl,jobvr,n,a,lda,w,vl,ldvl,vr,ldvr,work,lwork,rwork,info)

    deallocate( rwork )
    deallocate( work )
    deallocate( vr )
    deallocate( vl )

    if( info /= 0 ) then
       write(*,*) 'wrong in non_Hermitian'
       write(*,*) info
    end if

    return
  end subroutine non_Hermitian
  subroutine svd(n,a,w)
    implicit none
    character(len=1), parameter :: jobu='N'
    character(len=1), parameter :: jobvt='N'
    integer, intent(in) :: N
    integer info, lda, ldu, ldvt, lwork, m
    real(KIND=DBL), allocatable :: rwork(:)
    real(KIND=DBL), intent(out) :: w(n)
    complex(KIND=DBL), intent(inout) :: a(n,n)
    complex(KIND=DBL), allocatable :: u(:,:),vt(:,:),work(:)

    m = n
    lda = n
    ldu = n
    ldvt = n
    lwork = 4*n

    allocate( vt(ldvt,n) )
    allocate( u(ldu,m) )
    allocate( work(lwork) )
    allocate( rwork(5*n) )

    call ZGESVD(jobu,jobvt,m,n,a,lda,w,u,ldu,vt,ldvt,work,lwork,rwork,info)

    deallocate( rwork )
    deallocate( work )
    deallocate( u )
    deallocate( vt )

    if( info /= 0 ) then
       write(*,*) 'wrong in SVD'
       write(*,*) info
    end if

    return
  end subroutine svd
end MODULE Interface_lapack
