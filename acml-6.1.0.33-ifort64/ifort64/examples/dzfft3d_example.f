*     DZFFT3D Example Program Text
*
*     ACML version 5.0 Copyright AMD,NAG 2011
*
*     .. Parameters ..
      INTEGER          LMAX, MMAX, NMAX
      PARAMETER        (LMAX=5, MMAX=2, NMAX=2)
*     .. Local Scalars ..
      INTEGER          I, INFO, IX, J, K, L, M, N
*     .. Local Arrays ..
      DOUBLE PRECISION COMM(4*LMAX+6*MMAX+6*NMAX+500), 
     *     X(LMAX*MMAX*NMAX), XX(LMAX*MMAX*NMAX)
      DOUBLE COMPLEX Y((LMAX/2+1)*MMAX*NMAX)
*     .. External Subroutines ..
      EXTERNAL         DZFFT3D, ZDFFT3D
*     .. Executable Statements ..
*
      WRITE (*,99998)
     *  'ACML example: FFT of a real sequence using DZFFT3D'
      WRITE (*,99998)
     *  '--------------------------------------------------'
      WRITE (*,*)
*
*     The sequence of real data
      L = 5
      M = 2
      N = 2
      IX = 1
      DO K = 1, N
         DO J = 1, M
            DO I = 1, L
               X(IX) = 1.0D0 + COS(DBLE(IX))
               XX(IX) = X(IX)
               IX = IX + 1
            END DO
         END DO
      END DO
*
*     Initialize communication array COMM
      CALL DZFFT3D(0,L,M,N,X,Y,COMM,INFO)
*
*     Compute a real --> complex Hermitian transform.
      CALL DZFFT3D(1,L,M,N,X,Y,COMM,INFO)
*
      WRITE (*,99998) 'Components of discrete Fourier transform:'
      WRITE (*,*)
      IX = 1
      DO K = 1, N
         WRITE (*,FMT=*)
         WRITE (*,FMT=99997) 'Third dimension index = ', K
         DO J = 1, M
            WRITE (*,FMT=99997) 'Column Number ', J
            WRITE (*,FMT=99998) '          Real    Imag'
            DO I = 1, L/2+1
               WRITE (*,FMT=99999) I, Y(IX)
               IX = IX + 1
            END DO
         END DO
      END DO
*
*     Compute the complex Hermitian --> real transform.
      CALL ZDFFT3D(2,L,M,N,Y,X,COMM,INFO)
*
      WRITE (*,*)
      WRITE (*,99998)
     *   'Original sequence as restored by inverse transform:'
      WRITE (*,*)
      WRITE (*,99998)'       Original  Restored'
      IX = 1
      DO K = 1, N
         WRITE (*,FMT=*)
         WRITE (*,FMT=99997) 'Third dimension index = ', K
         DO J = 1, M
            WRITE (*,FMT=99997) 'Column Number ', J
            DO I = 1, L
               WRITE (*,FMT=99996) I, XX(IX), X(IX)
               IX = IX + 1
            END DO
         END DO
      END DO
*
99997 FORMAT (A,I3)
99998 FORMAT (A)
99999 FORMAT (1X,I3,2(:3X,'(',F7.4,',',F7.4,')'))
99996 FORMAT (1X,I3,2(:3X,F7.4))
      END
