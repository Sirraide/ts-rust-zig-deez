SYS_read  equ 0
SYS_write equ 1
SYS_open  equ 2
SYS_close equ 3

;; Check a compile-time condition.
%macro static_assert 2
    %if %1 == 0
        %fatal Static assertion failed: %1. %2
    %endif
%endmacro

%macro static_assert 1
    %if %1 == 0
        %fatal Static assertion failed: %1
    %endif
%endmacro

;; Like std::vector.
struc vector
    .data: resq 1
    .size: resq 1
    .capacity: resq 1
endstruc

;; We try to keep as much state as possible in registers, but
;; sometimes we need to do a mini-‘context switch’, so the
;; macros below are used to facilitate that.

;; Save non-volatile registers
%macro saveregs 0
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    push gs
    sub rsp, 12 ; Align stack to 16-byte boundary.
%endmacro

;; Restore non-volatile registers
%macro rstorregs 0
    add rsp, 12 ; Undo alignment.
    pop gs
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
%endmacro

;; Libc functions.
section .text
extern putchar
extern puts
extern printf
extern strncmp
extern exit
extern abort
extern realloc
extern free

CACHE_LINE_SIZE equ 64

;; =============================================================================
;;  Constant data.
;; =============================================================================
section .rodata
error_usage db "Usage: ./lexer [<filename>]", 0
error_duplicate_filename db "ERROR: Must not specify more than one input file", 10, 0
error_open_read_failed db "ERROR: Could not open file for reading", 0
error_read_failed db "ERROR: Could not read from file", 0
error_integer_overflow db "ERROR: Integer overflow", 10, 0

string_format_read_file_error db "%s '%s' (errno: %i)", 10, 0
string_format_location db "%s at (%u:%u): ", 0
string_format_unexpected_character db "ERROR: Unexpected character U+%hhx ('%c')", 10, 0
string_format_string db "%s", 0
string_format_integer_token_value db " %llu", 10, 0
string_format_ident_token_value db " %.*s", 10, 0
string_format_read_errno db "ERROR: Read failed with errno %d", 10, 0

string_open_mode_read db "rb", 0
string_dot_exit db ".exit", 10, 0
string_default_filename db "<input>", 0
string_default_prompt db ">> ", 0
DEFAULT_PROMPT_SIZE equ $ - string_default_prompt - 1

;; =============================================================================
;;  Static variables.
;; =============================================================================
section .bss
filename resq 1
file_contents resq 1
file_size resq 1

prompt resq 1
prompt_size resq 1

;; State.
has_error resb 1