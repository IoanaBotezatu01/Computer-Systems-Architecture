bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 2, 1, 3, -3, -4, 2, -6
    lena equ $-a      ;number of bites
    b db 4, 5, -5, 7, -6, -2, 1
    lenb equ $-b
    two db 2
        
    ten db 10
    r times lena dw 0 ;r: that contains only the even negative elements of the two strings   
    ;r:-4, -6, -6, -2

; our code starts here
segment code use32 class=code
    start:
        ;STRING A
        mov ECX,lena
        mov ESI,0   ;index for a
        mov EDI,0   ;index of r
        jecxz end_loop
        add_:
            mov AL,[a+esi]
            cbw
            idiv byte[two]       ;AL=ax/2    AH=AX%2
            cmp AH,0
            jz add_even
            jmp end_instruction1
            add_even:
                mov DL,[a+ESI]
                cmp DL,0
                jl add_neg1
                jmp end_instruction1
                add_neg1:
                mov [r+edi],DL
                inc esi
                inc EDI
                jmp exit1
            end_instruction1:
            inc esi
            exit1:
        loop add_
        end_loop:
        
        ;STRING B
        mov ECX,lenb
        mov ESI,0   ;index for a
        jecxz end_loop1
        add_1:
            mov AL,[b+esi]
            cbw
            idiv byte[two]       ;AL=ax/2    AH=AX%2
            cmp AH,0
            jz add_even2
            jmp end_instruction2
            add_even2:
                mov DL,[b+ESI]
                cmp DL,0
                jl add_neg2
                jmp end_instruction2
                add_neg2:
                mov [r+edi],DL
                inc esi
                inc EDI
                jmp exit2
            end_instruction2:
            inc esi
            exit2:
        loop add_1
        end_loop1:
        
        
        
        
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
