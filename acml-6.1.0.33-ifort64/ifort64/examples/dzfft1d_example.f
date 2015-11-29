*     DZFFT1D Example Program Text
*
*     ACML version 5.0 Copyright AMD,NAG 2011
*
*     .. Parameters ..
      INTEGER          NMAX
      PARAMETER        (NMAX=20)
*     .. Local Scalars ..
      INTEGER          I, INFO, J, N
*     .. Local Arrays ..
      DOUBLE PRECISION COMM(4*NMAX+100), X(NMAX), XX(NMAX)
      DOUBLE COMPLEX Y(NMAX/2+1)
*     .. External Subroutines ..
      EXTERNAL         DZFFT1D, ZDFFT1D
*     .. Executable Statements ..
*
      WRITE (*,99998)
     *  'ACML example: FFT of a real sequence using DZFFT1D'
      WRITE (*,99998)
     *  '--------------------------------------------------'
      WRITE (*,*)
*
*     The sequence of complex data
      N = 7
      X(1) = 0.34907D0
      X(2) = 0.54890D0
      X(3) = 0.74776D0
      X(4) = 0.94459D0
      X(5) = 1.13850D0
      X(6) = 1.32850D0
      X(7) = 1.51370D0
      DO 10 I = 1, N
         XX(I) = X(I)
  10  CONTINUE
*
*     Initialize communication array COMM
      CALL DZFFT1D(0,N,X,Y,COMM,INFO)
*
*     Compute a real --> complex Hermitian transform.
      CALL DZFFT1D(1,N,X,Y,COMM,INFO)
*
      WRITE (*,99998) 'Components of discrete Fourier transform:'
      WRITE (*,*)
      DO 20 J = 1, N/2+1
         WRITE (*,99997) J, Y(J)
  20  CONTINUE
*
*     Compute the complex Hermitian --> real transform.
      CALL ZDFFT1D(2,N,Y,X,COMM,INFO)
*
      WRITE (*,*)
      WRITE (*,99998)
     *   'Original sequence as restored by inverse transform:'
      WRITE (*,*)
      WRITE (*,99998)'       Original  Restored'
      DO 40 J = 1, N
         WRITE (*,99999) J, XX(J), X(J)
  40  CONTINUE
*
99997 FORMAT (1X,I3,3X,"(",F7.4,F7.4,")")
99998 FORMAT (A)
99999 FORMAT (1X,I3,2(:3X,F7.4))
      END
