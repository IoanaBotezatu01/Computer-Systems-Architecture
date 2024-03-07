bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...

; our code starts here
segment code use32 class=code
    start:
        section .data
    prompt db 'Enter a string of numbers separated by spaces: ', 0
    min_num dq 0
    buffer db 1024 dup(0)
    min_file db 'min.txt', 0

section .text
global _start

_start:
    ; Print the prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, len(prompt)
    int 0x80

    ; Read input into buffer
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; Convert input to numbers
    mov edx, 0
    mov esi, buffer
    mov ebx, 10
    call parse_numbers

    ; Determine minimum number
    mov ecx, [numbers]
    mov edx, [numbers+4]
    mov esi, [numbers+8]
    mov edi, [numbers+12]
    mov [min_num], ecx
    cmp edx, [min_num]
    jl update_min
    cmp esi, [min_num]
    jl update_min
    cmp edi, [min_num]
    jl update_min

update_min:
    mov [min_num], edx

; Convert min_num to hexadecimal string
    mov ebx, 16
    mov ecx, min_num
    call convert_to_hex

; Write min_num to file
    mov eax, 4
    mov ebx, 1
    mov ecx, min_file
    mov edx, len(min_file)
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, min_num
    mov edx, len(min_num)
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
