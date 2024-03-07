bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf           ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    formn db "Number of elements:%d",10,13,0
    format db "%d",10,13,0
    n dd 0
    a dd 0
    nr db 0
    ten db 10
; our code starts here
segment code use32 class=code
    start:
        ;B. Read from standard input (console keyboard) an array of numbers with at most 15 digits in total. Use the digits of the numbers to create the biggest integer number and print it in a file. You may print the number digit by digit (so represent it as an array) or (ideally) build it into a quad (15 digits in total ensures it fits a quad).

        ;Ex. from array 10, 45, 200, 86 with a total of 9 digits, we can create the biggest number to be 865421000 
        
        push dword n
        push dword formn
        call [scanf]
        add esp,4*2
        
        mov ecx,3
        jecxz endloop
        readn:
            
            push dword a
            push dword format
            call [scanf]
            add esp,4*2
            
            dec ecx
            jecxz endloop
            loop readn 
            
            mov  byte [nr],0
            nrc:
                mov AX,[a]
                div byte [ten]
                add byte [nr],1
                cmp ax,0
                ja nrc
                
            cmp ECX,1
            je endloop
            
            multip:
                add ebx,[a]
                mul dword [ten]
                sub byte [nr],1
                cmp byte [nr],0
                ja multip
            
            endloop:
            push dword [a]
            push dword format
            call [printf]
            add esp,4*2
            
            
        
            
        push dword EBX
        push dword format
        call [printf]
        add esp,4*2
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
