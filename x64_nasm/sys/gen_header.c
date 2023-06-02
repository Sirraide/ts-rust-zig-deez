///
/// NASM can’t include C headers, so this reads the values of whatever macros
/// we need and writes them to stdout in a format that NASM can include.
///

#include <stdio.h>
#include <stdint.h>
#include <sys/syscall.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <inttypes.h>

int main() {
    printf(
        ";; This is a generated file. DO NOT EDIT.\n"
        "\n"
        "%%line 3 \"sys.asm\"\n"
        "\n"
        ";; Syscalls\n"
        "SYS_read  equ %" PRIiPTR "\n"
        "SYS_write equ %" PRIiPTR "\n"
        "SYS_open  equ %" PRIiPTR "\n"
        "SYS_close equ %" PRIiPTR "\n"
        "SYS_stat  equ %" PRIiPTR "\n"
        "SYS_mmap  equ %" PRIiPTR "\n"
        "\n"
        ";; Other constants\n"
        "O_RDONLY equ %" PRIiPTR "\n"
        "O_WRONLY equ %" PRIiPTR "\n"
        "\n"
        "STDIN_FILENO  equ %" PRIiPTR "\n"
        "STDOUT_FILENO equ %" PRIiPTR "\n"
        "STDERR_FILENO equ %" PRIiPTR "\n"
        "\n"
        "MAP_PRIVATE equ %" PRIiPTR "\n"
        "MAP_FAILED  equ %" PRIiPTR "\n"
        "\n"
        "SIZE_OF_STRUCT_STAT equ %" PRIiPTR "\n",
        (intptr_t) __NR_read,
        (intptr_t) __NR_write,
        (intptr_t) __NR_open,
        (intptr_t) __NR_close,
        (intptr_t) __NR_stat,
        (intptr_t) __NR_mmap,
        (intptr_t) O_RDONLY,
        (intptr_t) O_WRONLY,
        (intptr_t) STDIN_FILENO,
        (intptr_t) STDOUT_FILENO,
        (intptr_t) STDERR_FILENO,
        (intptr_t) MAP_PRIVATE,
        (intptr_t) MAP_FAILED,
        (intptr_t) sizeof(struct stat)
    );
}