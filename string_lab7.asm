bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir  dq  00123110110abcb0h,1116adcb5a051ad2h,4120ca11d730cbb0h
               ;0012       3110    11 0a bc b0h
               ; -12-
               ;b0 bc 0a 11 10 31 12 00
    len equ($-sir)/8  ; length in quadwords
    opt db 9
    zece dd 10
    suma dd 0
; our code starts here
;https://www.cs.ubbcluj.ro/~alinacalin/ASC/Cresources.html
segment code use32 class=code
    start:
        mov bl,0
        mov esi,sir
        mov ECX,len
        my_loop:
            lodsd; EAX-first dword and esi+4
            lodsw; AX -low word on the high dword  esi+2
            lodsw; AX-high word esi+2
            ;AL 
            mov ah,0;AL->AX
            div byte [opt]
            cmp AH,0
            jne donotcount
                inc bl
            donotcount:
        loop my_loop
        
        ;bl-sum og digits
        mov EAX,123456
        ;mov AL,BL
        ;EAX sum of digits
        
        mov EBX,0
        sum_digits:
            mov edx,0   ;ESX:EAX
            div dword [zece]    ;EDX-remainder  EAX-quotient
            add EBX,EDX
            cmp EAX,0
        jne sum_digits
            
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
