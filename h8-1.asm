bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll   ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; Read one byte and one word from the keyboard. Print on the screen "YES" if the bits of the byte read are found consecutively among the bits of the word and "NO" otherwise. Example: a = 10 = 0000 1010b
    ;b = 256 = 0000 0001 0000 0000b
    ;The value printed on the screen will be NO.
    ;a = 0Ah = 0000 1010b
    ;b = 6151h = 0110 0001 0101 0001b
    ;The value printed on the screen will be YES (you can find the bits on positions 5-12).
    
    format_a db "First number = %d", 10, 13, 0
    a dd 0
    first_number db "%d", 0    
    b dd 0
    format_b db "Second number = %d", 10, 13, 0
    second_number dw "%d", 0
    
    
    format_yes db "YES",0
    format_no db "NO",0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; read first number
        push dword a
        push dword first_number
        call [scanf]
        add esp, 4*2

        push dword [a]
        push dword format_a
        call [printf]
        add esp, 4*2
        
        ; read second number
        push dword b
        push dword second_number
        call [scanf]
        add esp, 4*2

        push dword [b]
        push dword format_b
        call [printf]
        add esp, 4*2
        
        
            
        mov AX,[b]
        and AX,0000000011111111b
        xor AX,[a]  ;ax becomes 0 if the bits are the same
        cmp AX,0
        je end_yes
        
        mov BX,[b]
        mov ECX,16
        jecxz end_no
        shift:
            shr BX,1
            mov AX,BX
            and AX,0000000011111111b
            xor AX,[a]  ;ax becomes 0 if the bits are the same
            cmp AX,0
            je end_yes      ;if the last 8 bits are equal to the bits of a =>b contains the bits of a=>"YES"
                            ;else
        loop shift         ;we shift the bits of b to the right until we find a sequence of bits equal to add
        end_no:            ;if our number is shifted 16 times,it means that b does not contain a      
            push dword format_no
            call [printf]
            add esp,4*1
        jmp end_p
        
        end_yes:
            push dword format_yes
            call [printf]
            add esp,4*1
        
        end_p:
        
       
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program