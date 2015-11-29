*     DZFFT2D Example Program Text
*
*     ACML version 5.0 Copyright AMD,NAG 2011
*
*     .. Parameters ..
      INTEGER          MMAX, NMAX
      PARAMETER        (MMAX=20, NMAX=20)
*     .. Local Scalars ..
      INTEGER          I, INFO, IX, J, M, N
*     .. Local Arrays ..
      DOUBLE PRECISION COMM(4*MMAX+6*NMAX+300), 
     *     X(MMAX*NMAX), XX(MMAX*NMAX)
      DOUBLE COMPLEX Y((MMAX/2+1)*NMAX)
*     .. External Subroutines ..
      EXTERNAL         DZFFT2D, ZDFFT2D
*     .. Executable Statements ..
*
      WRITE (*,99998)
     *  'ACML example: FFT of a real sequence using DZFFT2D'
      WRITE (*,99998)
     *  '--------------------------------------------------'
      WRITE (*,*)
*
*     The sequence of real data
      M = 5
      N = 2
      IX = 1
      DO J = 1, N
         DO I = 1, M
            X(IX) = 1.0D0 + COS(DBLE(J+2*I))
            XX(IX) = X(IX)
            IX = IX + 1
         END DO
      END DO
*
*     Initialize communication array COMM
      CALL DZFFT2D(0,M,N,X,Y,COMM,INFO)
*
*     Compute a real --> complex Hermitian transform.
      CALL DZFFT2D(1,M,N,X,Y,COMM,INFO)
*
      WRITE (*,99998) 'Components of discrete Fourier transform:'
      WRITE (*,*)
      IX = 1
      DO J = 1, N
         WRITE (*,FMT=99997) 'Column Number ', J
         WRITE (*,FMT=99998) '          Real    Imag'
         DO I = 1, M/2+1
            WRITE (*,FMT=99999) I, Y(IX)
            IX = IX + 1
         END DO
      END DO
*
*     Compute the complex Hermitian --> real transform.
      CALL ZDFFT2D(2,M,N,Y,X,COMM,INFO)
*
      WRITE (*,*)
      WRITE (*,99998)
     *   'Original sequence as restored by inverse transform:'
      WRITE (*,*)
      WRITE (*,99998)'       Original  Restored'
      IX = 1
      DO J = 1, N
         WRITE (*,FMT=99997) 'Column Number ', J
         DO I = 1, M
            WRITE (*,FMT=99996) I, XX(IX), X(IX)
            IX = IX + 1
         END DO
      END DO
*
99997 FORMAT (A,I3)
99998 FORMAT (A)
99999 FORMAT (1X,I3,2(:3X,'(',F7.4,',',F7.4,')'))
99996 FORMAT (1X,I3,2(:3X,F7.4))
      END
