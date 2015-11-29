
/* dzfft1d Example Program Text */
/*
 * ACML version 5.0 Copyright AMD,NAG 2011
 */

#include <acml.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
#define NMAX 20
  int i, info, j, n;
  double x[NMAX], xx[NMAX];
  doublecomplex y[NMAX/2+1];
  double *comm;

  printf("ACML example: FFT of a real sequence using DZFFT1D\n");
  printf("--------------------------------------------------\n");
  printf("\n");

  /* The sequence of double data */
  n = 7;
  x[0] = 0.34907;
  x[1] = 0.54890;
  x[2] = 0.74776;
  x[3] = 0.94459;
  x[4] = 1.13850;
  x[5] = 1.32850;
  x[6] = 1.51370;
  for (i = 0; i < n; i++)
    xx[i] = x[i];

  /* Allocate communication work array */
  comm = (double *)malloc((4*n+100)*sizeof(double));

  /* Initialize communication work array */
  dzfft1d(0,n,x,y,comm,&info);

  /* Compute a real --> Hermitian transform */
  dzfft1d(1,n,x,y,comm,&info);

  printf("Components of discrete Fourier transform:\n");
  printf("\n");
  for (j = 0; j <= n/2; j++)
    printf("%4d   (%7.4f%7.4f)\n", j+1, y[j].real, y[j].imag);

  /* Compute the complex Hermitian --> real transform */
  zdfft1d(2,n,y,x,comm,&info);

  printf("\n");
  printf("Original sequence as restored by inverse transform:\n");
  printf("\n");
  printf("       Original  Restored\n");
  for (j = 0; j < n; j++)
    printf("%4d   %7.4f   %7.4f\n", j+1, xx[j], x[j]);

  free(comm);
  return 0;
}
