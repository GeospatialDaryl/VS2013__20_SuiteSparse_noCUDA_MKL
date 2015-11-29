@ECHO off
REM This batch script will compile and run an example program
REM in the ACML examples directory. Supply the name of the
REM example program WITHOUT the .f or .c filename extension, e.g.
REM     acmlexample.bat cfft1d_example
REM or
REM     acmlexample.bat cfft1d_c_example

REM Cause all variables assigned in this script to be local
setlocal

REM Location of ACML installation - modify if necessary
set ACMLDIR=..

REM Set PATH to locate ACML dll at run time
PATH=%ACMLDIR%\lib;%PATH%

REM Compilers and compile flags - modify if necessary
set F77=ifort 
set FLINK=ifort 
set FFLAGS= -threads -MD 
set FLINKFLAGS= -threads -MD
set FLINKLIBS=
REM We compile and link with Microsoft C. We must link with the
REM PGI Fortran and C run time libraries also, using CLINKLIBS.
set CC=cl
set CFLAGS=-EHsc -MD "-I%ACMLDIR%/include"
set CLINK=cl
set CLINKFLAGS=-MD 
set CLINKLIBS=

REM Set these instead of the above if you want to use the PGI
REM C compiler instead of Microsoft C. We must link with the
REM PGI Fortran run time library also, using CLINKLIBS.
REM set CC=pgcc
REM set CLINK=pgcc
REM set CLINKLIBS=

REM The ACML library - modify if necessary
set LIBACML="%ACMLDIR%\lib\libacml_mp_dll.lib"

if exist "%1%.f" (
  set SOURCEFILE=%1%.f
  set OBJECTFILE=%1%.obj
  set EXEFILE=%1%.exe
  set RESFILE=%1%.res
  goto HANDLEFORTRAN
)
if exist "%1%.c" (
  set SOURCEFILE=%1%.c
  set OBJECTFILE=%1%.obj
  set EXEFILE=%1%.exe
  set RESFILE=%1%.res
  goto HANDLEC
)
if exist "%1%.cpp" (
  set SOURCEFILE=%1%.cpp
  set OBJECTFILE=%1%.obj
  set EXEFILE=%1%.exe
  set RESFILE=%1%.res
  goto HANDLEC
)
goto USAGE

REM Compile and run a Fortran program
:HANDLEFORTRAN
@ECHO on
  %F77% %FFLAGS% -c %SOURCEFILE% /obj:%OBJECTFILE%
  %FLINK% %FLINKFLAGS% %OBJECTFILE% %LIBACML% %FLINKLIBS% /exe:%EXEFILE%
  %EXEFILE% > %RESFILE%
@ECHO off
  type %RESFILE%
  if exist %OBJECTFILE% del %OBJECTFILE%
goto DONE

REM Compile and run a C or C++ program
:HANDLEC
@ECHO on
  %CC% %CFLAGS% -c %SOURCEFILE% /Fo%OBJECTFILE%
  %CLINK% %CLINKFLAGS% %OBJECTFILE% %LIBACML% %CLINKLIBS% /Fe%EXEFILE%
  %EXEFILE% > %RESFILE%
@ECHO off
  type %RESFILE%
  if exist %OBJECTFILE% del %OBJECTFILE%
goto DONE

:USAGE

echo.
echo                              %0%
echo.
echo  This batch file will compile, link and run an ACML example program.
echo.
echo    Usage: %0% program
echo.
echo  where program is the name of the example program WITHOUT the
echo  .f, .c or .cpp extension.
echo.
echo  For example:    %0% cfft1d_example
echo            or    %0% cfft1d_c_example
echo            or    %0% sgetrf_cpp_example
echo.

goto DONE

:DONE
