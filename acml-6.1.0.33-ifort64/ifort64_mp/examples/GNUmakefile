
# GNUmakefile to build and execute ACML example programs

# Fortran and C compilers and flags (modify if necessary)
#
# Location of ACML installation
ACMLDIR := ".."

F77 := ifort
FLINK := $(F77)
FFLAGS :=  -threads -MD
FLINKFLAGS := -threads -MD
FLINKLIBS :=
CC := cl
CFLAGS := -I$(ACMLDIR)/include -MD
CLINK := $(CC)
CLINKFLAGS := -MD
CLINKLIBS :=
CPLUSPLUS := cl
CPLUSPLUSFLAGS := -I$(ACMLDIR)/include -MD -EHsc
CPLUSPLUSLINK := $(CPLUSPLUS)
CPLUSPLUSLINKFLAGS := -MD
CPLUSPLUSLINKLIBS :=

CYGDRIVE := $(shell mount -p | tail -1 | sed -e 's/ .*//')
ACMLCYGWINDIR := $(shell (echo $(ACMLDIR) | sed -e "sX\(.\):X$(CYGDRIVE)/\1X"))
EXPORT_PATH := export PATH='$(ACMLCYGWINDIR)/lib:$(PATH)'

obj := obj 

.SUFFIXES: .f .c .cpp .$(obj) .exe .res .diff .expected

LIBACML := $(ACMLDIR)"\lib\libacml_mp_dll.lib"

# Source code of Fortran example programs
FSOURCE := acmlinfo.f sgetrf_example.f dgetrf_example.f \
	   cfft1d_example.f zfft1d_example.f dzfft_example.f \
           zfft1dx_example.f zfft1mx_example.f zfft2dx_example.f \
           zfft3dx_example.f drandinitializeuser_example.f \
           drandskipleap_example.f dranduniform_example.f \
	   dzfft1d_example.f dzfft2d_example.f dzfft3d_example.f

FEXE := $(FSOURCE:.f=.exe)

# Source code of C example programs
CSOURCE := cdotu_c_example.c cfft1d_c_example.c cgels_c_example.c \
	   cgesv_c_example.c sgels_c_example.c sgesv_c_example.c \
	   sgetrf_c_example.c zfft1d_c_example.c zgels_c_example.c \
	   dgesdd_c_example.c dzfft_c_example.c \
           drandinitializeuser_c_example.c dranduniform_c_example.c \
           drandskipleap_c_example.c \
           dzfft1d_c_example.c

CEXE := $(CSOURCE:.c=.exe)

# Source code of C++ example programs
CPLUSPLUSSOURCE := sgetrf_cpp_example.cpp
CPLUSPLUSEXE := $(CPLUSPLUSSOURCE:.cpp=.exe)

RESULTS := $(FSOURCE:.f=.res) $(CSOURCE:.c=.res) $(CPLUSPLUSSOURCE:.cpp=.res) 

all: $(RESULTS) diffs

# Rule to compile/run a Fortran example program and produce a .res file
.f.res:
	@echo ""
	@echo "Compiling program $*.f:"
	$(F77) -c $(FFLAGS) $*.f /obj:$*.$(obj)
	@echo "Linking program $*.exe:"
	$(FLINK) $(FLINKFLAGS) $*.$(obj) $(LIBACML) $(FLINKLIBS) /exe:$*.exe
	@echo "Running program $*.exe:"
	($(EXPORT_PATH); ./$*.exe > $*.res 2>&1)
#       Show the results
	@cat $@
#	Compare the results with the expected results
	@diff -w $@ $*.expected 2>&1 | cat > $*.diff
#       Ignore the acmlinfo example which will almost always be different
	@rm -f acmlinfo.diff
#       Delete the diff file if it is empty
	@if [ -s $*.diff ]; then \
	  echo "!!! $* has diffs !!!"; \
	else \
	  rm -f $*.diff; \
	fi

# Rule to compile/run a C example program and produce a .res file
.c.res:
	@echo ""
	@echo "Compiling program $*.c:"
	$(CC) -c $(CFLAGS) $*.c /Fo$*.$(obj)
	@echo "Linking program $*.exe:"
	$(CLINK) $(CLINKFLAGS) $*.$(obj) $(LIBACML) $(CLINKLIBS) /Fe$*.exe
	@echo "Running program $*.exe:"
	($(EXPORT_PATH); ./$*.exe > $*.res 2>&1)
#       Show the results
	@cat $@
#	Compare the results with the expected results
	@diff -w $@ $*.expected 2>&1 | cat > $*.diff
#       Delete the diff file if it is empty
	@if [ -s $*.diff ]; then \
	  echo "!!! $* has diffs !!!"; \
	else \
	  rm -f $*.diff; \
	fi

# Rule to compile/run a C++ example program and produce a .res file
.cpp.res:
	@echo ""
	@echo "Compiling program $*.cpp:"
	$(CPLUSPLUS) -c $(CPLUSPLUSFLAGS) $*.cpp /Fo$*.$(obj)
	@echo "Linking program $*.exe:"
	$(CPLUSPLUSLINK) $(CPLUSPLUSLINKFLAGS) $*.$(obj) $(LIBACML) $(CPLUSPLUSLINKLIBS) /Fe$*.exe
	@echo "Running program $*.exe:"
	($(EXPORT_PATH); ./$*.exe > $*.res 2>&1)
#       Show the results
	@cat $@
#	Compare the results with the expected results
	@diff -w $@ $*.expected 2>&1 | cat > $*.diff
#       Delete the diff file if it is empty
	@if [ -s $*.diff ]; then \
	  echo "!!! $* has diffs !!!"; \
	else \
	  rm -f $*.diff; \
	fi

diffs: $(RESULTS)
	@(ndiff=`ls *.diff 2> /dev/null | wc -w | sed -e 's/ //g'` ; \
	  echo ""; \
	  if [ "$${ndiff}" = "0" ]; then \
	    echo "Testing: no example difference files were generated."; \
	    echo "Test passed OK"; \
	  else \
	    echo "Testing: $${ndiff} example difference files were generated:"; \
	    ls -l *.diff; \
	  fi)

clean:
	rm -f $(FEXE) $(CEXE) $(CPLUSPLUSEXE) \
	      $(FSOURCE:.f=.$(obj)) $(CSOURCE:.c=.$(obj)) \
	      $(CPLUSPLUSSOURCE:.cpp=.$(obj)) \
	      $(RESULTS) *.diff $(RESULTS:.res=.exe.manifest)
