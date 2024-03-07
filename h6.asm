bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf             ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll       ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 db 12,24,30,58,90,47
    len1 equ $-s1
    s2 db 24,58,90
    len2 equ $-s2
    r times len2 db 0
    ;r: 1,3,4
    format db "MY STRING:%s",0

; our code starts here
segment code use32 class=code
    start:
        ; Being given two strings of bytes, compute all positions where the second string appears as a substring in the first string.
        cld     ;DF=0
        mov ECX,len1    ;ECX=6
        mov EDI,0
        mov EDX,0
        mov ESI,s2
        
        jecxz end_loop
        find:
            lodsb       ;AL=<DS:ESI>
            cmp AL,[s1+EDI]
            jne exit1
                mov [r+edx],EDI   
                inc edx
                inc esi 
            exit1:
           dec esi
           inc EDI
        loop find       ;ECX-1
        end_loop:
        
        push r
        push dword format
        call [printf]
        add esp, 4*2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
