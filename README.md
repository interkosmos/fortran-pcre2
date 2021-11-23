# fortran-pcre2
A work-in-progress collection of Fortran 2018 ISO_C_BINDING interfaces to
PCRE2.

## Build Instructions
You will need *libpcre2* with development headers. On FreeBSD, run:

```
# pkg install devel/pcre2
```

Clone the repository and execute the provided `Makefile` to create the static
library `libfortran-pcre2.a` containing the interfaces:

```
$ git clone https://github.com/interkosmos/fortran-pcre2
$ cd fortran-pcre2/
$ make
```

Instead of `make`, you may want to build the library using the Fortran Package
Manager:

```
$ fpm build --profile release
```

Link your Fortran programs against `libfortran-pcre2.a` and `-lpcre2-8`.

## Example
The following program just compiles and executes a basic regular expression.

```fortran
program main
    use, intrinsic :: iso_c_binding
    use :: pcre
    implicit none (type, external)
    character(len=:), allocatable :: err
    integer                       :: err_offset, rc
    integer                       :: ovector(30)
    type(c_ptr)                   :: re

    re = pcre_compile('^([A-Z][a-z]+)$', 0, err, err_offset, c_null_ptr)

    if (.not. c_associated(re)) then
        print '("PCRE compilation failed at offset ",i0,": ",a)', err_offset, err
        stop
    end if

    rc = pcre_exec(re, c_null_ptr, 'Fortran', 7, 0, 0, ovector, size(ovector))

    if (rc < 0) then
        select case (rc)
            case (PCRE_ERROR_NOMATCH)
                print '("No match")'
            case default
                print '("Matching error ", i0)', rc
        end select
    else
        print '("Match succeeded at offset ", i0)', ovector(1)
    end if

    call pcre_free(re)
end program main
```

Compile, link, and run the program with, for example:

```
$ gfortran -o example example.f90 libfortran-pcre2.a -lpcre2-8
$ ./example
```

## fpm
You can add *fortran-pcre2* as an [fpm](https://github.com/fortran-lang/fpm)
dependency:

```toml
[dependencies]
fortran-pcre2 = { git = "https://github.com/interkosmos/fortran-pcre2.git" }
```

## Compatibility
It is not necessary to null-terminate character strings given to the procedures
of *fortran-pcre2*. In contrast to the C API of PCRE2, you must not free
substrings with `pcre2_substring_free()`, as this will be done by the wrapper
functions.

## Coverage

| C API                                | Fortran interface                   |
|--------------------------------------|-------------------------------------|
| `pcre2_code_free_8`                  |  `pcre2_code_free`                  |
| `pcre2_compile_8`                    |  `pcre2_compile`                    |
| `pcre2_compile_context_free_8`       |  `pcre2_compile_context_free`       |
| `pcre2_get_error_message_8`          |  `pcre2_get_error_message`          |
| `pcre2_get_ovector_count_8`          |  `pcre2_get_ovector_count`          |
| `pcre2_get_ovector_pointer_8`        |  `pcre2_get_ovector_pointer`        |
| `pcre2_match_8`                      |  `pcre2_match`                      |
| `pcre2_match_data_create_8`          |  `pcre2_match_data_create`          |
| `pcre2_match_data_free_8`            |  `pcre2_match_data_free`            |
| `pcre2_substring_copy_byname_8`      |  `pcre2_substring_copy_byname`      |
| `pcre2_substring_copy_bynumber_8`    |  `pcre2_substring_copy_bynumber`    |
| `pcre2_substring_get_byname_8`       |  `pcre2_substring_get_byname`       |
| `pcre2_substring_get_bynumber_8`     |  `pcre2_substring_get_bynumber`     |
| `pcre2_substring_number_from_name_8` |  `pcre2_substring_number_from_name` |

## Licence
ISC