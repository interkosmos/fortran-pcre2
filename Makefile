.POSIX:

FC      = gfortran
PREFIX  = /usr/local
FFLAGS  = -Wall -Wno-maybe-uninitialized -fmax-errors=1 -fcheck=all
LDFLAGS = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
LDLIBS  = -lpcre2-8
ARFLAGS = rcs
TARGET  = libfortran-pcre2.a
TEST    = test_pcre2

.PHONY: all clean

all: $(TARGET) $(TEST)

$(TARGET): src/pcre2.f90
	$(FC) $(FFLAGS) -c src/pcre2.f90
	$(AR) $(ARFLAGS) $(TARGET) pcre2.o

$(TEST): test/test_pcre2.f90
	$(FC) $(FFLAGS) $(LDFLAGS) -o $(TEST) test/test_pcre2.f90 $(TARGET) $(LDLIBS)

clean:
	rm $(TARGET)
	rm $(TEST)
	rm *.o
	rm *.mod

